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
	initCart(db)

	fmt.Println("MongoDB'ye başarıyla bağlandık! 🚀")

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	fmt.Println("Sunucu", port, "portunda başlatılıyor...")

	mux := http.NewServeMux()
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Kahve App Backend Çalışıyor! ☕")
	})
	mux.HandleFunc("/api/auth/register/send-code", sendRegisterCode)
	mux.HandleFunc("/api/auth/register/verify", verifyRegister)
	mux.HandleFunc("/api/auth/login", login)
	mux.HandleFunc("/api/auth/forgot-password/send-code", sendResetCode)
	mux.HandleFunc("/api/auth/forgot-password/reset", resetPassword)
	mux.HandleFunc("/api/coffees", getCoffees)
	mux.HandleFunc("/api/coffee", authMiddleware(createCoffee))
	mux.HandleFunc("/api/coffee/", authMiddleware(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPut {
			updateCoffee(w, r)
		} else if r.Method == http.MethodDelete {
			deleteCoffee(w, r)
		} else {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	}))
	mux.HandleFunc("/api/favorites", authMiddleware(getFavorites))
	mux.HandleFunc("/api/favorites/add", authMiddleware(addFavorite))
	mux.HandleFunc("/api/favorites/", authMiddleware(func(w http.ResponseWriter, r *http.Request) {
		if strings.HasPrefix(r.URL.Path, "/api/favorites/check/") {
			isFavorite(w, r)
		} else {
			removeFavorite(w, r)
		}
	}))
	mux.HandleFunc("/api/cart", authMiddleware(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodGet {
			getCart(w, r)
		} else if r.Method == http.MethodPost {
			addToCart(w, r)
		} else {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	}))
	mux.HandleFunc("/api/cart/item/", authMiddleware(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPut {
			updateCartItemQuantity(w, r)
		} else if r.Method == http.MethodDelete {
			removeCartItem(w, r)
		} else {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	}))

	log.Fatal(http.ListenAndServe(":"+port, mux))
}
