package main

import (
	"encoding/json"
	"net/http"
	"strings"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var cartCol *mongo.Collection

func initCart(db *mongo.Database) {
	cartCol = db.Collection("carts")
}

type cartItemDoc struct {
	ID         string   `bson:"id" json:"id"`
	ProductID  string   `bson:"productId" json:"productId"`
	Name       string   `bson:"name" json:"name"`
	ImageURL   string   `bson:"imageUrl" json:"imageUrl"`
	UnitPrice  int      `bson:"unitPrice" json:"unitPrice"`
	Quantity   int      `bson:"quantity" json:"quantity"`
	SizeLabel  string   `bson:"sizeLabel" json:"sizeLabel"`
	MilkLabel  string   `bson:"milkLabel" json:"milkLabel"`
	ExtraShot  bool     `bson:"extraShot" json:"extraShot"`
	SyrupNames []string `bson:"syrupNames" json:"syrupNames"`
}

type cartDoc struct {
	UserID string         `bson:"userId" json:"userId"`
	Items  []cartItemDoc  `bson:"items" json:"items"`
}

func getCart(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userID := r.Context().Value("userId").(string)
	ctx := r.Context()
	var doc cartDoc
	err := cartCol.FindOne(ctx, bson.M{"userId": userID}).Decode(&doc)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			w.Header().Set("Content-Type", "application/json")
			_ = json.NewEncoder(w).Encode(map[string][]cartItemDoc{"items": {}})
			return
		}
		http.Error(w, `{"error":"Sepet getirilemedi"}`, http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string][]cartItemDoc{"items": doc.Items})
}

func addToCart(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userID := r.Context().Value("userId").(string)
	var item cartItemDoc
	if err := json.NewDecoder(r.Body).Decode(&item); err != nil {
		http.Error(w, `{"error":"Geçersiz istek"}`, http.StatusBadRequest)
		return
	}
	item.ID = strings.TrimSpace(item.ID)
	item.ProductID = strings.TrimSpace(item.ProductID)
	if item.ProductID == "" || item.Name == "" {
		http.Error(w, `{"error":"Ürün bilgisi gerekli"}`, http.StatusBadRequest)
		return
	}
	if item.Quantity < 1 {
		item.Quantity = 1
	}
	if item.SizeLabel == "" {
		item.SizeLabel = "M"
	}
	if item.MilkLabel == "" {
		item.MilkLabel = "Standart süt"
	}
	ctx := r.Context()
	var doc cartDoc
	err := cartCol.FindOne(ctx, bson.M{"userId": userID}).Decode(&doc)
	if err != nil && err != mongo.ErrNoDocuments {
		http.Error(w, `{"error":"Sepet getirilemedi"}`, http.StatusInternalServerError)
		return
	}
	if err == mongo.ErrNoDocuments {
		doc = cartDoc{UserID: userID, Items: []cartItemDoc{}}
	}
	// Aynı seçenekte varsa sadece adedi artır
	found := false
	for i := range doc.Items {
		if sameCartItemOptions(doc.Items[i], item) {
			doc.Items[i].Quantity += item.Quantity
			found = true
			break
		}
	}
	if !found {
		doc.Items = append(doc.Items, item)
	}
	filter := bson.M{"userId": userID}
	update := bson.M{"$set": bson.M{"userId": userID, "items": doc.Items}}
	opts := options.Update().SetUpsert(true)
	_, err = cartCol.UpdateOne(ctx, filter, update, opts)
	if err != nil {
		http.Error(w, `{"error":"Sepete eklenemedi"}`, http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{"message": "Sepete eklendi"})
}

func sameCartItemOptions(a, b cartItemDoc) bool {
	if a.ProductID != b.ProductID || a.SizeLabel != b.SizeLabel || a.MilkLabel != b.MilkLabel || a.ExtraShot != b.ExtraShot {
		return false
	}
	if len(a.SyrupNames) != len(b.SyrupNames) {
		return false
	}
	for i := range a.SyrupNames {
		if a.SyrupNames[i] != b.SyrupNames[i] {
			return false
		}
	}
	return true
}

func updateCartItemQuantity(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPut {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userID := r.Context().Value("userId").(string)
	path := r.URL.Path
	itemID := strings.TrimPrefix(path, "/api/cart/item/")
	itemID = strings.TrimSuffix(itemID, "/")
	if itemID == "" {
		http.Error(w, `{"error":"Ürün ID gerekli"}`, http.StatusBadRequest)
		return
	}
	var req struct {
		Quantity int `json:"quantity"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"Geçersiz istek"}`, http.StatusBadRequest)
		return
	}
	if req.Quantity < 1 {
		// 0 veya altı = satırı sil
		removeCartItem(w, r)
		return
	}
	ctx := r.Context()
	var doc cartDoc
	err := cartCol.FindOne(ctx, bson.M{"userId": userID}).Decode(&doc)
	if err != nil || len(doc.Items) == 0 {
		http.Error(w, `{"error":"Sepet bulunamadı"}`, http.StatusNotFound)
		return
	}
	found := false
	for i := range doc.Items {
		if doc.Items[i].ID == itemID {
			doc.Items[i].Quantity = req.Quantity
			found = true
			break
		}
	}
	if !found {
		http.Error(w, `{"error":"Ürün sepette bulunamadı"}`, http.StatusNotFound)
		return
	}
	_, err = cartCol.UpdateOne(ctx, bson.M{"userId": userID}, bson.M{"$set": bson.M{"items": doc.Items}})
	if err != nil {
		http.Error(w, `{"error":"Güncellenemedi"}`, http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{"message": "Güncellendi"})
}

func removeCartItem(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodDelete {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userID := r.Context().Value("userId").(string)
	path := r.URL.Path
	itemID := strings.TrimPrefix(path, "/api/cart/item/")
	itemID = strings.TrimSuffix(itemID, "/")
	if itemID == "" {
		http.Error(w, `{"error":"Ürün ID gerekli"}`, http.StatusBadRequest)
		return
	}
	ctx := r.Context()
	var doc cartDoc
	err := cartCol.FindOne(ctx, bson.M{"userId": userID}).Decode(&doc)
	if err != nil || len(doc.Items) == 0 {
		http.Error(w, `{"error":"Sepet bulunamadı"}`, http.StatusNotFound)
		return
	}
	newItems := make([]cartItemDoc, 0, len(doc.Items))
	for _, it := range doc.Items {
		if it.ID != itemID {
			newItems = append(newItems, it)
		}
	}
	_, err = cartCol.UpdateOne(ctx, bson.M{"userId": userID}, bson.M{"$set": bson.M{"items": newItems}})
	if err != nil {
		http.Error(w, `{"error":"Kaldırılamadı"}`, http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{"message": "Kaldırıldı"})
}
