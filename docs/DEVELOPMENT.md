# BlogBowl Development Guide

> **Complete guide for setting up and developing BlogBowl**

**Last Updated:** 2025-01-27  
**Related:** [INDEX.md](./INDEX.md) | [ARCHITECTURE.md](./ARCHITECTURE.md)

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
3. [Development Workflow](#development-workflow)
4. [Testing](#testing)
5. [Debugging](#debugging)
6. [Code Quality](#code-quality)
7. [Common Tasks](#common-tasks)
8. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

- **Ruby:** 3.2.2 or higher (recommended: use rbenv)
- **Bun:** Latest version (for JavaScript/TypeScript)
- **PostgreSQL:** 15 or higher
- **Redis:** Latest version
- **Docker:** For running PostgreSQL and Redis services
- **Git:** Version control

### Optional Tools

- **rbenv:** Ruby version management
- **Foreman:** Process management
- **Postman/Insomnia:** API testing
- **VS Code/Cursor:** IDE with Ruby and TypeScript support

---

## Initial Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd BlogBowl
```

### 2. Install Ruby Dependencies

#### Using rbenv (Recommended)

```bash
# Install rbenv if not already installed
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# Add to shell profile (~/.bashrc or ~/.zshrc)
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
source ~/.bashrc

# Install Ruby 3.2.2
rbenv install 3.2.2
rbenv local 3.2.2

# Install bundler
gem install bundler
```

#### Install Gems

```bash
bundle install
```

### 3. Install JavaScript Dependencies

```bash
# Install Bun if not already installed
curl -fsSL https://bun.sh/install | bash

# Install dependencies
bun install
```

### 4. Setup Environment Variables

```bash
# Copy example environment file
cp .env.example .env

# Edit .env with your configuration
nano .env  # or use your preferred editor
```

**Required Environment Variables:**

```bash
# Database
DATABASE_URL=postgresql://blogbowl:blogbowl@localhost:5435/blogbowl

# Redis
REDIS_URL=redis://localhost:6380/0

# Rails
RAILS_ENV=development
SECRET_KEY_BASE=<generate-with-rails-secret>

# Application
APP_DOCKER_HOST=localhost
```

**Generate Secret Key:**

```bash
rails secret
# Copy the output to SECRET_KEY_BASE in .env
```

### 5. Start Database Services

```bash
# Start PostgreSQL and Redis using Docker Compose
docker compose -f docker-compose.dev.yaml up -d

# Verify services are running
docker ps
```

### 6. Setup Database

```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Seed database (creates default admin user)
rails db:seed
```

### 7. Build Assets

```bash
# Build CSS files
bun run build:css
```

### 8. Start Development Server

```bash
# Using Foreman (recommended)
bundle exec foreman start -f Procfile.dev

# Or manually:
# Terminal 1: Rails server
rails server

# Terminal 2: CSS watcher (optional)
bun run build:css:watch
```

### 9. Verify Installation

1. Open browser: `http://localhost:3000`
2. Login with default credentials:
   - Email: `admin@example.com`
   - Password: `changeme`
3. Change password immediately!

---

## Development Workflow

### Project Structure

```
BlogBowl/
├── app/                    # Main application
├── submodules/
│   ├── core/              # Rails Engine (backend)
│   └── editor/            # React editor (frontend)
├── config/                # Configuration files
├── db/                    # Database migrations and seeds
└── test/                  # Tests
```

### Working with the Core Engine

The core functionality is in `submodules/core`:

#### Creating Migrations

```bash
# Generate migration in core engine
rails generate migration CreateExampleTable core:install:migrations

# Run migrations
rails db:migrate
```

#### Adding Models

```ruby
# submodules/core/app/models/example.rb
module Core
  class Example < ApplicationRecord
    belongs_to :page
    # ...
  end
end
```

#### Adding Controllers

```ruby
# submodules/core/app/controllers/examples_controller.rb
module Core
  class ExamplesController < ApplicationController
    def index
      @examples = Example.all
    end
  end
end
```

### Working with the React Editor

The editor is in `submodules/editor`:

#### Development Mode

```bash
cd submodules/editor

# Start Vite dev server
bun run dev

# Watch CSS changes
bun run build:css:watch
```

#### Adding Components

```typescript
// submodules/editor/src/components/Example.tsx
import React from 'react'

export const Example: React.FC = () => {
  return <div>Example Component</div>
}
```

#### Adding TipTap Extensions

```typescript
// submodules/editor/src/extensions/Example/index.ts
import { Extension } from '@tiptap/core'

export const Example = Extension.create({
  name: 'example',
  // Extension configuration
})
```

### Hot Reloading

- **Rails:** Uses `hotwire-livereload` for automatic page reloads
- **React:** Vite HMR for instant updates
- **CSS:** Watch mode rebuilds CSS automatically

---

## Testing

### Running Tests

#### All Tests

```bash
rails test
```

#### Specific Test File

```bash
rails test test/models/post_test.rb
```

#### Specific Test

```bash
rails test test/models/post_test.rb:25
```

#### Test Coverage

```bash
# Install SimpleCov (add to Gemfile)
gem 'simplecov', require: false, group: :test

# Run tests with coverage
COVERAGE=true rails test
```

### Writing Tests

#### Model Tests

```ruby
# test/models/post_test.rb
require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "should create post" do
    post = Post.new(
      title: "Test Post",
      content: "<p>Content</p>",
      page: pages(:one)
    )
    assert post.save
  end
end
```

#### Controller Tests

```ruby
# test/controllers/posts_controller_test.rb
require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:admin)
    get posts_url
    assert_response :success
  end
end
```

#### System Tests

```ruby
# test/system/posts_test.rb
require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  test "creating a post" do
    visit posts_url
    click_on "New Post"
    fill_in "Title", with: "Test Post"
    click_on "Create Post"
    assert_text "Post was successfully created"
  end
end
```

### Test Database

Tests use a separate database (`blogbowl_test`):

```bash
# Setup test database
RAILS_ENV=test rails db:create
RAILS_ENV=test rails db:migrate
```

---

## Debugging

### Rails Debugging

#### Using `debug` Gem

```ruby
# Add breakpoint
binding.break

# Interactive debugging session
# Use commands: next, step, continue, etc.
```

#### Rails Console

```bash
# Start console
rails console

# Or with environment
rails console --environment=development
```

**Useful Console Commands:**

```ruby
# Find records
Post.all
Post.find(1)
Post.where(status: 'published')

# Create records
Post.create(title: "Test", content: "<p>Content</p>")

# Associations
post = Post.first
post.authors
post.categories
```

### Frontend Debugging

#### React DevTools

Install React DevTools browser extension for component inspection.

#### Console Logging

```typescript
// Use console.log for debugging
console.log('Debug value:', value)

// Use React Query DevTools
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'
```

#### Network Debugging

Use browser DevTools Network tab to inspect API requests.

### Logging

#### Rails Logs

```bash
# View logs
tail -f log/development.log

# Or with Rails
rails log:clear
```

#### Custom Logging

```ruby
# Use Rails logger
Rails.logger.info "Debug message"
Rails.logger.error "Error message"

# Or use AppLogger
AppLogger.info("Custom log message")
```

---

## Code Quality

### Ruby Linting

#### RuboCop

```bash
# Run RuboCop
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -a

# Check specific file
bundle exec rubocop app/models/post.rb
```

#### Brakeman (Security)

```bash
# Run Brakeman security scan
bundle exec brakeman

# Generate report
bundle exec brakeman -o brakeman-report.html
```

### TypeScript/JavaScript Linting

```bash
cd submodules/editor

# Run ESLint
bun run lint

# Fix issues
bun run lint --fix
```

### Code Formatting

#### Ruby

```bash
# Use RuboCop for formatting
bundle exec rubocop -a
```

#### TypeScript/JavaScript

```bash
cd submodules/editor

# Format with Prettier
bun run format
```

---

## Common Tasks

### Creating a New Post

1. Navigate to Posts page
2. Click "New Post"
3. Fill in title and content
4. Select authors and categories
5. Save as draft or publish

### Adding a New Author

1. Navigate to Authors page
2. Click "New Author"
3. Fill in author details
4. Add social links (optional)
5. Save

### Sending a Newsletter

1. Navigate to Newsletters
2. Select newsletter
3. Click "New Email"
4. Write email content
5. Schedule or send immediately

### Database Migrations

```bash
# Create migration
rails generate migration AddColumnToPosts column_name:type

# Run migration
rails db:migrate

# Rollback migration
rails db:rollback

# Check migration status
rails db:migrate:status
```

### Seeding Data

```bash
# Run seeds
rails db:seed

# Or specific seed file
rails db:seed:replant
```

### Asset Compilation

```bash
# Build CSS
bun run build:css

# Watch CSS changes
bun run build:css:watch

# Build all assets
bun run build
```

### Clearing Cache

```bash
# Clear Rails cache
rails tmp:clear

# Clear Redis cache
redis-cli FLUSHALL
```

---

## Troubleshooting

### Common Issues

#### Database Connection Error

```bash
# Check PostgreSQL is running
docker ps

# Check connection string in .env
# Verify DATABASE_URL is correct

# Restart PostgreSQL
docker compose -f docker-compose.dev.yaml restart postgres
```

#### Redis Connection Error

```bash
# Check Redis is running
docker ps

# Check REDIS_URL in .env
# Verify Redis URL is correct

# Restart Redis
docker compose -f docker-compose.dev.yaml restart redis
```

#### Asset Compilation Errors

```bash
# Clear node_modules and reinstall
cd submodules/editor
rm -rf node_modules
bun install

# Clear build cache
rm -rf app/assets/builds/*
bun run build:css
```

#### Migration Errors

```bash
# Check migration status
rails db:migrate:status

# Reset database (WARNING: deletes all data)
rails db:reset

# Or rollback and re-run
rails db:rollback
rails db:migrate
```

#### Port Already in Use

```bash
# Find process using port 3000
lsof -i :3000

# Kill process
kill -9 <PID>

# Or use different port
rails server -p 3001
```

#### TipTap Pro License Errors

TipTap Pro extensions require a license. For development:
- Use free alternatives where possible
- Contact TipTap for trial license
- Remove Pro extensions temporarily

### Getting Help

1. Check existing documentation
2. Review error logs
3. Search GitHub issues
4. Ask in community forums

---

## Best Practices

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/my-feature

# Commit changes
git add .
git commit -m "Add feature description"

# Push branch
git push origin feature/my-feature

# Create pull request
```

### Code Organization

- Keep controllers thin
- Move business logic to models or service objects
- Use concerns for shared behavior
- Follow Rails conventions

### Testing

- Write tests for new features
- Maintain test coverage above 80%
- Test edge cases
- Use factories for test data

### Documentation

- Document complex logic
- Update README for setup changes
- Comment API endpoints
- Keep architecture docs updated

---

**Related Documentation:**
- [INDEX.md](./INDEX.md) - Main documentation index
- [API.md](./API.md) - API reference
- [ARCHITECTURE.md](./ARCHITECTURE.md) - System architecture

