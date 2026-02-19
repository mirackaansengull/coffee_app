package main

import (
	"context"
	"encoding/json"
	"net/http"
	"strings"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

var favoritesCol *mongo.Collection

func initFavorites(db *mongo.Database) {
	favoritesCol = db.Collection("favorites")
}

func addFavorite(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userId := r.Context().Value("userId").(string)
	var req struct {
		CoffeeID string `json:"coffeeId"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"Geçersiz istek"}`, http.StatusBadRequest)
		return
	}
	req.CoffeeID = strings.TrimSpace(req.CoffeeID)
	if req.CoffeeID == "" {
		http.Error(w, `{"error":"Kahve ID gerekli"}`, http.StatusBadRequest)
		return
	}
	coffeeObjID, err := primitive.ObjectIDFromHex(req.CoffeeID)
	if err != nil {
		http.Error(w, `{"error":"Geçersiz kahve ID"}`, http.StatusBadRequest)
		return
	}
	ctx := r.Context()
	var existing bson.M
	err = favoritesCol.FindOne(ctx, bson.M{"userId": userId, "coffeeId": req.CoffeeID}).Decode(&existing)
	if err == nil {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]string{"message": "Zaten favorilerde"})
		return
	}
	_, err = favoritesCol.InsertOne(ctx, bson.M{
		"userId":   userId,
		"coffeeId": req.CoffeeID,
		"coffeeObjId": coffeeObjID,
	})
	if err != nil {
		http.Error(w, `{"error":"Favori eklenemedi"}`, http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{"message": "Favorilere eklendi"})
}

func removeFavorite(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodDelete {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userId := r.Context().Value("userId").(string)
	path := r.URL.Path
	id := strings.TrimPrefix(path, "/api/favorites/")
	if id == "" || strings.HasPrefix(path, "/api/favorites/check/") {
		http.Error(w, `{"error":"Kahve ID gerekli"}`, http.StatusBadRequest)
		return
	}
	ctx := r.Context()
	result, err := favoritesCol.DeleteOne(ctx, bson.M{"userId": userId, "coffeeId": id})
	if err != nil || result.DeletedCount == 0 {
		http.Error(w, `{"error":"Favori bulunamadı"}`, http.StatusNotFound)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{"message": "Favorilerden çıkarıldı"})
}

func getFavorites(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userId := r.Context().Value("userId").(string)
	ctx := r.Context()
	cursor, err := favoritesCol.Find(ctx, bson.M{"userId": userId})
	if err != nil {
		http.Error(w, `{"error":"Favoriler getirilemedi"}`, http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)
	var favorites []bson.M
	if err := cursor.All(ctx, &favorites); err != nil {
		http.Error(w, `{"error":"Favoriler işlenemedi"}`, http.StatusInternalServerError)
		return
	}
	var coffeeIds []primitive.ObjectID
	for _, fav := range favorites {
		if objID, ok := fav["coffeeObjId"].(primitive.ObjectID); ok {
			coffeeIds = append(coffeeIds, objID)
		}
	}
	if len(coffeeIds) == 0 {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode([]Coffee{})
		return
	}
	coffeeCursor, err := coffeesCol.Find(ctx, bson.M{"_id": bson.M{"$in": coffeeIds}})
	if err != nil {
		http.Error(w, `{"error":"Kahveler getirilemedi"}`, http.StatusInternalServerError)
		return
	}
	defer coffeeCursor.Close(ctx)
	var coffees []Coffee
	if err := coffeeCursor.All(ctx, &coffees); err != nil {
		http.Error(w, `{"error":"Kahveler işlenemedi"}`, http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(coffees)
}

func isFavorite(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userId := r.Context().Value("userId").(string)
	path := r.URL.Path
	id := strings.TrimPrefix(path, "/api/favorites/check/")
	if id == "" {
		http.Error(w, `{"error":"Kahve ID gerekli"}`, http.StatusBadRequest)
		return
	}
	ctx := r.Context()
	var existing bson.M
	err := favoritesCol.FindOne(ctx, bson.M{"userId": userId, "coffeeId": id}).Decode(&existing)
	isFav := err == nil
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]bool{"isFavorite": isFav})
}
