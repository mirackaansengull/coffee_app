package main

import (
    "context"
    "fmt"
    "log"
    "os"
    "time"
	"net/http"

    "github.com/joho/godotenv"
    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
)

func main() {
    _ = godotenv.Load()

    mongoURI := os.Getenv("MONGO_URl")

    if mongoURI == "" {
        log.Fatal("HATA: MONGO_URL ortam değişkeni ayarlanmamış! Lütfen .env dosyanızı veya panel ayarlarınızı kontrol edin.")
    }

    clientOptions := options.Client().ApplyURI(mongoURI)

    ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
    defer cancel()

    client, err := mongo.Connect(ctx, clientOptions)
    if err != nil {
        log.Fatal("Bağlantı başlatılamadı:", err)
    }

    err = client.Ping(ctx, nil)
    if err != nil {
        log.Fatal("Veritabanına ulaşılamadı (Ping başarısız):", err)
    }

    fmt.Println("MongoDB'ye başarıyla bağlandık! 🚀")

	fmt.Println("Sunucu 8080 portunda başlatılıyor...")

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Kahve App Backend Çalışıyor! ☕")
	})

	log.Fatal(http.ListenAndServe(":"+port, nil))

	defer func() {
		if err = client.Disconnect(ctx); err != nil {
			log.Fatal("Bağlantı kapatılırken hata oluştu:", err)
		}
	}()
}