package main

import (
	"context"
	"encoding/json"
	"net/http"
	"strings"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

var coffeesCol *mongo.Collection

func initCoffee(db *mongo.Database) {
	coffeesCol = db.Collection("coffees")
}

func getCoffees(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	ctx := r.Context()
	cursor, err := coffeesCol.Find(ctx, bson.M{})
	if err != nil {
		http.Error(w, `{"error":"Kahveler getirilemedi"}`, http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)
	var coffees []Coffee
	if err := cursor.All(ctx, &coffees); err != nil {
		http.Error(w, `{"error":"Kahveler işlenemedi"}`, http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(coffees)
}

func createCoffee(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userId := r.Context().Value("userId").(string)
	var user User
	objID, _ := primitive.ObjectIDFromHex(userId)
	if err := usersCol.FindOne(r.Context(), bson.M{"_id": objID}).Decode(&user); err != nil || !user.IsAdmin {
		http.Error(w, `{"error":"Yetki yok"}`, http.StatusForbidden)
		return
	}
	var req struct {
		Name        string `json:"name"`
		ImageURL    string `json:"imageUrl"`
		Price       int    `json:"price"`
		Description string `json:"description"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"Geçersiz istek"}`, http.StatusBadRequest)
		return
	}
	req.Name = strings.TrimSpace(req.Name)
	req.ImageURL = strings.TrimSpace(req.ImageURL)
	req.Description = strings.TrimSpace(req.Description)
	if req.Name == "" || req.ImageURL == "" || req.Price <= 0 {
		http.Error(w, `{"error":"İsim, resim URL ve geçerli fiyat gerekli"}`, http.StatusBadRequest)
		return
	}
	coffee := Coffee{
		ID:          primitive.NewObjectID(),
		Name:        req.Name,
		ImageURL:    req.ImageURL,
		Price:       req.Price,
		Description: req.Description,
		CreatedAt:   time.Now(),
	}
	_, err := coffeesCol.InsertOne(r.Context(), coffee)
	if err != nil {
		http.Error(w, `{"error":"Kahve oluşturulamadı"}`, http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(coffee)
}

func updateCoffee(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPut {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userId := r.Context().Value("userId").(string)
	var user User
	userObjID, _ := primitive.ObjectIDFromHex(userId)
	if err := usersCol.FindOne(r.Context(), bson.M{"_id": userObjID}).Decode(&user); err != nil || !user.IsAdmin {
		http.Error(w, `{"error":"Yetki yok"}`, http.StatusForbidden)
		return
	}
	path := r.URL.Path
	id := strings.TrimPrefix(path, "/api/coffee/")
	objID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		http.Error(w, `{"error":"Geçersiz ID"}`, http.StatusBadRequest)
		return
	}
	var req struct {
		Name        string `json:"name"`
		ImageURL    string `json:"imageUrl"`
		Price       int    `json:"price"`
		Description string `json:"description"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"Geçersiz istek"}`, http.StatusBadRequest)
		return
	}
	req.Name = strings.TrimSpace(req.Name)
	req.ImageURL = strings.TrimSpace(req.ImageURL)
	req.Description = strings.TrimSpace(req.Description)
	if req.Name == "" || req.ImageURL == "" || req.Price <= 0 {
		http.Error(w, `{"error":"İsim, resim URL ve geçerli fiyat gerekli"}`, http.StatusBadRequest)
		return
	}
	update := bson.M{
		"$set": bson.M{
			"name":        req.Name,
			"imageUrl":    req.ImageURL,
			"price":       req.Price,
			"description": req.Description,
		},
	}
	result := coffeesCol.FindOneAndUpdate(r.Context(), bson.M{"_id": objID}, update)
	if result.Err() != nil {
		http.Error(w, `{"error":"Kahve bulunamadı"}`, http.StatusNotFound)
		return
	}
	var coffee Coffee
	_ = coffeesCol.FindOne(r.Context(), bson.M{"_id": objID}).Decode(&coffee)
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(coffee)
}

func deleteCoffee(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodDelete {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userId := r.Context().Value("userId").(string)
	var user User
	userObjID, _ := primitive.ObjectIDFromHex(userId)
	if err := usersCol.FindOne(r.Context(), bson.M{"_id": userObjID}).Decode(&user); err != nil || !user.IsAdmin {
		http.Error(w, `{"error":"Yetki yok"}`, http.StatusForbidden)
		return
	}
	path := r.URL.Path
	id := strings.TrimPrefix(path, "/api/coffee/")
	objID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		http.Error(w, `{"error":"Geçersiz ID"}`, http.StatusBadRequest)
		return
	}
	result, err := coffeesCol.DeleteOne(r.Context(), bson.M{"_id": objID})
	if err != nil || result.DeletedCount == 0 {
		http.Error(w, `{"error":"Kahve bulunamadı"}`, http.StatusNotFound)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{"message": "Kahve silindi"})
}
