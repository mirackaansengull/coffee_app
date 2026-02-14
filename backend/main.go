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
    // 1. .env dosyasını yükle (Yerel geliştirme için)
    // Canlı ortamda (Vercel/Render) .env dosyası olmayacağı için hata verirse loglamak yerine pas geçiyoruz.
    _ = godotenv.Load()

    // 2. Ortam değişkeninden URI'yi al
    mongoURI := os.Getenv("MONGO_URl")

    // Eğer URI boşsa, kodun çalışmaması için hata veriyoruz
    if mongoURI == "" {
        log.Fatal("HATA: MONGO_URL ortam değişkeni ayarlanmamış! Lütfen .env dosyanızı veya panel ayarlarınızı kontrol edin.")
    }

    // 3. Bağlantı ayarlarını yapılandır
    clientOptions := options.Client().ApplyURI(mongoURI)

    // 4. MongoDB'ye bağlanmak için bir zaman aşımı (timeout) oluştur
    ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
    defer cancel()

    // 5. Bağlantıyı başlat
    client, err := mongo.Connect(ctx, clientOptions)
    if err != nil {
        log.Fatal("Bağlantı başlatılamadı:", err)
    }

    // 6. Bağlantıyı doğrula (Ping at)
    err = client.Ping(ctx, nil)
    if err != nil {
        log.Fatal("Veritabanına ulaşılamadı (Ping başarısız):", err)
    }

    fmt.Println("MongoDB'ye başarıyla bağlandık! 🚀")

	fmt.Println("Sunucu 8080 portunda başlatılıyor...")

// Render genellikle PORT ortam değişkenini kendi atar
port := os.Getenv("PORT")
if port == "" {
    port = "8080"
}

// Basit bir test rotası
http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Kahve App Backend Çalışıyor! ☕")
})

// Sunucuyu başlat (Bu satır uygulamayı açık tutar)
log.Fatal(http.ListenAndServe(":"+port, nil))
    // Program kapandığında bağlantıyı düzgünce kapatmak için:
    defer func() {
        if err = client.Disconnect(ctx); err != nil {
            log.Fatal("Bağlantı kapatılırken hata oluştu:", err)
        }
    }()
}