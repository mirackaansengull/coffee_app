package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/joho/godotenv"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func cors(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		next.ServeHTTP(w, r)
	}
}

func main() {
	_ = godotenv.Load()

	mongoURI := os.Getenv("MONGO_URl")
	if mongoURI == "" {
		mongoURI = os.Getenv("MONGO_URL")
	}
	if mongoURI == "" {
		log.Fatal("HATA: MONGO_URL ortam değişkeni ayarlanmamış! Lütfen .env veya panel ayarlarını kontrol edin.")
	}

	clientOptions := options.Client().ApplyURI(mongoURI)
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	client, err := mongo.Connect(ctx, clientOptions)
	if err != nil {
		log.Fatal("Bağlantı başlatılamadı:", err)
	}
	defer func() {
		if err = client.Disconnect(context.Background()); err != nil {
			log.Print("MongoDB kapatılırken hata:", err)
		}
	}()

	if err = client.Ping(ctx, nil); err != nil {
		log.Fatal("Veritabanına ulaşılamadı (Ping başarısız):", err)
	}

	db := client.Database("coffee_app")
	initAuth(db)
	initCoffee(db)
	initFavorites(db)

	fmt.Println("MongoDB'ye başarıyla bağlandık! 🚀")

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	fmt.Println("Sunucu", port, "portunda başlatılıyor...")

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Kahve App Backend Çalışıyor! ☕")
	})

	http.HandleFunc("/api/auth/register/send-code", cors(sendRegisterCode))
	http.HandleFunc("/api/auth/register/verify", cors(verifyRegister))
	http.HandleFunc("/api/auth/login", cors(login))
	http.HandleFunc("/api/auth/forgot-password/send-code", cors(sendResetCode))
	http.HandleFunc("/api/auth/forgot-password/reset", cors(resetPassword))

	http.HandleFunc("/api/coffees", cors(getCoffees))
	http.HandleFunc("/api/coffee", cors(authMiddleware(createCoffee)))
	http.HandleFunc("/api/coffee/", cors(authMiddleware(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPut {
			updateCoffee(w, r)
		} else if r.Method == http.MethodDelete {
			deleteCoffee(w, r)
		} else {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})))
	http.HandleFunc("/api/favorites", cors(authMiddleware(getFavorites)))
	http.HandleFunc("/api/favorites/add", cors(authMiddleware(addFavorite)))
	http.HandleFunc("/api/favorites/", cors(authMiddleware(func(w http.ResponseWriter, r *http.Request) {
		if strings.HasPrefix(r.URL.Path, "/api/favorites/check/") {
			isFavorite(w, r)
		} else {
			removeFavorite(w, r)
		}
	})))

	log.Fatal(http.ListenAndServe(":"+port, nil))
}
