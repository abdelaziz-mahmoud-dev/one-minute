# One Minute

> One useful thing. One minute. Every time you open the app.

**One Minute** is a mobile application built around a simple idea: every time you open the app, you get one useful piece of content that can be consumed in about a minute.

The goal is to turn small moments of free time into small moments of learning, reflection, discovery, or improvement.

---

## ✨ Concept

We all have random moments during the day:

* Waiting for someone
* Riding somewhere
* Taking a short break
* Opening your phone without knowing what to do

Instead of endlessly scrolling, **One Minute** gives you something useful that takes roughly one minute.

Open the app → Get one useful thing → Spend one minute → Done.

---

## 🎯 Goals

The project is being built with a focus on:

* ⚡ Fast startup and smooth interactions
* 🎯 Simple and distraction-free user experience
* 📱 Modern mobile architecture
* 🔒 Secure backend communication
* 💾 Lightweight local persistence
* 🚀 Scalable backend architecture
* 🧩 Clean and maintainable code
* 📈 Future monetization and content expansion

---

## 🛠️ Tech Stack

### Mobile

* **Flutter**
* **Dart**
* **Provider** — state management
* **HTTP** — API communication
* **SharedPreferences** — local storage

### Backend

* **Node.js**
* **Express.js**
* **MongoDB**
* **Mongoose**
* **JWT**
* **bcryptjs**
* **Helmet**
* **CORS**
* **Express Rate Limit**

### Development

* Git
* GitHub
* Docker
* Docker Compose

---

## 📁 Project Structure

```text
one-minute/
│
├── backend/
│   ├── src/
│   ├── package.json
│   ├── Dockerfile
│   └── ...
│
├── mobile/
│   ├── lib/
│   ├── android/
│   ├── ios/
│   ├── web/
│   ├── test/
│   └── pubspec.yaml
│
├── .gitignore
└── README.md
```

> The Flutter SDK is used locally for development and is intentionally excluded from the repository.

---

## 🚀 Getting Started

### Prerequisites

Make sure you have:

* Flutter SDK
* Dart SDK
* Node.js
* npm
* MongoDB or Docker
* Git

---

### 1. Clone the repository

```bash
git clone https://github.com/abdelaziz-mahmoud-dev/one-minute.git
cd one-minute
```

---

### 2. Backend setup

```bash
cd backend
npm install
```

Create your environment file:

```bash
.env
```

Add the required environment variables.

Then start the backend:

```bash
npm run dev
```

The API runs locally on:

```text
http://localhost:3000
```

---

### 3. Mobile setup

Open a new terminal:

```bash
cd mobile
flutter pub get
```

Then run:

```bash
flutter run
```

---

## 🐳 Docker

The backend and MongoDB can also be run using Docker Compose.

From the project root:

```bash
docker compose up -d
```

To stop the containers:

```bash
docker compose down
```

---

## 🔐 Environment Variables

Environment-specific and secret values are intentionally excluded from Git.

Use a local `.env` file for development.

Example:

```env
PORT=3000
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret
```

**Never commit real secrets to the repository.**

---

## 🧠 Architecture

The project is separated into two main applications:

```text
                    One Minute
                        │
             ┌──────────┴──────────┐
             │                     │
          Mobile                 Backend
          Flutter                Node.js
             │                     │
             │                  Express
             │                     │
             └────── HTTP ─────────┘
                                   │
                                MongoDB
```

The mobile application communicates with the backend through HTTP APIs, while the backend handles application logic, authentication, and data persistence.

---

## 🔄 Development Status

This project is actively under development.

Current work includes:

* [x] Initial Flutter application
* [x] Backend API foundation
* [x] MongoDB integration
* [x] Docker development environment
* [x] Authentication foundation
* [x] Local storage foundation
* [ ] Refine mobile UI/UX
* [ ] Improve application performance
* [ ] Optimize API responses
* [ ] Complete core One Minute experience
* [ ] Content system
* [ ] Production deployment
* [ ] App Store / Google Play release

---

## ⚡ Performance

Performance is one of the main development priorities.

The application will be continuously optimized for:

* Fast startup
* Minimal unnecessary API requests
* Efficient state updates
* Lightweight local storage
* Optimized database queries
* Reduced widget rebuilds
* Efficient network usage
* Smooth animations and interactions

---

## 🗺️ Roadmap

### Phase 1 — Foundation

* Project architecture
* Backend API
* Database
* Authentication
* Flutter foundation

### Phase 2 — Core Experience

* Daily One Minute content
* Content categories
* User interactions
* Local caching
* Personalized experience

### Phase 3 — Performance & UX

* Startup optimization
* API optimization
* Database optimization
* UI performance
* Error handling
* Offline-friendly behavior

### Phase 4 — Production

* Production backend
* Monitoring
* Security hardening
* App release
* Analytics
* Monetization

---

## 🤝 Contributing

This project is currently developed as an independent project.

Suggestions, ideas, and technical feedback are welcome.

---

## 📄 License

License information will be added before the first public production release.

---

## 👨‍💻 Author

**Abdelaziz Mahmoud**

Computer Science Student
Backend & Full-Stack Developer
Interested in Software Engineering and AI

---

## ⭐ About the Project

**One Minute** is built around a simple principle:

> You don't always need an hour to learn something useful.

Sometimes, one minute is enough.
