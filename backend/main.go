package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func main() {
	// 1. Bağlantı ayarlarını yapılandır (URI kısmını kendine göre düzenle)
	// Eğer yereldeyse: mongodb://localhost:27017
	clientOptions := options.Client().ApplyURI("mongodb://localhost:27017")

	// 2. MongoDB'ye bağlan
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	client, err := mongo.Connect(ctx, clientOptions)
	if err != nil {
		log.Fatal("Bağlantı hatası:", err)
	}

	// 3. Bağlantıyı doğrula (Ping at)
	err = client.Ping(ctx, nil)
	if err != nil {
		log.Fatal("Veritabanına ulaşılamadı:", err)
	}

	fmt.Println("MongoDB'ye başarıyla bağlandık! 🚀")

	// İşlem bittiğinde bağlantıyı kapatmak için:
	// defer client.Disconnect(ctx)
}