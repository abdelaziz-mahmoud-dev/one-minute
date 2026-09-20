# One Minute API

Base URL:

```text
http://localhost:3000/api
```

## Authentication

Protected endpoints require:

```http
Authorization: Bearer YOUR_TOKEN
```

---

# Health

## GET /health

Checks API and database status.

### Response

```json
{
  "success": true,
  "message": "One Minute API is healthy",
  "data": {
    "database": "connected",
    "environment": "development",
    "timestamp": "2026-09-13T00:00:00.000Z"
  }
}
```

---

# Authentication

## POST /auth/register

Creates a new account.

### Request

```json
{
  "name": "Abdelaziz",
  "email": "abdelaziz@example.com",
  "password": "123456"
}
```

### Response

```json
{
  "success": true,
  "message": "Account created successfully",
  "data": {
    "user": {
      "id": "USER_ID",
      "name": "Abdelaziz",
      "email": "abdelaziz@example.com",
      "avatar": null,
      "interests": [],
      "xp": 0,
      "level": 1,
      "streak": 0
    },
    "token": "JWT_TOKEN"
  }
}
```

---

## POST /auth/login

Logs a user in.

### Request

```json
{
  "email": "abdelaziz@example.com",
  "password": "123456"
}
```

### Response

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "USER_ID",
      "name": "Abdelaziz",
      "email": "abdelaziz@example.com",
      "avatar": null,
      "interests": [],
      "xp": 0,
      "level": 1,
      "streak": 0
    },
    "token": "JWT_TOKEN"
  }
}
```

---

## GET /auth/me

Returns the currently authenticated user.

### Authentication

Required.

### Response

```json
{
  "success": true,
  "data": {
    "user": {}
  }
}
```

---

## PATCH /auth/profile

Updates the user's profile.

### Authentication

Required.

### Request

```json
{
  "name": "Abdelaziz Mahmoud",
  "avatar": "avatar_url"
}
```

---

## PATCH /auth/interests

Updates the user's interests.

### Authentication

Required.

### Request

```json
{
  "interests": [
    "CATEGORY_ID_1",
    "CATEGORY_ID_2"
  ]
}
```

---

## PATCH /auth/password

Changes the user's password.

### Authentication

Required.

### Request

```json
{
  "currentPassword": "old-password",
  "newPassword": "new-password"
}
```

---

# Learning

## GET /learning/categories

Returns all active categories.

### Response

```json
{
  "success": true,
  "data": {
    "categories": []
  }
}
```

---

## GET /learning/paths

Returns published learning paths.

### Optional query parameters

```text
?category=CATEGORY_ID
?level=beginner
```

Example:

```text
GET /learning/paths?level=beginner
```

---

## GET /learning/paths/:id

Returns a learning path and its published minutes.

### Response

```json
{
  "success": true,
  "data": {
    "path": {},
    "minutes": []
  }
}
```

---

## GET /learning/minutes/:id

Returns a specific learning minute.

### Response

```json
{
  "success": true,
  "data": {
    "minute": {}
  }
}
```

---

# Daily Minute

## GET /daily

Returns the best available daily minute for the authenticated user.

### Authentication

Required.

### Response

```json
{
  "success": true,
  "data": {
    "minute": {}
  }
}
```

---

# Progress

## GET /progress

Returns the user's learning progress.

### Authentication

Required.

### Query parameters

```text
?page=1&limit=20
```

Maximum limit:

```text
50
```

### Response

```json
{
  "success": true,
  "data": {
    "xp": 100,
    "level": 2,
    "streak": 3,
    "nextLevelXp": 200,
    "completedMinutes": 10,
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 10,
      "totalPages": 1
    },
    "progress": []
  }
}
```

---

## GET /progress/completed

Returns completed minutes.

### Authentication

Required.

---

## POST /progress/minutes/:id/answer

Submits an answer for a minute.

### Authentication

Required.

### Request

```json
{
  "answer": 1
}
```

`answer` is the zero-based option index.

### Response

```json
{
  "success": true,
  "data": {
    "correct": true,
    "completed": true,
    "attempts": 1,
    "xpEarned": 10,
    "totalXp": 110,
    "explanation": "Explanation text"
  }
}
```

---

# Recall

## GET /recall

Returns recall items currently due for review.

### Authentication

Required.

### Response

```json
{
  "success": true,
  "data": {
    "count": 2,
    "recalls": []
  }
}
```

---

## POST /recall/:id/answer

Submits a recall score.

### Authentication

Required.

### Request

```json
{
  "score": 4
}
```

Valid scores:

```text
0 - 5
```

### Response

```json
{
  "success": true,
  "message": "Recall updated successfully",
  "data": {
    "score": 4,
    "nextReviewAt": "2026-09-15T10:00:00.000Z",
    "intervalDays": 2
  }
}
```

---

# Dashboard

## GET /dashboard

Returns the user's dashboard data.

### Authentication

Required.

### Response

```json
{
  "success": true,
  "data": {
    "user": {
      "id": "USER_ID",
      "name": "Abdelaziz",
      "avatar": null,
      "xp": 100,
      "level": 2,
      "streak": 3,
      "interests": []
    },
    "stats": {
      "completedMinutes": 10,
      "dueRecalls": 2,
      "nextLevelXp": 200
    },
    "recentProgress": []
  }
}
```

---

# Error Format

Most API errors follow this structure:

```json
{
  "success": false,
  "message": "Error message"
}
```

Validation errors may include:

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    "Name must be at least 2 characters"
  ]
}
```

---

# Authentication Flow

The Flutter application should:

1. Register or login.
2. Receive the JWT token.
3. Store the token securely.
4. Send the token with protected requests.

Example:

```http
Authorization: Bearer JWT_TOKEN
```

When the token expires or becomes invalid, the application should clear the stored authentication state and return the user to the login screen.

---

# Main Application Flow

```text
Splash
   ↓
Check stored token
   ↓
Authenticated?
   ├── No → Login / Register
   │
   └── Yes
        ↓
      Home
        ↓
   Daily Minute
        ↓
       Learn
        ↓
       Quiz
        ↓
   XP + Streak
        ↓
      Recall
        ↓
     Progress
        ↓
     Profile
```
