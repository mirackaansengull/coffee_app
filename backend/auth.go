package main

import (
	"context"
	"crypto/rand"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"golang.org/x/crypto/bcrypt"
)

const (
	codeExpiry = 10 * time.Minute
	jwtExpiry  = 7 * 24 * time.Hour
)

var (
	usersCol  *mongo.Collection
	codesCol  *mongo.Collection
	jwtSecret []byte
)

func initAuth(db *mongo.Database) {
	usersCol = db.Collection("users")
	codesCol = db.Collection("verification_codes")
	if s := os.Getenv("JWT_SECRET"); s != "" {
		jwtSecret = []byte(s)
	} else {
		jwtSecret = []byte("kahve-app-default-secret-change-in-production")
	}
}

func generateCode() string {
	const digits = "0123456789"
	b := make([]byte, 6)
	if _, err := rand.Read(b); err != nil {
		return fmt.Sprintf("%06d", time.Now().UnixNano()%1000000)
	}
	for i := range b {
		b[i] = digits[int(b[i])%10]
	}
	return string(b)
}

func sendRegisterCode(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	var req struct {
		Email string `json:"email"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"Geçerli email gerekli"}`, http.StatusBadRequest)
		return
	}
	req.Email = strings.TrimSpace(strings.ToLower(req.Email))
	if req.Email == "" {
		http.Error(w, `{"error":"Geçerli email gerekli"}`, http.StatusBadRequest)
		return
	}
	ctx := r.Context()
	var existing User
	err := usersCol.FindOne(ctx, bson.M{"email": req.Email}).Decode(&existing)
	if err == nil {
		http.Error(w, `{"error":"Bu email adresi zaten kayıtlı"}`, http.StatusConflict)
		return
	}
	code := generateCode()
	_, _ = codesCol.DeleteMany(ctx, bson.M{"email": req.Email, "type": VerificationTypeRegister})
	_, err = codesCol.InsertOne(ctx, bson.M{
		"email":     req.Email,
		"code":      code,
		"type":      VerificationTypeRegister,
		"expiresAt": time.Now().Add(codeExpiry),
	})
	if err != nil {
		http.Error(w, `{"error":"Kod kaydedilemedi"}`, http.StatusInternalServerError)
		return
	}
	if err := sendVerificationCode(req.Email, code, "Kayıt doğrulama kodu", "Kahve App'e hoş geldiniz. Kayıt işlemini tamamlamak için aşağıdaki kodu kullanın."); err != nil {
		http.Error(w, `{"error":"E-posta gönderilemedi: `+err.Error()+`"}`, http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{"message": "Doğrulama kodu e-posta adresinize gönderildi."})
}

func verifyRegister(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	var req struct {
		Email    string `json:"email"`
		Code     string `json:"code"`
		Password string `json:"password"`
		Name     string `json:"name"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"Geçersiz istek"}`, http.StatusBadRequest)
		return
	}
	req.Email = strings.TrimSpace(strings.ToLower(req.Email))
	req.Code = strings.TrimSpace(req.Code)
	if req.Email == "" || req.Code == "" || len(req.Password) < 6 {
		http.Error(w, `{"error":"Email, 6 haneli kod ve en az 6 karakter şifre gerekli"}`, http.StatusBadRequest)
		return
	}
	ctx := r.Context()
	var doc struct {
		Code      string    `bson:"code"`
		ExpiresAt time.Time `bson:"expiresAt"`
	}
	err := codesCol.FindOne(ctx, bson.M{"email": req.Email, "type": VerificationTypeRegister}).Decode(&doc)
	if err != nil || doc.Code != req.Code || time.Now().After(doc.ExpiresAt) {
		http.Error(w, `{"error":"Geçersiz veya süresi dolmuş kod"}`, http.StatusBadRequest)
		return
	}
	hashed, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		http.Error(w, `{"error":"Şifre işlenemedi"}`, http.StatusInternalServerError)
		return
	}
	now := time.Now()
	userID := primitive.NewObjectID()
	user := User{
		ID: userID, Email: req.Email, Password: string(hashed),
		Name: strings.TrimSpace(req.Name), IsAdmin: false, CreatedAt: now,
	}
	doc := bson.M{
		"_id":       userID,
		"email":     req.Email,
		"password": string(hashed),
		"name":      strings.TrimSpace(req.Name),
		"isAdmin":   false,
		"createdAt": now,
	}
	_, err = usersCol.InsertOne(ctx, doc)
	if err != nil {
		http.Error(w, `{"error":"Kullanıcı oluşturulamadı"}`, http.StatusInternalServerError)
		return
	}
	_, _ = codesCol.DeleteMany(ctx, bson.M{"email": req.Email, "type": VerificationTypeRegister})
	token, _ := createToken(user.ID.Hex(), user.Email)
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]any{
		"token": token,
		"user":  map[string]any{"id": user.ID.Hex(), "email": user.Email, "name": user.Name, "isAdmin": user.IsAdmin},
	})
}

func login(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	var req struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"Geçersiz istek"}`, http.StatusBadRequest)
		return
	}
	req.Email = strings.TrimSpace(strings.ToLower(req.Email))
	if req.Email == "" || req.Password == "" {
		http.Error(w, `{"error":"Email ve şifre gerekli"}`, http.StatusBadRequest)
		return
	}
	ctx := r.Context()
	var user User
	err := usersCol.FindOne(ctx, bson.M{"email": req.Email}).Decode(&user)
	if err != nil {
		http.Error(w, `{"error":"Email veya şifre hatalı"}`, http.StatusUnauthorized)
		return
	}
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password)); err != nil {
		http.Error(w, `{"error":"Email veya şifre hatalı"}`, http.StatusUnauthorized)
		return
	}
	token, _ := createToken(user.ID.Hex(), user.Email)
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]any{
		"token": token,
		"user":  map[string]any{"id": user.ID.Hex(), "email": user.Email, "name": user.Name, "isAdmin": user.IsAdmin},
	})
}

func sendResetCode(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	var req struct {
		Email string `json:"email"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"Geçerli email gerekli"}`, http.StatusBadRequest)
		return
	}
	req.Email = strings.TrimSpace(strings.ToLower(req.Email))
	if req.Email == "" {
		http.Error(w, `{"error":"Geçerli email gerekli"}`, http.StatusBadRequest)
		return
	}
	ctx := r.Context()
	var user User
	if usersCol.FindOne(ctx, bson.M{"email": req.Email}).Decode(&user) != nil {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]string{"message": "Şifre sıfırlama kodu e-posta adresinize gönderildi."})
		return
	}
	code := generateCode()
	_, _ = codesCol.DeleteMany(ctx, bson.M{"email": req.Email, "type": VerificationTypeResetPassword})
	_, _ = codesCol.InsertOne(ctx, bson.M{
		"email":     req.Email,
		"code":      code,
		"type":      VerificationTypeResetPassword,
		"expiresAt": time.Now().Add(codeExpiry),
	})
	if err := sendVerificationCode(req.Email, code, "Şifre sıfırlama kodu", "Şifrenizi sıfırlamak için aşağıdaki kodu kullanın."); err != nil {
		http.Error(w, `{"error":"E-posta gönderilemedi"}`, http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{"message": "Şifre sıfırlama kodu e-posta adresinize gönderildi."})
}

func resetPassword(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	var req struct {
		Email       string `json:"email"`
		Code        string `json:"code"`
		NewPassword string `json:"newPassword"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"Geçersiz istek"}`, http.StatusBadRequest)
		return
	}
	req.Email = strings.TrimSpace(strings.ToLower(req.Email))
	req.Code = strings.TrimSpace(req.Code)
	if req.Email == "" || req.Code == "" || len(req.NewPassword) < 6 {
		http.Error(w, `{"error":"Email, kod ve en az 6 karakter yeni şifre gerekli"}`, http.StatusBadRequest)
		return
	}
	ctx := r.Context()
	var doc struct {
		Code      string    `bson:"code"`
		ExpiresAt time.Time `bson:"expiresAt"`
	}
	err := codesCol.FindOne(ctx, bson.M{"email": req.Email, "type": VerificationTypeResetPassword}).Decode(&doc)
	if err != nil || doc.Code != req.Code || time.Now().After(doc.ExpiresAt) {
		http.Error(w, `{"error":"Geçersiz veya süresi dolmuş kod"}`, http.StatusBadRequest)
		return
	}
	hashed, err := bcrypt.GenerateFromPassword([]byte(req.NewPassword), bcrypt.DefaultCost)
	if err != nil {
		http.Error(w, `{"error":"Şifre işlenemedi"}`, http.StatusInternalServerError)
		return
	}
	_, err = usersCol.UpdateOne(ctx, bson.M{"email": req.Email}, bson.M{"$set": bson.M{"password": string(hashed)}})
	if err != nil {
		http.Error(w, `{"error":"Şifre güncellenemedi"}`, http.StatusInternalServerError)
		return
	}
	_, _ = codesCol.DeleteMany(ctx, bson.M{"email": req.Email, "type": VerificationTypeResetPassword})
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{"message": "Şifreniz güncellendi. Giriş yapabilirsiniz."})
}

func createToken(userID, email string) (string, error) {
	claims := Claims{
		UserID: userID,
		Email:  email,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(jwtExpiry)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}
	t := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return t.SignedString(jwtSecret)
}

func authMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		auth := r.Header.Get("Authorization")
		if auth == "" || !strings.HasPrefix(auth, "Bearer ") {
			http.Error(w, `{"error":"Yetkilendirme gerekli"}`, http.StatusUnauthorized)
			return
		}
		tokenStr := strings.TrimPrefix(auth, "Bearer ")
		token, err := jwt.ParseWithClaims(tokenStr, &Claims{}, func(t *jwt.Token) (interface{}, error) { return jwtSecret, nil })
		if err != nil || !token.Valid {
			http.Error(w, `{"error":"Geçersiz veya süresi dolmuş oturum"}`, http.StatusUnauthorized)
			return
		}
		claims := token.Claims.(*Claims)
		ctx := context.WithValue(r.Context(), "userId", claims.UserID)
		ctx = context.WithValue(ctx, "email", claims.Email)
		next.ServeHTTP(w, r.WithContext(ctx))
	}
}
