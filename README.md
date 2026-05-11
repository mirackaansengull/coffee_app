# Coffee App — Kahve siparişi (Flutter + Go)

Bu monorepo, Türkçe arayüzlü bir kahve sipariş uygulamasının **Flutter mobil istemcisi** ile **Go ile yazılmış REST API** sunucusunu bir arada tutar. İstemci ve sunucu JSON tabanlı konuşur; kimlik doğrulama JWT (`Authorization: Bearer <token>`) ile yapılır.

---

## Mimari genel bakış

```
Flutter uygulaması  ←→  HTTP/JSON  ←→  Go (net/http)  ←→  MongoDB
                           │
                    Brevo SMTP API (doğrulama e-postaları)
```

- **Herkese açık:** Kahve listesi (`GET /api/coffees`), kök path (`GET /`) — istemci barındırma uyandırma (cold start) için `GET BASE_URL` kullanır.
- **Giriş yapmış kullanıcı:** Sepet, favoriler, sipariş oluşturma/listeleme; kahve oluşturma/güncelleme/silme sadece veritabanında `isAdmin: true` olan kullanıcıya izin verilir.
- **Admin JWT:** `GET /api/admin/orders` ve `PUT /api/admin/orders/:id` için token içinde `isAdmin: true` olmalıdır.

---

# Backend (`backend/`)

## Teknoloji ve çalışma biçimi

| Bileşen | Açıklama |
|--------|-----------|
| Dil / çalışma ortamı | Go 1.25 (`go.mod` modül adı: `backend`) |
| HTTP | Standart kütüphane: `net/http`, `http.NewServeMux` |
| Veritabanı | MongoDB, veritabanı adı: **`coffee_app`** |
| Ortam | `github.com/joho/godotenv` ile proje kökünden veya çalışma dizininden `.env` yüklenir |
| Kimlik doğrulama | `github.com/golang-jwt/jwt/v5` — HS256, claim’lerde `userId`, `email`, `isAdmin` |
| Şifre | `golang.org/x/crypto/bcrypt` |
| E-posta | Brevo Transactional E-posta API (`utils.go` içinde `https://api.brevo.com/v3/smtp/email`) |

## MongoDB koleksiyonları

| Koleksiyon | Rol |
|------------|-----|
| `users` | E-posta, bcrypt hash, `name`, `isAdmin`, `createdAt` |
| `verification_codes` | Kayıt ve şifre sıfırlama için 6 haneli kod, `type`, `expiresAt` (~10 dk) |
| `coffees` | Ürün kayıtları (isim, görsel URL, fiyat alanları, kategori dizisi, açıklama) |
| `favorites` | `userId` + `coffeeId` / `coffeeObjId` ile favori ilişkisi |
| `carts` | Kullanıcı başına tek doküman: `userId`, `items[]` (ürün snapshot + boyut/süt/şurup/extra shot) |
| `orders` | Sipariş satırları, toplam, `delivery` objesi, `status` (0–3), `rating`, `createdAt` |

## Ortam değişkenleri (backend)

Zorunlu ve önemli değişkenler:

| Değişken | Açıklama |
|----------|----------|
| `MONGO_URL` | MongoDB bağlantı URI’si. Kodda yazım hatasıyla `MONGO_URl` da okunur; tercih `MONGO_URL`. |
| `PORT` | Dinlenecek port; boşsa **8080**. |
| `JWT_SECRET` | Boşsa zayıf varsayılan sabit kullanılır; **üretimde mutlaka ayarlayın**. |

Kayıt ve şifre sıfırlama e-postaları için:

| Değişken | Açıklama |
|----------|----------|
| `BREVO_API_KEY` | Brevo API anahtarı |
| `BREVO_SENDER_EMAIL` | Gönderen e-posta (boşsa `noreply@example.com`) |
| `BREVO_SENDER_NAME` | Gönderen adı (boşsa `Kahve App`) |

## HTTP uç noktaları ve sözleşme

Tüm JSON gövdelerinde hata mesajları genelde `{"error":"..."}` biçimindedir (kimlik doğrulama/izin hataları `http.Error` ile metin+gövde verilebilir; istemci `AuthRepository` gövdeyi JSON olarak çözmeye çalışır).

### Kimlik doğrulama (JWT yok)

| Metot | Yol | Gövde (özet) | Başarı yanıtı |
|------|-----|---------------|----------------|
| POST | `/api/auth/register/send-code` | `{"email"}` | `{"message"}` — kod e-postaya gider |
| POST | `/api/auth/register/verify` | `email`, `code`, `password`, `name?` | `{"token","user"}` — `user`: `id`, `email`, `name`, `isAdmin` |
| POST | `/api/auth/login` | `email`, `password` | `{"token","user"}` |
| POST | `/api/auth/forgot-password/send-code` | `{"email"}` | `{"message"}` — kullanıcı yoksa da aynı mesaj (bilgi sızıntısı yok) |
| POST | `/api/auth/forgot-password/reset` | `email`, `code`, `newPassword` | `{"message"}` |

JWT süresi: **7 gün** (`auth.go`). Doğrulama kodu süresi: **10 dakika**.

### Kahveler

| Metot | Yol | Kimlik | Not |
|-------|-----|--------|-----|
| GET | `/api/coffees` | Hayır | Tüm kahveler JSON dizi |
| POST | `/api/coffee` | Bearer + admin (DB’de `isAdmin`) | Gövde: `name`, `imageUrl`, `price`, `priceS`–`priceXL`, `description?`, `categories` |
| PUT | `/api/coffee/:id` | Bearer + admin | Aynı alanlar |
| DELETE | `/api/coffee/:id` | Bearer + admin | `{"message":"Kahve silindi"}` |

`coffee.go` içinde eksik boyut fiyatları `price` / `priceM` ile doldurulur.

### Favoriler (Bearer zorunlu)

| Metot | Yol | Gövde / not |
|-------|-----|-------------|
| GET | `/api/favorites` | İlgili `Coffee` nesnelerinin listesi |
| POST | `/api/favorites/add` | `{"coffeeId"}` |
| DELETE | `/api/favorites/:coffeeId` | — |
| GET | `/api/favorites/check/:coffeeId` | `{"isFavorite": bool}` |

### Sepet (Bearer zorunlu)

| Metot | Yol | Davranış |
|-------|-----|----------|
| GET | `/api/cart` | `{"items": [...]}` — yoksa boş dizi |
| POST | `/api/cart` | Sepet kalemi JSON; aynı seçeneklerde (ürün, boyut, süt, ekstra shot, şuruplar) adet birleştirilir |
| PUT | `/api/cart/item/:id` | `{"quantity"}` — `quantity < 1` ise satır silinir |
| DELETE | `/api/cart/item/:id` | Satırı kaldırır |

Sepet kalemi alanları (backend `cartItemDoc`): `id`, `productId`, `name`, `imageUrl`, `unitPrice`, `quantity`, `sizeLabel`, `milkLabel`, `extraShot`, `syrupNames`.

### Siparişler (Bearer zorunlu)

| Metot | Yol | Gövde / yanıt |
|-------|-----|----------------|
| POST | `/api/orders` | `items[]`, `total`, `delivery: { city, neighborhood, branchName, address }` — yanıt `id`, `message` |
| GET | `/api/orders` | Giriş yapan kullanıcının siparişleri; her kayıtta `id`, `date`, `time`, `step` (status), `rating`, `total`, `items`, `delivery` |

### Admin siparişler (Bearer + JWT’de `isAdmin`)

| Metot | Yol | Not |
|-------|-----|-----|
| GET | `/api/admin/orders` | **`status == 3` (teslim edildi) olanlar listeden çıkarılır** — sadece aktif iş akışı |
| PUT | `/api/admin/orders/:id` | `{"status"}` — **0 ile 3 arası** (kapsayıcı) |

İlk kayıt olan kullanıcılar `isAdmin: false` oluşturulur; admin kullanıcıyı MongoDB’de `users.isAdmin: true` yaparak tanımlarsınız.

## Backend’i çalıştırma

```bash
cd backend
go mod download
# .env içinde MONGO_URL, JWT_SECRET, BREVO_* ayarlayın
go run .
```

Sunucu `PORT` (varsayılan 8080) üzerinde dinler; kök istek metni: kahve backend’inin ayakta olduğunu belirten kısa mesaj.

---

# Flutter istemci (`lib/`, `pubspec.yaml`)

## Teknoloji

| Alan | Paket / seçim |
|------|----------------|
| SDK | Dart ^3.10.7 |
| Oturum durumu | `flutter_bloc` — sadece `AuthBloc` (check, login, logout) |
| HTTP | `package:http` — timeout: `ApiConstants.apiTimeout` (12 sn) |
| Yerel | `shared_preferences` — token, serileştirilmiş kullanıcı, sepet yedeği, banner URL listesi, kayıtlı kartlar |
| Konfig | `flutter_dotenv` — kökte `.env`, `BASE_URL` (yoksa `http://localhost:8080`) |
| UI ölçek | `flutter_screenutil` — tasarım boyutu **375×812** (`AppConstants.designSize`) |
| Diğer | `cached_network_image`, `carousel_slider`, Poppins fontları |

## Uygulama akışı (`lib/main.dart`)

1. `WidgetsFlutterBinding.ensureInitialized`, `.env` yüklenir, `BannerRepository` önbelleği okunur.
2. `RepositoryProvider<AuthRepository>` + `BlocProvider<AuthBloc>`.
3. `ScreenUtilInit` + `MaterialApp` — açık/koyu tema (`AppTheme`), `themeMode` durumu `MyApp` içinde tutulur.
4. `BlocBuilder<AuthBloc, AuthState>`:
   - `AuthInitial` / `AuthLoading` → `LoadingView`; ilk açılışta `wakeUpBackend()` (kök URL’ye periyodik GET) sonra `AuthCheckRequested`.
   - `AuthAuthenticated` → `user.isAdmin` ise `AdminView`, değilse `MainShell` (4 sekme).
   - Aksi → `LoginView`.

Kayıt, şifre unutturma ve e-posta kodları ayrı ekranlarda `AuthRepository` üzerinden doğrudan çağrılır; bu akışlar `AuthBloc` dışındadır (sadece oturum aç/kapat/restore Bloc’ta).

## Klasör yapısı ve sorumluluklar

- **`lib/core/`** — `ApiConstants` (`baseUrl`, timeout), `AppConstants`, tema (`app_theme`, renkler, radius, gradyanlar), varlık yolları.
- **`lib/data/models/`** — `AuthUser`, `Coffee`, `CartItem`, `Order`, `DeliveryLocation`, `SavedCard`, vb.
- **`lib/data/repositories/`** — Sunucu ve yerel kalıcılık:
  - `auth_repository.dart` — JWT + kullanıcı JSON’unu prefs’e yazar; kod istekleri.
  - `coffee_repository.dart` — liste herkese açık GET; CRUD ve favoriler Bearer ile.
  - `cart_repository.dart` — **hibrit:** önce API’den dene; token yoksa veya başarısızsa yerel `cart_items` prefs; ekle/güncelle/sil sonrası API’ye arka plan `microtask` ile senkron.
  - `order_repository.dart` — `ChangeNotifier`, kullanıcı/admin sipariş listeleri bellekte tutulur.
  - `banner_repository.dart` — **yalnızca cihaz** (varsayılan URL listesi + prefs).
  - `card_repository.dart` — **yalnızca cihaz** — ödeme ekranı için demo kart saklama.
  - `location_repository.dart` — **bellek içi** şube/teslimat seçimi (`ChangeNotifier`).
- **`lib/data/repositories/bloc/`** — `auth_bloc.dart`, `forgot_password_bloc.dart` (şifre sıfırlama UI’si).
- **`lib/views/`** — Ekranlar: `login`, `register`, `forgot_password`, `loading`, `main_shell_view`, alt sekmeler (`home`, `cart`, `favorites`, `profile`), `coffee_detail_view`, `checkout_view`, profil alt sayfaları (`payment_methods`, `all_orders`, `help`, `about`, …), `admin/*` (kahveler, siparişler, banner URL’leri).
- **`lib/widgets/`** — Auth bileşenleri, ana sayfa (banner, kategori, konum çubuğu), ortak `coffee_card`, `app_bar`, profil parçaları.

## İstemci ↔ backend eşlemesi (özet)

Flutter, backend ile aynı yolları kullanır; kahve POST gövdesinde `price` olarak orta boy (`priceM`) de gönderilir (backend uyumluluğu için).

Özel davranışlar:

- Açılışta `wakeUpBackend` uzun süre bekleyebilir (soğuk sunucu); sonra `AuthCheckRequested` ile prefs’teki kullanıcı geri yüklenir.
- Sepet: anında yerel güncelleme + oturum varsa API ile birleştirme.
- Bannerlar: admin ekranından girilen URL’ler **sunucuya gitmez**; sadece o cihazdaki kullanıcılar için prefs’ten yüklenir.
- Sipariş **201** dönerse bile `OrderRepository.createOrder` başarı sayabilir (`200 || 201` kontrolü).

## Flutter kurulum ve çalıştırma

Kök dizinde `.env`:

```env
BASE_URL=http://localhost:8080
# veya canlı API: https://sunucunuz.com
```

```bash
flutter pub get
flutter run
```

İkonlar: `dart run flutter_launcher_icons` (`pubspec.yaml` içinde yapılandırılmış).

## Varlıklar

- `assets/images/`, `assets/icons/`, `assets/icons/categories_icons/`
- `assets/fonts/Poppins-*.ttf`

---

## Güvenlik ve üretim notları

- Backend’de üretimde güçlü `JWT_SECRET`, HTTPS, MongoDB erişim kısıtları ve Brevo gönderen domain doğrulaması şarttır.
- Flutter’da token `SharedPreferences` içindedir; kök cihaz / yedek senaryoları için risk değerlendirmesi yapın.
- Kayıtlı kartlar ve banner URL’leri **gerçek ödeme veya çok kullanıcılı içerik yayını için uygun değildir**; kart özelliği eğitim/demo amaçlı yerel tutulmaktadır.

---

Bu README, `backend/*.go` ve `lib/**/*.dart` ile uyumlu olacak şekilde güncellenmiştir; davranış farkı olduğunda önce kod, sonra bu dosya güncellenmelidir.
