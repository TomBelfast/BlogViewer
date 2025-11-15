# BlogBowl API Documentation

> **Complete API reference with endpoints, schemas, and examples**

**Last Updated:** 2025-01-27  
**Base URL:** `http://localhost:3000` (development)  
**Related:** [INDEX.md](./INDEX.md) | [ARCHITECTURE.md](./ARCHITECTURE.md)

---

## Table of Contents

1. [Authentication](#authentication)
2. [Internal API](#internal-api)
3. [Public API](#public-api)
4. [Error Handling](#error-handling)
5. [Request/Response Examples](#requestresponse-examples)

---

## Authentication

### Session-Based Authentication

Internal API endpoints use Rails session-based authentication:

1. **Login:** `POST /sign_in`
2. **Session Cookie:** Automatically set on successful login
3. **Authorization:** Include session cookie in subsequent requests

#### Login Request

```http
POST /sign_in
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "changeme"
}
```

#### Login Response

```http
HTTP/1.1 200 OK
Set-Cookie: _blogbowl_session=...; path=/; HttpOnly

{
  "redirect": "/"
}
```

### Token-Based Authentication (Webhooks)

Public API endpoints use token-based authentication:

```http
POST /api/public/postmark/event
Content-Type: application/json
X-API-Key: <webhook-secret>
```

---

## Internal API

Base Path: `/api/internal`

### Pages & Posts

#### Create Post

```http
POST /api/internal/pages/:page_id/posts
Content-Type: application/json
```

**Request Body:**
```json
{
  "post": {
    "title": "My First Post",
    "content": "<p>Post content in HTML or TipTap JSON</p>",
    "author_ids": [1, 2],
    "category_ids": [1],
    "status": "draft"
  }
}
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "title": "My First Post",
  "slug": "my-first-post",
  "content": "<p>Post content...</p>",
  "status": "draft",
  "author_ids": [1, 2],
  "category_ids": [1],
  "created_at": "2025-01-27T10:00:00Z",
  "updated_at": "2025-01-27T10:00:00Z"
}
```

#### Get Post

```http
GET /api/internal/pages/:page_id/posts/:id
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "title": "My First Post",
  "slug": "my-first-post",
  "content": "<p>Post content...</p>",
  "status": "published",
  "published_at": "2025-01-27T11:00:00Z",
  "authors": [
    {
      "id": 1,
      "first_name": "John",
      "last_name": "Doe",
      "email": "john@example.com"
    }
  ],
  "categories": [
    {
      "id": 1,
      "name": "Technology",
      "slug": "technology"
    }
  ]
}
```

#### Update Post

```http
PATCH /api/internal/pages/:page_id/posts/:id
Content-Type: application/json
```

**Request Body:**
```json
{
  "post": {
    "title": "Updated Title",
    "content": "<p>Updated content</p>"
  }
}
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "title": "Updated Title",
  "slug": "updated-title",
  "updated_at": "2025-01-27T12:00:00Z"
}
```

#### Publish Post

```http
POST /api/internal/pages/:page_id/posts/:id/publish
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "status": "published",
  "published_at": "2025-01-27T12:00:00Z"
}
```

#### Upload Post Image

```http
POST /api/internal/pages/:page_id/posts/:id/images
Content-Type: multipart/form-data
```

**Request Body:**
```
image: <file>
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "url": "https://storage.example.com/images/abc123.jpg",
  "filename": "image.jpg",
  "content_type": "image/jpeg",
  "byte_size": 123456
}
```

#### Delete Post Images

```http
DELETE /api/internal/pages/:page_id/posts/:id/images
Content-Type: application/json
```

**Request Body:**
```json
{
  "image_ids": [1, 2, 3]
}
```

**Response:** `200 OK`
```json
{
  "message": "Images deleted successfully"
}
```

### Post Revisions

#### List Revisions

```http
GET /api/internal/pages/:page_id/posts/:post_id/revisions
```

**Response:** `200 OK`
```json
{
  "revisions": [
    {
      "id": 1,
      "content": "<p>Version 1</p>",
      "created_at": "2025-01-27T10:00:00Z",
      "created_by": {
        "id": 1,
        "email": "admin@example.com"
      }
    },
    {
      "id": 2,
      "content": "<p>Version 2</p>",
      "created_at": "2025-01-27T11:00:00Z",
      "created_by": {
        "id": 1,
        "email": "admin@example.com"
      }
    }
  ]
}
```

#### Create Revision

```http
POST /api/internal/pages/:page_id/posts/:post_id/revisions
Content-Type: application/json
```

**Request Body:**
```json
{
  "revision": {
    "content": "<p>New revision content</p>"
  }
}
```

**Response:** `201 Created`
```json
{
  "id": 3,
  "content": "<p>New revision content</p>",
  "created_at": "2025-01-27T13:00:00Z"
}
```

#### Get Last Revision

```http
GET /api/internal/pages/:page_id/posts/:post_id/revisions/last
```

**Response:** `200 OK`
```json
{
  "id": 3,
  "content": "<p>Latest content</p>",
  "created_at": "2025-01-27T13:00:00Z"
}
```

#### Update Last Revision

```http
PATCH /api/internal/pages/:page_id/posts/:post_id/revisions/last
Content-Type: application/json
```

**Request Body:**
```json
{
  "revision": {
    "content": "<p>Updated latest content</p>"
  }
}
```

**Response:** `200 OK`
```json
{
  "id": 3,
  "content": "<p>Updated latest content</p>",
  "updated_at": "2025-01-27T14:00:00Z"
}
```

#### Apply Last Revision

```http
POST /api/internal/pages/:page_id/posts/:post_id/revisions/last/apply
```

**Response:** `200 OK`
```json
{
  "message": "Revision applied successfully",
  "post": {
    "id": 1,
    "content": "<p>Applied content</p>"
  }
}
```

#### Share Last Revision

```http
POST /api/internal/pages/:page_id/posts/:post_id/revisions/last/share
```

**Response:** `200 OK`
```json
{
  "share_token": "abc123xyz",
  "share_url": "http://localhost:3000/preview/abc123xyz",
  "expires_at": "2025-02-27T13:00:00Z"
}
```

### Categories

#### List Categories

```http
GET /api/internal/pages/:page_id/categories
```

**Response:** `200 OK`
```json
{
  "categories": [
    {
      "id": 1,
      "name": "Technology",
      "slug": "technology",
      "description": "Tech-related posts",
      "color": "#3B82F6",
      "parent_id": null
    },
    {
      "id": 2,
      "name": "Web Development",
      "slug": "web-development",
      "parent_id": 1
    }
  ]
}
```

#### Create Category

```http
POST /api/internal/pages/:page_id/categories
Content-Type: application/json
```

**Request Body:**
```json
{
  "category": {
    "name": "Design",
    "description": "Design-related posts",
    "color": "#EF4444",
    "parent_id": null
  }
}
```

**Response:** `201 Created`
```json
{
  "id": 3,
  "name": "Design",
  "slug": "design",
  "description": "Design-related posts",
  "color": "#EF4444",
  "parent_id": null,
  "created_at": "2025-01-27T15:00:00Z"
}
```

### Authors

#### List Authors

```http
GET /api/internal/authors
```

**Response:** `200 OK`
```json
{
  "authors": [
    {
      "id": 1,
      "first_name": "John",
      "last_name": "Doe",
      "email": "john@example.com",
      "position": "Senior Developer",
      "slug": "john-doe",
      "active": true
    }
  ]
}
```

### Newsletters

#### Create Newsletter Email

```http
POST /api/internal/newsletters/:newsletter_id/emails
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": {
    "subject": "Weekly Newsletter",
    "content": "<p>Newsletter content</p>",
    "scheduled_at": "2025-01-28T10:00:00Z"
  }
}
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "subject": "Weekly Newsletter",
  "content": "<p>Newsletter content</p>",
  "status": "draft",
  "scheduled_at": "2025-01-28T10:00:00Z",
  "created_at": "2025-01-27T16:00:00Z"
}
```

#### Get Newsletter Email

```http
GET /api/internal/newsletters/:newsletter_id/emails/:id
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "subject": "Weekly Newsletter",
  "content": "<p>Newsletter content</p>",
  "status": "sent",
  "sent_at": "2025-01-28T10:00:00Z",
  "recipient_count": 150
}
```

#### Update Newsletter Email

```http
PATCH /api/internal/newsletters/:newsletter_id/emails/:id
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": {
    "subject": "Updated Subject",
    "content": "<p>Updated content</p>"
  }
}
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "subject": "Updated Subject",
  "updated_at": "2025-01-27T17:00:00Z"
}
```

#### Upload Newsletter Email Image

```http
POST /api/internal/newsletters/:newsletter_id/emails/:id/images
Content-Type: multipart/form-data
```

**Request Body:**
```
image: <file>
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "url": "https://storage.example.com/images/newsletter-abc123.jpg",
  "filename": "newsletter-image.jpg"
}
```

#### Send Newsletter Email

```http
POST /api/internal/newsletters/:newsletter_id/emails/:id/send
```

**Response:** `200 OK`
```json
{
  "message": "Newsletter queued for sending",
  "email": {
    "id": 1,
    "status": "queued"
  }
}
```

#### Send Test Newsletter Email

```http
POST /api/internal/newsletters/:newsletter_id/emails/:id/send/test
Content-Type: application/json
```

**Request Body:**
```json
{
  "test_email": "test@example.com"
}
```

**Response:** `200 OK`
```json
{
  "message": "Test email sent successfully"
}
```

#### Unschedule Newsletter Email

```http
POST /api/internal/newsletters/:newsletter_id/emails/:id/unschedule
```

**Response:** `200 OK`
```json
{
  "message": "Email unscheduled successfully",
  "email": {
    "id": 1,
    "status": "draft",
    "scheduled_at": null
  }
}
```

### Analytics

#### Get User Analytics

```http
GET /api/internal/analytics/user
```

**Response:** `200 OK`
```json
{
  "total_posts": 150,
  "published_posts": 120,
  "draft_posts": 30,
  "total_views": 50000,
  "total_subscribers": 500
}
```

### Domains

#### Verify Domain

```http
GET /api/internal/domain/verify
```

**Query Parameters:**
- `domain` (required): Domain to verify

**Response:** `200 OK`
```json
{
  "domain": "example.com",
  "verified": true,
  "dkim_verified": true,
  "spf_verified": true
}
```

---

## Public API

Base Path: `/api/public`

### Postmark Webhooks

#### Postmark Event Webhook

```http
POST /api/public/postmark/event
Content-Type: application/json
X-API-Key: <webhook-secret>
```

**Request Body:**
```json
{
  "RecordType": "Bounce",
  "MessageID": "12345678-1234-1234-1234-123456789012",
  "Type": "HardBounce",
  "TypeCode": 1,
  "Name": "Hard bounce",
  "Tag": "",
  "MessageStream": "outbound",
  "Description": "The server was unable to deliver your message (ex: unknown user, mailbox not found).",
  "Email": "recipient@example.com",
  "From": "sender@example.com",
  "BouncedAt": "2025-01-27T18:00:00Z"
}
```

**Response:** `200 OK`
```json
{
  "status": "processed"
}
```

**Supported Event Types:**
- `Bounce` - Email bounced
- `Delivery` - Email delivered
- `SpamComplaint` - Spam complaint
- `SubscriptionChange` - Subscription change

---

## Error Handling

### Error Response Format

All errors follow a consistent format:

```json
{
  "error": "Error message",
  "errors": {
    "field": ["Field-specific error message"]
  }
}
```

### HTTP Status Codes

- `200 OK` - Successful request
- `201 Created` - Resource created successfully
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `422 Unprocessable Entity` - Validation errors
- `500 Internal Server Error` - Server error

### Common Error Scenarios

#### Validation Error

```http
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/json

{
  "error": "Validation failed",
  "errors": {
    "title": ["can't be blank"],
    "content": ["is too short (minimum is 10 characters)"]
  }
}
```

#### Authentication Error

```http
HTTP/1.1 401 Unauthorized
Content-Type: application/json

{
  "error": "Authentication required"
}
```

#### Not Found Error

```http
HTTP/1.1 404 Not Found
Content-Type: application/json

{
  "error": "Post not found"
}
```

---

## Request/Response Examples

### Complete Workflow Example

#### 1. Create a Post

```bash
curl -X POST http://localhost:3000/api/internal/pages/1/posts \
  -H "Content-Type: application/json" \
  -H "Cookie: _blogbowl_session=..." \
  -d '{
    "post": {
      "title": "Getting Started with BlogBowl",
      "content": "<p>Welcome to BlogBowl!</p>",
      "author_ids": [1],
      "category_ids": [1],
      "status": "draft"
    }
  }'
```

#### 2. Upload an Image

```bash
curl -X POST http://localhost:3000/api/internal/pages/1/posts/1/images \
  -H "Cookie: _blogbowl_session=..." \
  -F "image=@/path/to/image.jpg"
```

#### 3. Create a Revision

```bash
curl -X POST http://localhost:3000/api/internal/pages/1/posts/1/revisions \
  -H "Content-Type: application/json" \
  -H "Cookie: _blogbowl_session=..." \
  -d '{
    "revision": {
      "content": "<p>Updated content with image</p>"
    }
  }'
```

#### 4. Publish the Post

```bash
curl -X POST http://localhost:3000/api/internal/pages/1/posts/1/publish \
  -H "Cookie: _blogbowl_session=..."
```

---

## Rate Limiting

Currently, no rate limiting is implemented. Consider implementing rate limiting for production deployments.

---

## Pagination

List endpoints support pagination using the Pagy gem:

**Query Parameters:**
- `page` - Page number (default: 1)
- `per_page` - Items per page (default: 20, max: 100)

**Response Headers:**
```
X-Page: 1
X-Per-Page: 20
X-Total: 150
X-Total-Pages: 8
```

---

**Related Documentation:**
- [INDEX.md](./INDEX.md) - Main documentation index
- [ARCHITECTURE.md](./ARCHITECTURE.md) - System architecture
- [DEVELOPMENT.md](./DEVELOPMENT.md) - Development guide

