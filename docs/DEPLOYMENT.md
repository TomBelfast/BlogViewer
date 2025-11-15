# BlogBowl Deployment Guide

> **Production deployment strategies and best practices**

**Last Updated:** 2025-01-27  
**Related:** [INDEX.md](./INDEX.md) | [ARCHITECTURE.md](./ARCHITECTURE.md)

---

## Table of Contents

1. [Docker Deployment](#docker-deployment)
2. [Environment Configuration](#environment-configuration)
3. [Database Setup](#database-setup)
4. [Storage Configuration](#storage-configuration)
5. [Email Configuration](#email-configuration)
6. [SSL/HTTPS Setup](#sslhttps-setup)
7. [Monitoring & Logging](#monitoring--logging)
8. [Scaling](#scaling)
9. [Backup & Recovery](#backup--recovery)
10. [Security Hardening](#security-hardening)

---

## Docker Deployment

### Quick Start

BlogBowl includes Docker Compose configuration for easy deployment:

```bash
# Clone repository
git clone <repository-url>
cd BlogBowl

# Copy environment file
cp .env.example .env
# Edit .env with production values

# Start services
docker compose up -d

# Check status
docker compose ps
```

### Docker Services

The deployment includes:

1. **blogbowl_app** - Main Rails application
2. **blogbowl_sidekiq** - Background job processor
3. **postgres** - PostgreSQL database
4. **redis** - Redis cache/queue

### Docker Compose Configuration

```yaml
services:
  blogbowl_app:
    image: blogbowl/blogbowl:latest
    ports:
      - "3000:3000"
    env_file:
      - .env
    depends_on:
      - postgres
      - redis
  
  blogbowl_sidekiq:
    image: blogbowl/blogbowl:latest
    command: ["bundle", "exec", "sidekiq"]
    env_file:
      - .env
    depends_on:
      - postgres
      - redis
```

### Building Docker Image

```bash
# Build image
docker build -t blogbowl/blogbowl:latest .

# Tag for registry
docker tag blogbowl/blogbowl:latest registry.example.com/blogbowl:latest

# Push to registry
docker push registry.example.com/blogbowl:latest
```

---

## Environment Configuration

### Required Environment Variables

```bash
# Rails
RAILS_ENV=production
SECRET_KEY_BASE=<generate-secure-key>
RAILS_MASTER_KEY=<master-key>

# Database
DATABASE_URL=postgresql://user:password@postgres:5432/blogbowl

# Redis
REDIS_URL=redis://redis:6379/0

# Application
APP_DOCKER_HOST=your-domain.com

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

### Generating Secrets

```bash
# Generate SECRET_KEY_BASE
rails secret

# Generate master key (if using encrypted credentials)
rails credentials:edit
```

### Environment File Security

- Never commit `.env` to version control
- Use secrets management (AWS Secrets Manager, HashiCorp Vault)
- Rotate secrets regularly
- Use different secrets for each environment

---

## Database Setup

### PostgreSQL Configuration

#### Production Settings

```yaml
# docker-compose.yaml
postgres:
  image: postgres:15
  environment:
    POSTGRES_DB: blogbowl
    POSTGRES_USER: blogbowl
    POSTGRES_PASSWORD: <strong-password>
  volumes:
    - postgres_data:/var/lib/postgresql/data
  command:
    - postgres
    - -c
    - shared_buffers=256MB
    - -c
    - max_connections=200
```

#### Database Initialization

```bash
# Run migrations
docker compose exec blogbowl_app rails db:migrate

# Seed database (optional)
docker compose exec blogbowl_app rails db:seed
```

#### Connection Pooling

Configure Puma for database connections:

```ruby
# config/puma.rb
workers ENV.fetch("WEB_CONCURRENCY") { 2 }
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Database connection pool
preload_app!
```

### Database Backups

```bash
# Manual backup
docker compose exec postgres pg_dump -U blogbowl blogbowl > backup.sql

# Restore backup
docker compose exec -T postgres psql -U blogbowl blogbowl < backup.sql
```

---

## Storage Configuration

### S3-Compatible Storage

BlogBowl supports S3-compatible storage (AWS S3, MinIO, DigitalOcean Spaces).

#### Configuration

```yaml
# config/storage.yml
production:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: <%= ENV['AWS_REGION'] %>
  bucket: <%= ENV['AWS_BUCKET'] %>
  endpoint: <%= ENV['AWS_ENDPOINT'] %>  # For MinIO
```

#### AWS S3 Setup

1. Create S3 bucket
2. Configure IAM user with S3 permissions
3. Set CORS policy for public access
4. Set environment variables

#### MinIO Setup

See [STORAGE_SETUP.md](../STORAGE_SETUP.md) for detailed MinIO configuration.

#### Storage Migration

```bash
# Migrate from local to S3
rails active_storage:install
rails db:migrate

# Copy existing files (if migrating)
# Use Active Storage migration tool or manual copy
```

---

## Email Configuration

### Postmark Setup

1. **Create Postmark Account**
   - Sign up at https://postmarkapp.com
   - Verify sender domain
   - Get account token

2. **Configure Environment**
   ```bash
   POSTMARK_ACCOUNT_TOKEN=<your-token>
   POSTMARK_X_API_KEY=<webhook-secret>
   ```

3. **Verify Domain**
   - Add DNS records (SPF, DKIM)
   - Verify in Postmark dashboard
   - Update domain in BlogBowl settings

### Email Testing

```bash
# Test email sending
rails console
NewsletterEmail.first.send_test_email("test@example.com")
```

---

## SSL/HTTPS Setup

### Using Nginx Reverse Proxy

#### Nginx Configuration

```nginx
server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

#### Let's Encrypt SSL

```bash
# Install Certbot
sudo apt-get install certbot python3-certbot-nginx

# Obtain certificate
sudo certbot --nginx -d your-domain.com

# Auto-renewal
sudo certbot renew --dry-run
```

### Using Cloudflare

1. Add domain to Cloudflare
2. Set SSL mode to "Full"
3. Configure DNS records
4. Enable proxy (orange cloud)

---

## Monitoring & Logging

### Application Logs

```bash
# View application logs
docker compose logs -f blogbowl_app

# View Sidekiq logs
docker compose logs -f blogbowl_sidekiq

# View all logs
docker compose logs -f
```

### Health Checks

```bash
# Application health
curl http://localhost:3000/up

# Sidekiq Web UI
# Access at http://your-domain.com/sidekiq
```

### Monitoring Tools

#### Recommended Tools

- **Sentry** - Error tracking
- **New Relic** - Application performance monitoring
- **Datadog** - Infrastructure monitoring
- **Prometheus** - Metrics collection

#### Setup Sentry

```ruby
# Gemfile
gem 'sentry-ruby'
gem 'sentry-rails'

# config/initializers/sentry.rb
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
end
```

---

## Scaling

### Horizontal Scaling

#### Multiple Application Instances

```yaml
# docker-compose.yaml
services:
  blogbowl_app:
    deploy:
      replicas: 3
    # ...
```

#### Load Balancer Configuration

Use Nginx or cloud load balancer:

```nginx
upstream blogbowl {
    least_conn;
    server app1:3000;
    server app2:3000;
    server app3:3000;
}

server {
    location / {
        proxy_pass http://blogbowl;
    }
}
```

### Vertical Scaling

#### Resource Limits

```yaml
services:
  blogbowl_app:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G
```

#### Database Scaling

- Use read replicas for read-heavy workloads
- Implement connection pooling
- Optimize queries and indexes

### Sidekiq Scaling

```yaml
services:
  blogbowl_sidekiq:
    deploy:
      replicas: 2
    # ...
```

---

## Backup & Recovery

### Database Backups

#### Automated Backups

```bash
#!/bin/bash
# backup.sh
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups"
docker compose exec -T postgres pg_dump -U blogbowl blogbowl | gzip > "$BACKUP_DIR/blogbowl_$DATE.sql.gz"

# Keep only last 30 days
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete
```

#### Cron Job

```bash
# Add to crontab
0 2 * * * /path/to/backup.sh
```

### Storage Backups

- S3: Enable versioning and lifecycle policies
- MinIO: Use MinIO's built-in backup tools
- Regular snapshots of storage volumes

### Recovery Procedures

#### Database Recovery

```bash
# Stop application
docker compose stop blogbowl_app

# Restore database
docker compose exec -T postgres psql -U blogbowl blogbowl < backup.sql

# Restart application
docker compose start blogbowl_app
```

#### Full System Recovery

1. Restore database backup
2. Restore storage files
3. Restore environment configuration
4. Restart services
5. Verify functionality

---

## Security Hardening

### Application Security

#### Environment Variables

- Use strong, unique passwords
- Rotate secrets regularly
- Never commit secrets to version control

#### Rails Security

```ruby
# config/environments/production.rb
config.force_ssl = true
config.session_store :redis_store, secure: true
```

#### Database Security

- Use strong passwords
- Limit database access
- Use SSL for database connections
- Regular security updates

### Network Security

#### Firewall Rules

```bash
# Allow only necessary ports
ufw allow 22/tcp   # SSH
ufw allow 80/tcp   # HTTP
ufw allow 443/tcp  # HTTPS
ufw enable
```

#### Docker Security

- Use non-root user in containers
- Limit container capabilities
- Scan images for vulnerabilities
- Keep images updated

### Regular Updates

```bash
# Update system packages
sudo apt update && sudo apt upgrade

# Update Docker images
docker compose pull
docker compose up -d

# Update Ruby gems
bundle update

# Update npm packages
bun update
```

---

## Performance Optimization

### Caching

#### Redis Caching

```ruby
# config/environments/production.rb
config.cache_store = :redis_cache_store, {
  url: ENV['REDIS_URL'],
  expires_in: 90.minutes
}
```

#### Page Caching

Consider implementing page caching for public pages:

```ruby
# In controller
caches_page :show, if: -> { @post.published? }
```

### Database Optimization

- Add indexes for frequently queried fields
- Use database query optimization
- Implement database connection pooling
- Regular VACUUM and ANALYZE

### Asset Optimization

- Enable asset compression
- Use CDN for static assets
- Implement browser caching
- Minify CSS and JavaScript

---

## Troubleshooting

### Common Deployment Issues

#### Application Won't Start

```bash
# Check logs
docker compose logs blogbowl_app

# Check environment variables
docker compose exec blogbowl_app env

# Verify database connection
docker compose exec blogbowl_app rails db:version
```

#### High Memory Usage

- Increase container memory limits
- Optimize database queries
- Reduce Sidekiq concurrency
- Implement caching

#### Slow Performance

- Check database indexes
- Review query performance
- Optimize asset delivery
- Scale horizontally

---

**Related Documentation:**
- [INDEX.md](./INDEX.md) - Main documentation index
- [ARCHITECTURE.md](./ARCHITECTURE.md) - System architecture
- [STORAGE_SETUP.md](../STORAGE_SETUP.md) - Storage configuration

