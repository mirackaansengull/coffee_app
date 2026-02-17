package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
)

const brevoURL = "https://api.brevo.com/v3/smtp/email"

func sendVerificationCode(toEmail, code, subject, bodyPrefix string) error {
	apiKey := strings.TrimSpace(os.Getenv("BREVO_API_KEY"))
	if apiKey == "" {
		return fmt.Errorf("BREVO_API_KEY ortam değişkeni ayarlanmamış")
	}
	senderEmail := strings.TrimSpace(os.Getenv("BREVO_SENDER_EMAIL"))
	senderName := strings.TrimSpace(os.Getenv("BREVO_SENDER_NAME"))
	if senderEmail == "" {
		senderEmail = "noreply@example.com"
	}
	if senderName == "" {
		senderName = "Kahve App"
	}
	textContent := bodyPrefix + "\n\nDoğrulama kodunuz: " + code + "\n\nBu kod 10 dakika geçerlidir."
	payload := BrevoPayload{
		Sender:      BrevoSender{Name: senderName, Email: senderEmail},
		To:          []BrevoTo{{Email: toEmail}},
		Subject:     subject,
		TextContent: textContent,
	}
	body, err := json.Marshal(payload)
	if err != nil {
		return err
	}
	req, err := http.NewRequest(http.MethodPost, brevoURL, bytes.NewReader(body))
	if err != nil {
		return err
	}
	req.Header.Set("accept", "application/json")
	req.Header.Set("content-type", "application/json")
	req.Header.Set("api-key", apiKey)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		b, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("brevo api hatası (status %d): %s", resp.StatusCode, string(b))
	}
	return nil
}
