# BlogBowl Documentation Index

> **Comprehensive project documentation and knowledge base**

**Last Updated:** 2025-01-27  
**Project Version:** Latest  
**Documentation Status:** Complete

---

## 📚 Documentation Overview

This documentation provides a complete guide to the BlogBowl project, covering architecture, APIs, development workflows, and deployment strategies. All documentation is organized for easy navigation and cross-referencing.

### Quick Navigation

- [🏗️ Architecture](#architecture) - System design and component structure
- [🔌 API Reference](#api-reference) - Complete API documentation
- [💻 Development Guide](#development-guide) - Setup and development workflows
- [🚀 Deployment](#deployment) - Production deployment and Docker setup
- [📁 Project Structure](#project-structure) - Directory organization and conventions

---

## 🏗️ Architecture

### System Overview

BlogBowl is a self-hosted blogging platform built with a modern, modular architecture:

- **Backend:** Ruby on Rails 8.0.2 (Rails Engine architecture)
- **Frontend Editor:** React 18 + TypeScript + TipTap (Notion-like editor)
- **Database:** PostgreSQL
- **Cache/Queue:** Redis + Sidekiq
- **Email:** Postmark integration
- **Storage:** Active Storage (S3/MinIO compatible)

### Core Components

#### 1. Rails Engine (`submodules/core`)
The core functionality is packaged as a Rails Engine, providing:
- Models (Post, Page, Author, Category, Newsletter, etc.)
- Controllers (Admin, Public, API)
- Background jobs (Sidekiq)
- Database migrations
- Authentication and authorization (CanCanCan)

**Key Files:**
- `submodules/core/lib/core/engine.rb` - Engine definition
- `submodules/core/app/models/` - Data models
- `submodules/core/app/controllers/` - Request handlers
- `submodules/core/config/routes.rb` - Route definitions

#### 2. React Editor (`submodules/editor`)
A sophisticated rich-text editor built with:
- TipTap Pro extensions (drag-handle, emoji, mathematics, table-of-contents)
- React Query for data fetching
- Radix UI components
- Tailwind CSS for styling

**Key Files:**
- `submodules/editor/src/App.tsx` - Main editor component
- `submodules/editor/src/hooks/useBlockEditor.ts` - Editor hook
- `submodules/editor/src/extensions/` - TipTap extensions
- `submodules/editor/src/components/` - UI components

#### 3. Main Application (`app/`)
The host Rails application that:
- Mounts the Core engine
- Provides application-specific views and controllers
- Manages Docker deployment configuration
- Handles asset compilation

### Architecture Patterns

#### Multi-Tenancy
BlogBowl supports multiple "Pages" (workspaces), each with:
- Independent posts, categories, authors
- Customizable settings (header, footer, layout, domain)
- Newsletter configuration
- Analytics tracking

#### API Design
- **Internal API** (`/api/internal/*`) - Admin interface endpoints
- **Public API** (`/api/public/*`) - Webhook endpoints (Postmark)
- RESTful conventions with JSON responses

#### Authentication & Authorization
- Session-based authentication
- CanCanCan for role-based access control
- Workspace-scoped permissions

**See:** [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed architecture documentation

---

## 🔌 API Reference

### API Endpoints Overview

#### Internal API (`/api/internal`)

##### Pages & Posts
```
POST   /api/internal/pages/:page_id/posts
GET    /api/internal/pages/:page_id/posts/:id
PATCH  /api/internal/pages/:page_id/posts/:id
POST   /api/internal/pages/:page_id/posts/:id/publish
POST   /api/internal/pages/:page_id/posts/:id/images
DELETE /api/internal/pages/:page_id/posts/:id/images
```

##### Post Revisions
```
GET    /api/internal/pages/:page_id/posts/:post_id/revisions
POST   /api/internal/pages/:page_id/posts/:post_id/revisions
GET    /api/internal/pages/:page_id/posts/:post_id/revisions/last
PATCH  /api/internal/pages/:page_id/posts/:post_id/revisions/last
POST   /api/internal/pages/:page_id/posts/:post_id/revisions/last/apply
POST   /api/internal/pages/:page_id/posts/:post_id/revisions/last/share
```

##### Categories
```
GET    /api/internal/pages/:page_id/categories
POST   /api/internal/pages/:page_id/categories
```

##### Authors
```
GET    /api/internal/authors
```

##### Newsletters
```
POST   /api/internal/newsletters/:newsletter_id/emails
GET    /api/internal/newsletters/:newsletter_id/emails/:id
PATCH  /api/internal/newsletters/:newsletter_id/emails/:id
POST   /api/internal/newsletters/:newsletter_id/emails/:id/images
POST   /api/internal/newsletters/:newsletter_id/emails/:id/send
POST   /api/internal/newsletters/:newsletter_id/emails/:id/send/test
POST   /api/internal/newsletters/:newsletter_id/emails/:id/unschedule
```

##### Analytics
```
GET    /api/internal/analytics/user
```

##### Domains
```
GET    /api/internal/domain/verify
```

#### Public API (`/api/public`)

##### Postmark Webhooks
```
POST   /api/public/postmark/event
```

### Request/Response Examples

#### Create Post
```http
POST /api/internal/pages/1/posts
Content-Type: application/json
Authorization: Bearer <token>

{
  "post": {
    "title": "My First Post",
    "content": "<p>Post content...</p>",
    "author_ids": [1],
    "category_ids": [1]
  }
}
```

**Response:**
```json
{
  "id": 1,
  "title": "My First Post",
  "slug": "my-first-post",
  "status": "draft",
  "created_at": "2025-01-27T10:00:00Z"
}
```

#### Get Post Revisions
```http
GET /api/internal/pages/1/posts/1/revisions
```

**Response:**
```json
{
  "revisions": [
    {
      "id": 1,
      "content": "<p>Version 1</p>",
      "created_at": "2025-01-27T10:00:00Z"
    }
  ]
}
```

**See:** [API.md](./API.md) for complete API documentation with all endpoints, request/response schemas, and authentication details

---

## 💻 Development Guide

### Prerequisites

- **Ruby:** 3.2.2+ (managed via rbenv)
- **Node.js/Bun:** Latest (for frontend assets)
- **PostgreSQL:** 15+
- **Redis:** Latest
- **Docker:** For database and Redis services

### Initial Setup

1. **Clone and Install Dependencies**
```bash
cd BlogBowl
bundle install
bun install
```

2. **Configure Environment**
```bash
cp .env.example .env
# Edit .env with your configuration
```

3. **Start Services**
```bash
docker compose -f docker-compose.dev.yaml up -d
```

4. **Setup Database**
```bash
rails db:create
rails db:migrate
rails db:seed
```

5. **Build Assets**
```bash
bun run build:css
```

6. **Start Development Server**
```bash
bundle exec foreman start -f Procfile.dev
```

### Development Workflow

#### Running Tests
```bash
# Rails tests
rails test

# Specific test file
rails test test/models/post_test.rb
```

#### Frontend Development
```bash
cd submodules/editor
bun run dev  # Start Vite dev server
bun run build:css:watch  # Watch CSS changes
```

#### Database Migrations
```bash
# Create migration in core engine
rails generate migration CreateExampleTable core:install:migrations

# Run migrations
rails db:migrate
```

#### Code Quality
```bash
# RuboCop (Ruby linting)
bundle exec rubocop

# Brakeman (Security scanning)
bundle exec brakeman
```

### Default Credentials

- **Email:** `admin@example.com`
- **Password:** `changeme`

⚠️ **Change these immediately after first login!**

**See:** [DEVELOPMENT.md](./DEVELOPMENT.md) for detailed development workflows, debugging tips, and best practices

---

## 🚀 Deployment

### Docker Deployment

BlogBowl includes Docker Compose configurations for easy deployment:

#### Production Setup
```bash
docker compose up -d
```

This starts:
- `blogbowl_app` - Main Rails application (port 3000)
- `blogbowl_sidekiq` - Background job processor
- `postgres` - PostgreSQL database (port 5432)
- `redis` - Redis cache/queue (port 6379)

#### Environment Variables

Key environment variables (configured in `.env`):

```bash
# Database
DATABASE_URL=postgresql://blogbowl:blogbowl@postgres:5432/blogbowl

# Redis
REDIS_URL=redis://redis:6379/0

# Application
RAILS_ENV=production
SECRET_KEY_BASE=<generate-with-rails-secret>

# Email (Postmark)
POSTMARK_ACCOUNT_TOKEN=<your-token>
POSTMARK_X_API_KEY=<webhook-secret>

# Storage (S3/MinIO)
AWS_ACCESS_KEY_ID=<key>
AWS_SECRET_ACCESS_KEY=<secret>
AWS_REGION=<region>
AWS_BUCKET=<bucket-name>
AWS_ENDPOINT=<s3-endpoint>  # For MinIO
```

#### Storage Configuration

BlogBowl supports S3-compatible storage (AWS S3, MinIO, DigitalOcean Spaces):

**See:** [STORAGE_SETUP.md](../STORAGE_SETUP.md) for detailed storage configuration

#### Health Checks

- Application: `http://localhost:3000/up`
- Sidekiq Web UI: `http://localhost:3000/sidekiq`

**See:** [DEPLOYMENT.md](./DEPLOYMENT.md) for production deployment strategies, scaling, and monitoring

---

## 📁 Project Structure

### Directory Organization

```
BlogBowl/
├── app/                    # Main Rails application
│   ├── assets/            # Compiled assets
│   ├── controllers/       # Application controllers
│   ├── models/            # Application models
│   └── views/             # ERB templates
│
├── submodules/
│   ├── core/              # Rails Engine (core functionality)
│   │   ├── app/
│   │   │   ├── controllers/  # Core controllers
│   │   │   ├── models/       # Core models
│   │   │   └── views/        # Core views
│   │   ├── config/        # Engine configuration
│   │   ├── db/            # Migrations
│   │   └── lib/           # Engine code
│   │
│   └── editor/            # React editor application
│       ├── src/
│       │   ├── components/   # React components
│       │   ├── extensions/   # TipTap extensions
│       │   ├── hooks/         # React hooks
│       │   └── lib/           # Utilities
│       └── package.json
│
├── config/                # Rails configuration
├── db/                    # Database schema and seeds
├── docker-compose.yaml    # Production Docker setup
├── docker-compose.dev.yaml # Development Docker setup
└── Gemfile                # Ruby dependencies
```

### Key Models

- **Page** - Workspace/blog instance
- **Post** - Blog post/article
- **PostRevision** - Version history for posts
- **Author** - Content author
- **Category** - Post categorization
- **Newsletter** - Newsletter instance
- **NewsletterEmail** - Newsletter email content
- **Subscriber** - Newsletter subscribers
- **User** - System users
- **Member** - Workspace members
- **Workspace** - Multi-tenant workspace

### Key Controllers

#### Admin Controllers
- `Pages::PostsController` - Post management
- `Pages::CategoriesController` - Category management
- `NewslettersController` - Newsletter management
- `AuthorsController` - Author management

#### Public Controllers
- `Public::PagesController` - Public page rendering
- `Public::PostsController` - Public post display
- `Public::CategoriesController` - Category listings
- `Public::AuthorsController` - Author pages

#### API Controllers
- `API::Internal::Pages::PostsController` - Post API
- `API::Internal::Pages::PostRevisionsController` - Revision API
- `API::Internal::Newsletters::EmailsController` - Newsletter API

**See:** [STRUCTURE.md](./STRUCTURE.md) for detailed project structure documentation

---

## 🔗 Additional Resources

### Existing Documentation
- [README.md](../README.md) - Project overview and quick start
- [SETUP_SUMMARY.md](../SETUP_SUMMARY.md) - Setup notes
- [STORAGE_SETUP.md](../STORAGE_SETUP.md) - Storage configuration
- [MINIO_TEST_RESULTS.md](../MINIO_TEST_RESULTS.md) - MinIO testing results

### External Links
- [BlogBowl Website](https://www.blogbowl.io)
- [Demo Video](https://www.blogbowl.io/blog-hosting#demo)
- [Postmark Documentation](https://postmarkapp.com/developer)
- [TipTap Documentation](https://tiptap.dev)

---

## 📝 Documentation Maintenance

This documentation is maintained alongside the codebase. When making significant changes:

1. Update relevant documentation files
2. Update this index if structure changes
3. Keep API documentation synchronized with code
4. Update version numbers and dates

### Contributing to Documentation

- Follow Markdown formatting standards
- Include code examples where applicable
- Cross-reference related sections
- Keep documentation concise but complete

---

**Documentation Generated:** 2025-01-27  
**Project:** BlogBowl  
**License:** MIT

