# BlogBowl Architecture Documentation

> **Detailed system architecture and design patterns**

**Last Updated:** 2025-01-27  
**Related:** [INDEX.md](./INDEX.md) | [STRUCTURE.md](./STRUCTURE.md)

---

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Component Design](#component-design)
3. [Data Models](#data-models)
4. [API Architecture](#api-architecture)
5. [Frontend Architecture](#frontend-architecture)
6. [Authentication & Authorization](#authentication--authorization)
7. [Background Jobs](#background-jobs)
8. [Storage Architecture](#storage-architecture)

---

## System Architecture

### High-Level Overview

BlogBowl follows a modular monolith architecture pattern:

```
┌─────────────────────────────────────────────────────────┐
│                    Client Browser                        │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│              Rails Application (Port 3000)               │
│  ┌──────────────────────────────────────────────────┐   │
│  │         Main Application (app/)                   │   │
│  │  - Views, Controllers, Assets                    │   │
│  └──────────────┬───────────────────────────────────┘   │
│                 │                                        │
│  ┌──────────────▼───────────────────────────────────┐   │
│  │      Core Engine (submodules/core)                │   │
│  │  - Models, Controllers, Routes                   │   │
│  │  - Business Logic                                │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │    React Editor (submodules/editor)               │   │
│  │  - TipTap Editor Components                       │   │
│  │  - React UI Components                            │   │
│  └──────────────────────────────────────────────────┘   │
└──────────────┬───────────────────────────────────────────┘
               │
    ┌──────────┼──────────┐
    │          │          │
    ▼          ▼          ▼
┌────────┐ ┌──────┐ ┌──────────┐
│PostgreSQL│ │ Redis │ │  Storage │
│  :5432  │ │ :6379 │ │  (S3)    │
└────────┘ └──────┘ └──────────┘
    │
    ▼
┌──────────────┐
│   Sidekiq    │
│ (Background) │
└──────────────┘
```

### Technology Stack

#### Backend
- **Framework:** Ruby on Rails 8.0.2
- **Architecture:** Rails Engine (modular)
- **Database:** PostgreSQL 15+
- **Cache/Queue:** Redis
- **Background Jobs:** Sidekiq
- **Authentication:** Session-based
- **Authorization:** CanCanCan

#### Frontend
- **Framework:** React 18.3.1
- **Language:** TypeScript 5.1.6
- **Editor:** TipTap 2.3.0 (with Pro extensions)
- **Build Tool:** Vite
- **Styling:** Tailwind CSS 4.1.7
- **State Management:** React Query (TanStack Query)
- **UI Components:** Radix UI

#### Infrastructure
- **Containerization:** Docker & Docker Compose
- **Web Server:** Puma
- **Asset Pipeline:** Propshaft
- **Email:** Postmark
- **Storage:** Active Storage (S3-compatible)

---

## Component Design

### Rails Engine Architecture

The core functionality is packaged as a Rails Engine (`submodules/core`), providing:

#### Benefits
- **Modularity:** Core functionality isolated and reusable
- **Testability:** Engine can be tested independently
- **Maintainability:** Clear separation of concerns
- **Extensibility:** Easy to add features without modifying core

#### Engine Structure

```ruby
# submodules/core/lib/core/engine.rb
module Core
  class Engine < ::Rails::Engine
    isolate_namespace Core
    
    # Engine configuration
    config.generators do |g|
      g.test_framework :test_unit
      g.fixture_replacement :factory_bot
    end
  end
end
```

#### Engine Mounting

```ruby
# config/application.rb
module BlogBowl
  class Application < Rails::Application
    # Mount the Core engine
    config.paths.add "submodules/core", eager_load: true
  end
end

# Gemfile
gem "core", path: "submodules/core"
```

### Module Organization

#### Core Engine Modules

1. **Models** (`app/models/`)
   - Domain entities (Post, Page, Author, etc.)
   - Concerns for shared behavior
   - Validations and associations

2. **Controllers** (`app/controllers/`)
   - Admin controllers (namespaced)
   - Public controllers (namespaced)
   - API controllers (namespaced)
   - Concerns for shared logic

3. **Views** (`app/views/`)
   - ERB templates
   - Partials and layouts
   - Mailer templates

4. **Jobs** (`app/jobs/`)
   - Sidekiq background jobs
   - Email sending
   - Data processing

5. **Config** (`config/`)
   - Routes
   - Initializers
   - Environment configuration

---

## Data Models

### Core Entities

#### Page (Workspace)
Represents a blog/workspace instance with its own:
- Posts
- Categories
- Authors
- Settings
- Newsletter configuration

```ruby
class Page < ApplicationRecord
  has_many :posts
  has_many :categories
  has_many :authors
  has_one :page_setting
  has_one :workspace_setting
end
```

#### Post
Blog post/article with:
- Rich content (HTML/TipTap JSON)
- Authors (many-to-many)
- Categories (many-to-many)
- Revisions (version history)
- Publishing status

```ruby
class Post < ApplicationRecord
  belongs_to :page
  has_many :post_authors
  has_many :authors, through: :post_authors
  has_many :post_revisions
  has_many :categories_posts
  has_many :categories, through: :categories_posts
end
```

#### PostRevision
Version history for posts:
- Content snapshots
- Timestamps
- Share tokens for previews

```ruby
class PostRevision < ApplicationRecord
  belongs_to :post
  has_one :share_token
end
```

#### Author
Content author with:
- Profile information
- Links (social media, etc.)
- Association with Member (user)

```ruby
class Author < ApplicationRecord
  belongs_to :member
  has_many :post_authors
  has_many :posts, through: :post_authors
  has_many :author_links
end
```

#### Newsletter
Newsletter instance with:
- Email templates
- Subscribers
- Settings (domain, DKIM, etc.)

```ruby
class Newsletter < ApplicationRecord
  has_many :newsletter_emails
  has_many :subscribers
  has_one :newsletter_setting
end
```

### Relationships Diagram

```
Workspace
  ├── Page (1:1)
  │     ├── Posts (1:N)
  │     │     ├── PostAuthors (N:M)
  │     │     ├── PostRevisions (1:N)
  │     │     └── CategoriesPosts (N:M)
  │     ├── Categories (1:N)
  │     └── Authors (N:M via Posts)
  │
  ├── Members (1:N)
  │     └── Author (1:1)
  │
  └── Newsletter (1:1)
        ├── NewsletterEmails (1:N)
        └── Subscribers (1:N)
```

---

## API Architecture

### API Design Principles

1. **RESTful Conventions:** Standard HTTP methods and status codes
2. **JSON Responses:** All APIs return JSON
3. **Namespacing:** Clear separation between internal and public APIs
4. **Authentication:** Session-based for admin, token-based for webhooks
5. **Versioning:** Namespace-based (future: `/api/v1/`)

### API Structure

#### Internal API (`/api/internal`)
Admin interface endpoints for:
- Content management (posts, categories)
- Newsletter management
- Analytics
- Settings

**Authentication:** Session-based (via Rails session)

#### Public API (`/api/public`)
Public webhook endpoints:
- Postmark event webhooks
- External integrations

**Authentication:** Token-based (API keys)

### Route Organization

```ruby
namespace :api do
  namespace :internal do
    namespace :pages do
      scope ':page_id' do
        resources :posts
        resources :categories
        resources :revisions
      end
    end
    
    namespace :newsletters do
      scope ':newsletter_id' do
        resources :emails
      end
    end
  end
  
  namespace :public do
    post 'postmark/event'
  end
end
```

### Request/Response Flow

```
Client Request
    │
    ▼
Rails Router
    │
    ▼
ApplicationController (sets Current.user)
    │
    ▼
API::Internal::ApplicationController (authorization)
    │
    ▼
Specific Controller (business logic)
    │
    ▼
Model (data access)
    │
    ▼
JSON Response
```

---

## Frontend Architecture

### React Editor Architecture

The editor (`submodules/editor`) is a standalone React application:

#### Component Hierarchy

```
App
├── EditorContext (Provider)
│   └── BlockEditor / EmailBlockEditor
│       ├── TipTap Editor Instance
│       ├── Toolbar
│       ├── Sidebar
│       └── Menus
│           ├── TextMenu
│           ├── LinkMenu
│           └── ContentItemMenu
└── Modals
    ├── PreviewEmailDialog
    └── GenericModal
```

#### State Management

- **React Query:** Server state (API calls)
- **TipTap State:** Editor content state
- **React Context:** Editor configuration
- **Local State:** UI state (modals, menus)

#### Data Flow

```
User Action
    │
    ▼
React Component
    │
    ▼
React Query Hook (useUpdatePost, etc.)
    │
    ▼
API Call (axios)
    │
    ▼
Rails API Endpoint
    │
    ▼
Response → React Query Cache
    │
    ▼
Component Re-render
```

### TipTap Integration

#### Extension System

TipTap uses an extension-based architecture:

```typescript
import { ExtensionKit } from './extensions/extension-kit'

const editor = useEditor({
  extensions: [
    ExtensionKit,
    // Custom extensions
  ],
})
```

#### Custom Extensions

- **ImageBlock:** Custom image blocks with width controls
- **MultiColumn:** Multi-column layouts
- **TableOfContents:** Auto-generated TOC
- **Emoji:** Emoji picker and insertion
- **FileHandler:** File upload handling

### Asset Pipeline

#### CSS Build Process

```bash
# Tailwind CSS compilation
bunx @tailwindcss/cli \
  -i ./submodules/core/app/assets/stylesheets/core/application.tailwind.css \
  -o ./app/assets/builds/application.css
```

#### JavaScript Build

- Editor: Vite build process
- Main app: jsbundling-rails (Bun)

---

## Authentication & Authorization

### Authentication Flow

1. **Login:** User submits credentials → `SessionsController#create`
2. **Session Creation:** Rails creates session cookie
3. **Current User:** `ApplicationController` sets `Current.user`
4. **Authorization:** CanCanCan checks permissions

### Authorization Model

#### CanCanCan Abilities

```ruby
# app/models/concerns/workspace_ability.rb
class WorkspaceAbility
  include CanCan::Ability
  
  def initialize(user)
    return unless user
    
    can :manage, Page, workspace_id: user.workspace_id
    can :manage, Post, page: { workspace_id: user.workspace_id }
    # ...
  end
end
```

#### Role-Based Access

- **User:** System administrator
- **Member:** Workspace member (can be author)
- **Author:** Content creator (associated with Member)

### Session Management

- **Storage:** Redis (via `session_store` initializer)
- **Expiration:** Configurable
- **Security:** Secure cookies, CSRF protection

---

## Background Jobs

### Sidekiq Integration

Sidekiq handles asynchronous tasks:

#### Job Types

1. **Email Sending**
   - Newsletter delivery
   - Test emails
   - Subscriber notifications

2. **Data Processing**
   - Image processing
   - Content indexing
   - Analytics aggregation

#### Job Example

```ruby
class NewsletterDeliveryJob < ApplicationJob
  queue_as :default
  
  def perform(newsletter_email_id)
    email = NewsletterEmail.find(newsletter_email_id)
    # Send email via Postmark
  end
end
```

#### Sidekiq Web UI

Accessible at `/sidekiq` (admin only)

---

## Storage Architecture

### Active Storage

BlogBowl uses Rails Active Storage for file management:

#### Supported Services

- **Local:** Development
- **S3:** AWS S3, DigitalOcean Spaces
- **MinIO:** Self-hosted S3-compatible storage

#### Storage Configuration

```yaml
# config/storage.yml
amazon:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: <%= ENV['AWS_REGION'] %>
  bucket: <%= ENV['AWS_BUCKET'] %>
  endpoint: <%= ENV['AWS_ENDPOINT'] %>  # For MinIO
```

#### File Attachments

- **Posts:** Featured images, inline images
- **Authors:** Profile images
- **Categories:** Category images
- **Newsletters:** Email attachments

### Image Processing

Uses `ruby-vips` for image transformations:
- Thumbnails
- Resizing
- Format conversion

---

## Performance Considerations

### Caching Strategy

- **Redis:** Session storage, Sidekiq queue
- **Page Caching:** Public pages (future)
- **Fragment Caching:** View partials

### Database Optimization

- **Indexes:** On foreign keys, slugs, search fields
- **Eager Loading:** Prevents N+1 queries
- **Pagination:** Pagy for list views

### Frontend Optimization

- **Code Splitting:** Vite automatic splitting
- **Asset Minification:** Production builds
- **CDN:** Static assets (future)

---

## Security Architecture

### Security Measures

1. **CSRF Protection:** Rails CSRF tokens
2. **XSS Prevention:** Content sanitization
3. **SQL Injection:** Parameterized queries (ActiveRecord)
4. **Authentication:** Secure session management
5. **Authorization:** CanCanCan permission checks
6. **CORS:** Configured for API endpoints

### Content Security Policy

Configured in `config/initializers/content_security_policy.rb`

---

## Scalability Considerations

### Horizontal Scaling

- **Stateless Application:** Can run multiple instances
- **Shared Storage:** S3/MinIO for files
- **Shared Cache:** Redis for sessions/cache
- **Database:** PostgreSQL with connection pooling

### Vertical Scaling

- **Puma Workers:** Configurable worker count
- **Sidekiq Concurrency:** Configurable thread count
- **Database:** Connection pool sizing

---

**Related Documentation:**
- [INDEX.md](./INDEX.md) - Main documentation index
- [API.md](./API.md) - Complete API reference
- [STRUCTURE.md](./STRUCTURE.md) - Project structure details

