package main

import (
	"time"

	"github.com/golang-jwt/jwt/v5"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type User struct {
	ID        primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	Email     string             `bson:"email" json:"email"`
	Password  string             `bson:"password" json:"-"`
	Name      string             `bson:"name" json:"name"`
	IsAdmin   bool               `bson:"isAdmin" json:"isAdmin"`
	CreatedAt time.Time          `bson:"createdAt" json:"createdAt"`
}

type Coffee struct {
	ID          primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	Name        string             `bson:"name" json:"name"`
	ImageURL    string             `bson:"imageUrl" json:"imageUrl"`
	Price       int                `bson:"price" json:"price"`
	PriceS      int                `bson:"priceS" json:"priceS"`
	PriceM      int                `bson:"priceM" json:"priceM"`
	PriceL      int                `bson:"priceL" json:"priceL"`
	PriceXL     int                `bson:"priceXL" json:"priceXL"`
	Description string             `bson:"description" json:"description"`
	Categories  []string           `bson:"categories" json:"categories"`
	CreatedAt   time.Time          `bson:"createdAt" json:"createdAt"`
}

type VerificationCode struct {
	Email     string    `bson:"email" json:"email"`
	Code      string    `bson:"code" json:"code"`
	Type      string    `bson:"type" json:"type"`
	ExpiresAt time.Time `bson:"expiresAt" json:"expiresAt"`
}

const (
	VerificationTypeRegister      = "register"
	VerificationTypeResetPassword = "reset_password"
)

type Claims struct {
	UserID  string `json:"userId"`
	Email   string `json:"email"`
	IsAdmin bool   `json:"isAdmin"`
	jwt.RegisteredClaims
}

type BrevoSender struct {
	Name  string `json:"name"`
	Email string `json:"email"`
}

type BrevoTo struct {
	Email string `json:"email"`
	Name  string `json:"name,omitempty"`
}

type BrevoPayload struct {
	Sender      BrevoSender `json:"sender"`
	To          []BrevoTo   `json:"to"`
	Subject     string      `json:"subject"`
	HTMLContent string      `json:"htmlContent,omitempty"`
	TextContent string      `json:"textContent,omitempty"`
}
