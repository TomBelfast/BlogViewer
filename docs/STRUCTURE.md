# BlogBowl Project Structure

> **Detailed directory organization and file structure**

**Last Updated:** 2025-01-27  
**Related:** [INDEX.md](./INDEX.md) | [ARCHITECTURE.md](./ARCHITECTURE.md)

---

## Table of Contents

1. [Root Directory](#root-directory)
2. [Main Application](#main-application)
3. [Core Engine](#core-engine)
4. [React Editor](#react-editor)
5. [Configuration Files](#configuration-files)
6. [Database Structure](#database-structure)
7. [Asset Organization](#asset-organization)

---

## Root Directory

```
BlogBowl/
├── app/                          # Main Rails application
├── bin/                          # Executable scripts
├── config/                       # Application configuration
├── db/                           # Database files
├── lib/                          # Application libraries
├── log/                          # Application logs
├── public/                       # Public static files
├── storage/                      # Active Storage files (development)
├── submodules/                   # Submodules (core engine, editor)
├── test/                         # Test files
├── tmp/                          # Temporary files
├── vendor/                       # Third-party code
├── .env.example                  # Environment variables example
├── .gitignore                    # Git ignore rules
├── Dockerfile                    # Docker image definition
├── docker-compose.yaml           # Production Docker Compose
├── docker-compose.dev.yaml       # Development Docker Compose
├── Gemfile                       # Ruby dependencies
├── Gemfile.lock                  # Locked Ruby dependencies
├── package.json                  # JavaScript dependencies
├── Procfile.dev                  # Development process file
├── Procfile.test                 # Test process file
├── Rakefile                      # Rake tasks
├── README.md                     # Project README
└── bun.config.js                 # Bun configuration
```

---

## Main Application

### `app/` Directory

```
app/
├── assets/                       # Compiled assets
│   └── builds/                  # Built CSS/JS files
│       ├── application.css      # Main application CSS
│       ├── editor/              # Editor-specific CSS
│       └── public/              # Public-facing CSS
│
├── controllers/                 # Application controllers
│   └── application_controller.rb
│
├── helpers/                      # View helpers
│   └── application_helper.rb
│
├── javascript/                   # JavaScript files
│   └── application.js
│
├── models/                       # Application models
│   └── application_record.rb
│
└── views/                       # View templates
    └── layouts/
        └── application.html.erb
```

---

## Core Engine

### `submodules/core/` Directory

The core functionality is packaged as a Rails Engine:

```
submodules/core/
├── app/
│   ├── assets/
│   │   └── stylesheets/
│   │       └── core/
│   │           ├── application.tailwind.css
│   │           ├── editor/
│   │           │   └── editor.tailwind.css
│   │           └── public/
│   │               └── basic.tailwind.css
│   │
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── api/
│   │   │   ├── internal/
│   │   │   │   ├── application_controller.rb
│   │   │   │   ├── analytics_controller.rb
│   │   │   │   ├── authors_controller.rb
│   │   │   │   ├── domains_controller.rb
│   │   │   │   ├── newsletters/
│   │   │   │   │   └── emails_controller.rb
│   │   │   │   └── pages/
│   │   │   │       ├── application_controller.rb
│   │   │   │       ├── categories_controller.rb
│   │   │   │       ├── images_controller.rb
│   │   │   │       ├── posts_controller.rb
│   │   │   │       └── post_revisions_controller.rb
│   │   │   └── public/
│   │   │       └── postmark_controller.rb
│   │   ├── authors_controller.rb
│   │   ├── concerns/
│   │   │   ├── pages_controller_concern.rb
│   │   │   └── pages/
│   │   │       └── application_controller_concern.rb
│   │   ├── home_controller.rb
│   │   ├── members_controller.rb
│   │   ├── newsletters/
│   │   │   ├── application_controller.rb
│   │   │   ├── newsletter_emails_controller.rb
│   │   │   ├── settings_controller.rb
│   │   │   └── subscribers_controller.rb
│   │   ├── pages/
│   │   │   ├── application_controller.rb
│   │   │   ├── analytics_controller.rb
│   │   │   ├── categories_controller.rb
│   │   │   ├── posts_controller.rb
│   │   │   └── settings/
│   │   │       ├── application_controller.rb
│   │   │       ├── cta_controller.rb
│   │   │       ├── domain_controller.rb
│   │   │       ├── footer_controller.rb
│   │   │       ├── general_controller.rb
│   │   │       ├── header_controller.rb
│   │   │       ├── layout_controller.rb
│   │   │       ├── links_controller.rb
│   │   │       └── newsletter_controller.rb
│   │   ├── pages_controller.rb
│   │   ├── passwords_controller.rb
│   │   ├── previews_controller.rb
│   │   ├── public/
│   │   │   ├── application_controller.rb
│   │   │   ├── archive_controller.rb
│   │   │   ├── authors_controller.rb
│   │   │   ├── categories_controller.rb
│   │   │   ├── page_application_controller.rb
│   │   │   ├── pages_controller.rb
│   │   │   ├── posts_controller.rb
│   │   │   ├── sitemap_controller.rb
│   │   │   └── subscriber_controller.rb
│   │   ├── sessions_controller.rb
│   │   ├── settings/
│   │   │   ├── application_controller.rb
│   │   │   └── general_controller.rb
│   │   ├── settings_controller.rb
│   │   └── users_controller.rb
│   │
│   ├── jobs/
│   │   └── application_job.rb
│   │
│   ├── mailers/
│   │   └── application_mailer.rb
│   │
│   ├── models/
│   │   ├── application_record.rb
│   │   ├── author_link.rb
│   │   ├── author.rb
│   │   ├── category.rb
│   │   ├── concerns/
│   │   │   ├── author_ability.rb
│   │   │   ├── member_ability.rb
│   │   │   └── workspace_ability.rb
│   │   ├── current.rb
│   │   ├── link.rb
│   │   ├── member.rb
│   │   ├── newsletter_email.rb
│   │   ├── newsletter_setting.rb
│   │   ├── newsletter.rb
│   │   ├── page_setting.rb
│   │   ├── page.rb
│   │   ├── post_author.rb
│   │   ├── post_revision.rb
│   │   ├── post.rb
│   │   ├── session.rb
│   │   ├── subscriber.rb
│   │   ├── user.rb
│   │   ├── workspace_setting.rb
│   │   └── workspace.rb
│   │
│   └── views/
│       ├── layouts/
│       │   └── application.html.erb
│       └── [various view templates]
│
├── config/
│   ├── application.rb           # Engine application config
│   ├── boot.rb                  # Engine boot configuration
│   ├── environment.rb           # Environment configuration
│   ├── routes.rb                # Engine routes
│   ├── initializers/
│   │   ├── assets.rb
│   │   ├── content_security_policy.rb
│   │   ├── cors.rb
│   │   ├── feature_guard.rb
│   │   ├── filter_parameter_logging.rb
│   │   ├── inflections.rb
│   │   ├── non_digest_assets.rb
│   │   ├── pagy.rb
│   │   ├── permissions_policy.rb
│   │   ├── puma.rb
│   │   ├── session_store.rb
│   │   ├── sidekiq.rb
│   │   └── truemail.rb
│   ├── environments/
│   │   ├── development.rb
│   │   └── test.rb
│   ├── database.yml              # Database configuration
│   ├── storage.yml               # Storage configuration
│   ├── cable.yml                 # Action Cable configuration
│   ├── mailers.yml               # Mailer configuration
│   └── redis/
│       └── shared.yml            # Redis configuration
│
├── db/
│   ├── migrate/                  # Database migrations
│   │   ├── 20250523084615_create_users.rb
│   │   ├── 20250523084616_create_sessions.rb
│   │   ├── 20250523120802_create_active_storage_tables.active_storage.rb
│   │   └── [other migrations]
│   └── seeds.rb                  # Seed data
│
├── lib/
│   ├── core/
│   │   ├── engine.rb            # Engine definition
│   │   └── version.rb            # Engine version
│   ├── app_logger.rb            # Logging utility
│   ├── core.rb                  # Core module
│   └── feature_guard.rb         # Feature flags
│
└── test/
    ├── fixtures/                 # Test fixtures
    ├── models/                   # Model tests
    ├── controllers/              # Controller tests
    ├── integration/              # Integration tests
    ├── mailers/                  # Mailer tests
    ├── abilities/                # Ability tests
    └── test_helper.rb            # Test configuration
```

---

## React Editor

### `submodules/editor/` Directory

```
submodules/editor/
├── src/
│   ├── components/
│   │   ├── modal/
│   │   │   ├── DefaultEmail.tsx
│   │   │   ├── GenericModal.tsx
│   │   │   └── PreviewEmailDialog.tsx
│   │   ├── tiptap/
│   │   │   ├── menus/
│   │   │   │   ├── ContentItemMenu/
│   │   │   │   │   ├── ContentItemMenu.tsx
│   │   │   │   │   ├── DragHandle.tsx
│   │   │   │   │   └── hooks/
│   │   │   │   │       ├── useContentItemActions.tsx
│   │   │   │   │       └── useData.tsx
│   │   │   │   ├── LinkMenu/
│   │   │   │   │   └── LinkMenu.tsx
│   │   │   │   └── TextMenu/
│   │   │   │       ├── TextMenu.tsx
│   │   │   │       └── components/
│   │   │   │           ├── ContentTypePicker.tsx
│   │   │   │           ├── EditLinkPopover.tsx
│   │   │   │           ├── FontFamilyPicker.tsx
│   │   │   │           └── FontSizePicker.tsx
│   │   │   ├── panels/
│   │   │   │   ├── Colorpicker/
│   │   │   │   │   ├── ColorButton.tsx
│   │   │   │   │   ├── Colorpicker.tsx
│   │   │   │   │   └── index.tsx
│   │   │   │   ├── LinkEditorPanel/
│   │   │   │   │   ├── LinkEditorPanel.tsx
│   │   │   │   │   └── index.tsx
│   │   │   │   └── LinkPreviewPanel/
│   │   │   │       ├── LinkPreviewPanel.tsx
│   │   │   │       └── index.tsx
│   │   │   ├── Sidebar/
│   │   │   │   ├── EmailSidebar.tsx
│   │   │   │   ├── Sidebar.tsx
│   │   │   │   └── index.tsx
│   │   │   ├── TableOfContents/
│   │   │   │   ├── TableOfContents.tsx
│   │   │   │   └── index.tsx
│   │   │   ├── ui/
│   │   │   │   ├── Button.tsx
│   │   │   │   ├── Dropdown/
│   │   │   │   ├── Icon.tsx
│   │   │   │   ├── Loader/
│   │   │   │   ├── Panel/
│   │   │   │   ├── PopoverMenu.tsx
│   │   │   │   ├── Spinner/
│   │   │   │   ├── Surface.tsx
│   │   │   │   ├── Textarea/
│   │   │   │   ├── Toggle/
│   │   │   │   └── Toolbar.tsx
│   │   │   └── ui/
│   │   │       ├── badge.tsx
│   │   │       ├── button.tsx
│   │   │       ├── calendar.tsx
│   │   │       ├── command.tsx
│   │   │       ├── dialog.tsx
│   │   │       ├── label.tsx
│   │   │       ├── popover.tsx
│   │   │       ├── select.tsx
│   │   │       ├── skeleton.tsx
│   │   │       ├── tabs.tsx
│   │   │       └── tooltip.tsx
│   │   │
│   │   ├── extensions/
│   │   │   ├── BlockquoteFigure/
│   │   │   │   ├── BlockquoteFigure.ts
│   │   │   │   ├── Quote/
│   │   │   │   │   └── Quote.ts
│   │   │   │   └── QuoteCaption/
│   │   │   │       └── QuoteCaption.ts
│   │   │   ├── Document/
│   │   │   │   └── Document.ts
│   │   │   ├── Emoji/
│   │   │   │   └── Emoji.ts
│   │   │   ├── EmojiSuggestion/
│   │   │   │   ├── components/
│   │   │   │   │   └── EmojiList.tsx
│   │   │   │   ├── suggestion.ts
│   │   │   │   └── types.ts
│   │   │   ├── ExtendedYoutube/
│   │   │   │   └── index.ts
│   │   │   ├── Figure/
│   │   │   │   └── Figure.ts
│   │   │   ├── Figcaption/
│   │   │   │   └── Figcaption.ts
│   │   │   ├── FileHandler/
│   │   │   │   ├── FileHandler.ts
│   │   │   │   └── index.ts
│   │   │   ├── FontSize/
│   │   │   │   └── FontSize.ts
│   │   │   ├── Heading/
│   │   │   │   └── Heading.ts
│   │   │   ├── HorizontalRule/
│   │   │   │   └── HorizontalRule.ts
│   │   │   ├── Image/
│   │   │   │   └── Image.ts
│   │   │   ├── ImageBlock/
│   │   │   │   ├── ImageBlock.ts
│   │   │   │   └── components/
│   │   │   │       ├── ImageBlockMenu.tsx
│   │   │   │       ├── ImageBlockView.tsx
│   │   │   │       └── ImageBlockWidth.tsx
│   │   │   ├── ImageUpload/
│   │   │   │   ├── ImageUpload.ts
│   │   │   │   └── view/
│   │   │   │       ├── hooks.ts
│   │   │   │       ├── ImageUpload.tsx
│   │   │   │       ├── ImageUploader.tsx
│   │   │   │       └── index.tsx
│   │   │   ├── Link/
│   │   │   │   └── Link.ts
│   │   │   ├── MultiColumn/
│   │   │   │   ├── Column.ts
│   │   │   │   ├── Columns.ts
│   │   │   │   └── menus/
│   │   │   │       └── ColumnsMenu.tsx
│   │   │   ├── Selection/
│   │   │   │   └── Selection.ts
│   │   │   ├── SlashCommand/
│   │   │   │   ├── CommandButton.tsx
│   │   │   │   ├── groups.ts
│   │   │   │   ├── MenuList.tsx
│   │   │   │   ├── SlashCommand.ts
│   │   │   │   └── types.ts
│   │   │   ├── Table/
│   │   │   │   ├── Cell.ts
│   │   │   │   ├── Header.ts
│   │   │   │   ├── Row.ts
│   │   │   │   ├── Table.ts
│   │   │   │   ├── utils.ts
│   │   │   │   └── menus/
│   │   │   │       ├── TableColumn/
│   │   │   │       │   └── utils.ts
│   │   │   │       └── TableRow/
│   │   │   │           └── utils.ts
│   │   │   ├── TableOfContents/
│   │   │   │   └── index.ts
│   │   │   ├── TableOfContentsNode/
│   │   │   │   └── TableOfContentsNode.tsx
│   │   │   ├── TrailingNode/
│   │   │   │   └── trailing-node.ts
│   │   │   ├── TwitterEmbed/
│   │   │   │   └── TwitterEmbed.tsx
│   │   │   ├── extension-kit.ts
│   │   │   └── index.ts
│   │   │
│   │   ├── context/
│   │   │   └── EditorContext.tsx
│   │   │
│   │   ├── hooks/
│   │   │   ├── api/
│   │   │   │   ├── useAddCategories.ts
│   │   │   │   ├── useGetAuthors.ts
│   │   │   │   ├── useGetCategories.ts
│   │   │   │   ├── useGetRevisions.ts
│   │   │   │   ├── usePublishPost.ts
│   │   │   │   ├── useShareLastRevision.ts
│   │   │   │   ├── useUnscheduleEmail.ts
│   │   │   │   ├── useUpdateEmail.ts
│   │   │   │   ├── useUpdatePost.ts
│   │   │   │   └── useUpdateRevision.ts
│   │   │   ├── useBlockEditor.ts
│   │   │   ├── useEmailBlockEditor.ts
│   │   │   └── useSidebar.tsx
│   │   │
│   │   ├── lib/
│   │   │   ├── api.ts
│   │   │   ├── authors.ts
│   │   │   ├── categories.ts
│   │   │   ├── constants.tsx
│   │   │   ├── data/
│   │   │   │   └── initialContent.tsx
│   │   │   ├── request.ts
│   │   │   ├── resources.ts
│   │   │   └── utils/
│   │   │       ├── cssVar.ts
│   │   │       ├── dates.ts
│   │   │       ├── getConnectionText.ts
│   │   │       ├── getRenderContainer.ts
│   │   │       ├── index.ts
│   │   │       ├── isCustomNodeSelected.ts
│   │   │       └── isTextSelected.ts
│   │   │
│   │   ├── types.ts
│   │   ├── App.tsx
│   │   └── main.tsx
│   │
│   ├── vite-env.d.ts
│   └── vite.config.ts
│
├── .prettierrc.json
├── components.json
├── package.json
├── package-lock.json
├── tsconfig.json
└── tsconfig.node.json
```

---

## Configuration Files

### Root Configuration

- **`Gemfile`** - Ruby dependencies
- **`package.json`** - JavaScript dependencies
- **`.env.example`** - Environment variables template
- **`Dockerfile`** - Docker image definition
- **`docker-compose.yaml`** - Production Docker Compose
- **`docker-compose.dev.yaml`** - Development Docker Compose
- **`Procfile.dev`** - Development process configuration
- **`Procfile.test`** - Test process configuration

### Rails Configuration

- **`config/application.rb`** - Main application configuration
- **`config/routes.rb`** - Route definitions
- **`config/database.yml`** - Database configuration
- **`config/storage.yml`** - Storage configuration
- **`config/environments/`** - Environment-specific configs

---

## Database Structure

### Key Tables

- **`users`** - System users
- **`sessions`** - User sessions
- **`workspaces`** - Multi-tenant workspaces
- **`pages`** - Blog/workspace instances
- **`posts`** - Blog posts
- **`post_revisions`** - Post version history
- **`authors`** - Content authors
- **`categories`** - Post categories
- **`newsletters`** - Newsletter instances
- **`newsletter_emails`** - Newsletter email content
- **`subscribers`** - Newsletter subscribers
- **`members`** - Workspace members
- **`links`** - Navigation links
- **`active_storage_*`** - File attachments

See `db/schema.rb` for complete database schema.

---

## Asset Organization

### CSS Files

- **`submodules/core/app/assets/stylesheets/core/application.tailwind.css`** - Main application styles
- **`submodules/core/app/assets/stylesheets/core/editor/editor.tailwind.css`** - Editor styles
- **`submodules/core/app/assets/stylesheets/core/public/basic.tailwind.css`** - Public-facing styles

### Compiled Assets

- **`app/assets/builds/application.css`** - Compiled main CSS
- **`app/assets/builds/editor/editor.css`** - Compiled editor CSS
- **`app/assets/builds/public/basic.css`** - Compiled public CSS

---

**Related Documentation:**
- [INDEX.md](./INDEX.md) - Main documentation index
- [ARCHITECTURE.md](./ARCHITECTURE.md) - System architecture
- [DEVELOPMENT.md](./DEVELOPMENT.md) - Development guide

