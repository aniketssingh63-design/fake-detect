# Real-Time Voice Translator

> **TYBSc-IT Final Year Project**  
> A full-stack web application: speak in any language, translate instantly, hear the result.

---

## Project Architecture

```
real-time-voice-translator/
â”œâ”€â”€ package.json          â† root (concurrently scripts)
â”œâ”€â”€ .env.example
â”œâ”€â”€ .gitignore
â”œâ”€â”€ README.md
â”‚
â”œâ”€â”€ server/               â† Node.js + Express backend
â”‚   â”œâ”€â”€ server.js
â”‚   â”œâ”€â”€ config/db.js
â”‚   â”œâ”€â”€ middleware/auth.js, errorHandler.js
â”‚   â”œâ”€â”€ models/User.js, TranslationHistory.js
â”‚   â”œâ”€â”€ routes/auth.js, translate.js, history.js
â”‚   â”œâ”€â”€ controllers/authController.js, translateController.js, historyController.js
â”‚   â””â”€â”€ services/translationService.js   â† Replaceable translation adapter
â”‚
â””â”€â”€ client/               â† React 18 + Vite 5 frontend
    â””â”€â”€ src/
        â”œâ”€â”€ context/AuthContext.jsx
        â”œâ”€â”€ hooks/useSpeechRecognition.js
        â”œâ”€â”€ services/api.js
        â”œâ”€â”€ components/Navbar, Footer, ProtectedRoute, Toast
        â””â”€â”€ pages/LandingPage, LoginPage, RegisterPage,
                  DashboardPage, HistoryPage, ProfilePage
```

---

## External Services

| Service | Cost | Notes |
|---|---|---|
| Web Speech API | Free | Browser-native; Chrome/Edge only |
| MyMemory Translation | Free | 500 req/day anon, 5000/day with email |
| MongoDB | Free | Run locally |

**No paid API key is required.**

---

## Prerequisites

- **Node.js** >= 18 ([nodejs.org](https://nodejs.org))
- **MongoDB (Optional - In-Memory MongoDB is built-in & enabled by default!)
- **Google Chrome** or **Microsoft Edge** (for microphone/speech recognition)

---

## Quick Start

### 1. Clone / Download

```bash
git clone <your-repo-url>
cd real-time-voice-translator
```

### 2. Install All Dependencies

```bash
npm run install-all
```

This installs root, server, and client dependencies in one command.

### 3. Configure Environment

```bash
copy server\.env.example server\.env      # Windows
# OR
cp server/.env.example server/.env        # macOS/Linux
```

Open `server/.env` and set:
```
MONGO_URI=mongodb://localhost:27017/voice_translator
JWT_SECRET=any_long_random_string_here
```

### 4. Start MongoDB

```bash
# Windows (default install path)
"C:\Program Files\MongoDB\Server\6.0\bin\mongod.exe"

# macOS/Linux
mongod
```

### 5. Run the App (Development)

```bash
npm run dev
```

This starts both:
- **Backend** â†’ http://localhost:5000
- **Frontend** â†’ http://localhost:5173

Open **http://localhost:5173** in **Chrome or Edge**.

---

## All Available Scripts

| Command | Description |
|---|---|
| `npm run install-all` | Install all dependencies (root + server + client) |
| `npm run dev` | Start frontend AND backend together (development) |
| `npm run server` | Start only the backend (with nodemon hot-reload) |
| `npm run client` | Start only the frontend (Vite dev server) |
| `npm run build` | Build the React frontend for production |
| `npm start` | Start backend in production mode (serves built client) |

---

## REST API Documentation

Base URL: `http://localhost:5000/api`

### Authentication

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/auth/register` | âŒ | Register new user |
| POST | `/auth/login` | âŒ | Login, returns JWT |
| GET | `/auth/profile` | âœ… | Get profile + translation count |
| PUT | `/auth/profile` | âœ… | Update display name |

### Translation

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/translate` | âœ… | Translate text, save to history |

**Body:** `{ text, sourceLanguage, targetLanguage }`

### History

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/history` | âœ… | Get all user translations |
| DELETE | `/history/:id` | âœ… | Delete one entry |
| DELETE | `/history` | âœ… | Clear all history |

### Health Check

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/health` | âŒ | API status |

---

## Database Schema

### User
```js
{
  name:      String (required, 2-50 chars),
  email:     String (required, unique, indexed),
  password:  String (bcrypt hashed, never returned in queries),
  createdAt: Date (auto),
  updatedAt: Date (auto)
}
```

### TranslationHistory
```js
{
  userId:         ObjectId (ref: User, indexed),
  sourceLanguage: String,
  targetLanguage: String,
  originalText:   String (max 5000),
  translatedText: String (max 5000),
  createdAt:      Date (auto, indexed)
}
```

---

## Production Build

```bash
npm run build    # Builds React to client/dist/
npm start        # Express serves API + built React from port 5000
```

Open: http://localhost:5000

---

## Testing Instructions

### Backend API Testing (Postman / curl)

1. Register:
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@test.com","password":"123456"}'
```

2. Login (copy the token):
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"123456"}'
```

3. Translate (replace TOKEN):
```bash
curl -X POST http://localhost:5000/api/translate \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"text":"Hello world","sourceLanguage":"en","targetLanguage":"hi"}'
```

### Frontend Testing

1. Open Chrome â†’ http://localhost:5173
2. Click Register â†’ create account
3. Dashboard â†’ allow microphone â†’ speak â†’ Translate
4. Check History page
5. Check Profile page â†’ update name

---

## Swapping the Translation Provider

To use a different translation API (Google, DeepL, LibreTranslate):

1. Edit only `server/services/translationService.js`
2. Replace the `translateText()` function
3. Add any new keys to `server/.env`

No other files need to change.

---

## Security Features

- Passwords hashed with **bcrypt** (12 salt rounds) â€” never stored in plain text
- JWT tokens expire in 7 days
- Protected routes require `Authorization: Bearer <token>`
- Users can only delete/view their own history
- Input validated with `express-validator` on every endpoint
- CORS restricted to allowed origins
- Environment variables used for all secrets

---

## Deployment Notes

1. Use **MongoDB Atlas** (free tier) for cloud DB â€” update `MONGO_URI` in env
2. Set `NODE_ENV=production` in your hosting environment
3. Run `npm run build` then `npm start` â€” Express serves the React build
4. Deploy to **Render**, **Railway**, or **Heroku** (free tier)

---

*Built with React 18 Â· Vite 5 Â· Node.js Â· Express Â· MongoDB Â· JWT Â· Web Speech API Â· MyMemory*