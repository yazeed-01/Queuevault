# QueueVault

A Flutter app for tracking everything you want to watch, play, or buy — movies, series, anime, games, and products — all in one personal vault.

## Features

- **Multi-category vault** — Movies, Series, Anime, Games, and Products, each with category-specific fields (episodes, seasons, playtime, price, etc.)
- **Status tracking** — Want / In Progress / Completed / Dropped
- **Rich metadata search** — powered by TMDB (movies & TV), AniList (anime), RAWG (games), and UPC Item DB (products)
- **Share-intent support** — share a URL from any app and QueueVault opens the Add screen pre-filled
- **Reminders** — schedule local notifications for any item
- **Google Drive sync** — backup and restore your vault via Google Drive's app-data folder; optional auto-sync on app close
- **Custom categories** — create, reorder, and recolor categories beyond the five defaults
- **Discover screen** — browse and explore content without leaving the app
- **Recommendations** — AI-powered suggestions based on your vault
- **Multiple vault layouts** — Hero Feed, Deck Spotlight, and Swimlanes views
- **Dark theme** — dark-only UI with glassmorphism and glow card components

## Tech Stack

| Layer | Library |
|---|---|
| Framework | Flutter 3 / Dart 3 |
| State management | Riverpod 2 + `riverpod_generator` |
| Local database | Drift (SQLite) |
| Routing | go_router |
| Networking | Dio |
| Notifications | flutter_local_notifications |
| Google auth & Drive | google_sign_in + googleapis |
| Animations | flutter_animate, Lottie, Shimmer |
| Code generation | build_runner, freezed, json_serializable |

## External APIs

| API | Used for | Key source |
|---|---|---|
| TMDB | Movies & TV search | `.env` → `TMDB_TOKEN` or Settings |
| AniList (GraphQL) | Anime search | No key required |
| RAWG | Game search | `.env` → `RAWG_KEY` or Settings |
| UPC Item DB | Product search | No key required |

## Project Structure

```
lib/
├── core/
│   ├── constants/       # Colors, text styles, env, API URLs
│   ├── database/        # Drift schema (VaultItems, Categories)
│   ├── network/         # Dio client, SearchResult model
│   ├── notifications/   # Local notification service
│   ├── router/          # go_router config + MainShell nav bar
│   ├── theme/           # AppTheme (dark)
│   ├── utils/           # CategoryIcons, UrlParser
│   └── widgets/         # GlassCard, GlowCard, CategoryBadge
└── features/
    ├── add_item/        # Search screen + manual item form
    ├── categories/      # Category manager
    ├── discover/        # Discover / browse screen
    ├── item_detail/     # Detail screen + reminder bottom sheet
    ├── recommendations/ # Recommendations repository + screen
    ├── settings/        # Settings screen
    ├── sync/            # Google Drive sync section
    └── vault/           # Vault screen, layouts, providers, repository
```

## Getting Started

### Prerequisites

- Flutter SDK `^3.12.0`
- Android / iOS device or emulator

### Setup

1. Clone the repo and install dependencies:

   ```bash
   flutter pub get
   ```

2. Copy the environment template and fill in your API keys:

   ```bash
   cp .env.example .env
   ```

   ```
   TMDB_TOKEN=your_tmdb_read_access_token
   RAWG_KEY=your_rawg_api_key
   ```

3. Run code generation (Drift, Riverpod, Freezed):

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Add `google-services.json` (Android) to `android/app/` for Google Sign-In.

5. Run the app:

   ```bash
   flutter run
   ```

### API keys without rebuilding

TMDB and RAWG keys can also be entered at runtime in **Settings** — no rebuild needed.

## Database Schema

Two Drift tables:

- **VaultItems** — all content items; type-specific fields are nullable (e.g., `totalSeasons` only applies to series)
- **Categories** — user-configurable categories seeded with five defaults on first launch; schema version 2

## Google Drive Sync

Vault data is exported as JSON and stored in Drive's hidden `appDataFolder` as `vault_data.json`. The app never reads or writes to the user's regular Drive files. Auto-sync triggers when the app is paused (goes to background).
