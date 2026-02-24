package main

import (
	"encoding/json"
	"net/http"
	"strings"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var ordersCol *mongo.Collection

func initOrders(db *mongo.Database) {
	ordersCol = db.Collection("orders")
}

type orderItemDoc struct {
	ProductID  string   `bson:"productId" json:"productId"`
	Name       string   `bson:"name" json:"name"`
	Quantity   int      `bson:"quantity" json:"quantity"`
	UnitPrice  int      `bson:"unitPrice" json:"unitPrice"`
	SizeLabel  string   `bson:"sizeLabel" json:"sizeLabel"`
	MilkLabel  string   `bson:"milkLabel" json:"milkLabel"`
	ExtraShot  bool     `bson:"extraShot" json:"extraShot"`
	SyrupNames []string `bson:"syrupNames" json:"syrupNames"`
}

type deliveryDoc struct {
	City         string `bson:"city" json:"city"`
	Neighborhood string `bson:"neighborhood" json:"neighborhood"`
	BranchName   string `bson:"branchName" json:"branchName"`
	Address      string `bson:"address" json:"address"`
}

type orderDoc struct {
	ID        primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	UserID    string             `bson:"userId" json:"userId"`
	Items     []orderItemDoc     `bson:"items" json:"items"`
	Total     int                `bson:"total" json:"total"`
	Delivery  deliveryDoc        `bson:"delivery" json:"delivery"`
	Status    int                `bson:"status" json:"status"`
	Rating    int                `bson:"rating" json:"rating"`
	CreatedAt time.Time          `bson:"createdAt" json:"createdAt"`
}

func createOrder(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userID := r.Context().Value("userId").(string)
	var req struct {
		Items    []orderItemDoc `json:"items"`
		Total    int            `json:"total"`
		Delivery deliveryDoc    `json:"delivery"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"Geçersiz istek"}`, http.StatusBadRequest)
		return
	}
	if len(req.Items) == 0 || req.Total <= 0 {
		http.Error(w, `{"error":"Sipariş içeriği gerekli"}`, http.StatusBadRequest)
		return
	}
	ctx := r.Context()
	doc := bson.M{
		"userId":    userID,
		"items":     req.Items,
		"total":     req.Total,
		"delivery":  req.Delivery,
		"status":    0,
		"rating":    0,
		"createdAt": time.Now(),
	}
	res, err := ordersCol.InsertOne(ctx, doc)
	if err != nil {
		http.Error(w, `{"error":"Sipariş kaydedilemedi"}`, http.StatusInternalServerError)
		return
	}
	id := res.InsertedID.(primitive.ObjectID)
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{
		"id":      id.Hex(),
		"message": "Sipariş alındı",
	})
}

func getOrders(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	userID := r.Context().Value("userId").(string)
	ctx := r.Context()
	opts := options.Find().SetSort(bson.D{{Key: "createdAt", Value: -1}})
	cursor, err := ordersCol.Find(ctx, bson.M{"userId": userID}, opts)
	if err != nil {
		http.Error(w, `{"error":"Siparişler getirilemedi"}`, http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)
	var docs []orderDoc
	if err := cursor.All(ctx, &docs); err != nil {
		http.Error(w, `{"error":"Siparişler işlenemedi"}`, http.StatusInternalServerError)
		return
	}
	out := make([]map[string]interface{}, 0, len(docs))
	for _, d := range docs {
		out = append(out, map[string]interface{}{
			"id":       d.ID.Hex(),
			"date":     d.CreatedAt.Format("02.01.2006"),
			"time":     d.CreatedAt.Format("15:04"),
			"step":     d.Status,
			"rating":   d.Rating,
			"total":    d.Total,
			"items":    d.Items,
			"delivery": d.Delivery,
		})
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(out)
}

func getAdminOrders(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	ctx := r.Context()
	opts := options.Find().SetSort(bson.D{{Key: "createdAt", Value: -1}})
	cursor, err := ordersCol.Find(ctx, bson.M{}, opts)
	if err != nil {
		http.Error(w, `{"error":"Siparişler getirilemedi"}`, http.StatusInternalServerError)
		return
	}
	defer cursor.Close(ctx)
	var docs []orderDoc
	if err := cursor.All(ctx, &docs); err != nil {
		http.Error(w, `{"error":"Siparişler işlenemedi"}`, http.StatusInternalServerError)
		return
	}
	userIDs := make([]primitive.ObjectID, 0, len(docs))
	seen := make(map[string]bool)
	for _, d := range docs {
		if seen[d.UserID] {
			continue
		}
		seen[d.UserID] = true
		oid, err := primitive.ObjectIDFromHex(d.UserID)
		if err != nil {
			continue
		}
		userIDs = append(userIDs, oid)
	}
	userNameMap := make(map[string]string)
	if len(userIDs) > 0 {
		userCursor, err := usersCol.Find(ctx, bson.M{"_id": bson.M{"$in": userIDs}})
		if err == nil {
			defer userCursor.Close(ctx)
			var users []struct {
				ID   primitive.ObjectID `bson:"_id"`
				Name string             `bson:"name"`
			}
			if userCursor.All(ctx, &users) == nil {
				for _, u := range users {
					userNameMap[u.ID.Hex()] = u.Name
				}
			}
		}
	}
	out := make([]map[string]interface{}, 0, len(docs))
	for _, d := range docs {
		out = append(out, map[string]interface{}{
			"id":       d.ID.Hex(),
			"userId":   d.UserID,
			"userName": userNameMap[d.UserID],
			"date":     d.CreatedAt.Format("02.01.2006"),
			"time":     d.CreatedAt.Format("15:04"),
			"step":     d.Status,
			"rating":   d.Rating,
			"total":    d.Total,
			"items":    d.Items,
			"delivery": d.Delivery,
		})
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(out)
}

func updateOrderStatus(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPut {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	path := r.URL.Path
	idStr := strings.TrimPrefix(path, "/api/admin/orders/")
	idStr = strings.TrimSuffix(idStr, "/")
	if idStr == "" {
		http.Error(w, `{"error":"Sipariş ID gerekli"}`, http.StatusBadRequest)
		return
	}
	oid, err := primitive.ObjectIDFromHex(idStr)
	if err != nil {
		http.Error(w, `{"error":"Geçersiz sipariş ID"}`, http.StatusBadRequest)
		return
	}
	var req struct {
		Status int `json:"status"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"Geçersiz istek"}`, http.StatusBadRequest)
		return
	}
	if req.Status < 0 || req.Status > 3 {
		http.Error(w, `{"error":"Durum 0-3 arası olmalı"}`, http.StatusBadRequest)
		return
	}
	ctx := r.Context()
	res, err := ordersCol.UpdateOne(ctx, bson.M{"_id": oid}, bson.M{"$set": bson.M{"status": req.Status}})
	if err != nil || res.MatchedCount == 0 {
		http.Error(w, `{"error":"Sipariş güncellenemedi"}`, http.StatusNotFound)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{"message": "Güncellendi"})
}
