# Skill Swap Marketplace

A time-banking mobile application where users exchange skills using time credits as currency. Trade what you know for what you want to learn.

**1 hour taught = 1 credit earned** — regardless of skill type.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Firebase Setup](#firebase-setup)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

Skill Swap Marketplace is a peer-to-peer skill exchange platform that eliminates the need for monetary transactions. Users create profiles listing skills they can teach and skills they want to learn, then connect with others for mutually beneficial exchanges.

**Core Concept:**
- No money exchanged
- Users barter skills directly or use time credits as intermediate currency
- New users receive 1 credit welcome bonus to get started
- Sessions range from 30 minutes (0.5 credits) to 2 hours (2 credits)

---

## Features

### User Management
- Email and Google Sign-In authentication
- Profile setup wizard with skills configuration
- Availability and timezone settings
- Email verification for trust

### Skill Discovery
- Browse users by skill category
- Search by skill keywords
- Smart matching algorithm (up to 100% match score)
- "Perfect Match" badges for bidirectional matches
- Filters by level, availability, and rating

### Swap System
- Send/receive swap requests
- Accept, decline, or counter offers
- View pending, active, and completed swaps
- Automatic credit transfers on completion

### Real-time Chat
- Text messaging
- Image sharing
- Session scheduling within chat
- Read receipts
- System notifications

### Session Management
- Schedule sessions with date/time picker
- External video link integration (Meet/Zoom)
- Session timer with start/end tracking
- Local notification reminders (24h, 1h, 15min)

### Rating & Reviews
- 5-star rating system
- Quick tags (Great Teacher, Patient, Punctual, etc.)
- Written reviews
- Rating distribution display
- Reviews visible after both parties submit

### Credit Wallet
- Real-time balance tracking
- Transaction history
- Earn/spend tracking per swap

### Trust & Safety
- Report system for inappropriate behavior
- Block user functionality
- Anti-abuse measures (rate limits, cooldowns)

---

## Screenshots

> Screenshots will be added after UI implementation

| Onboarding | Home | Profile | Chat |
|------------|------|---------|------|
| ![Onboarding](docs/screenshots/onboarding.png) | ![Home](docs/screenshots/home.png) | ![Profile](docs/screenshots/profile.png) | ![Chat](docs/screenshots/chat.png) |

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.27 |
| Architecture | Clean Architecture (without use-cases) |
| State Management | Riverpod 2.x with code generation |
| HTTP Client | Dio with interceptors |
| Backend | Firebase (Spark Plan - Free) |
| Database | Cloud Firestore |
| Authentication | Firebase Auth (Email + Google) |
| Storage | Firebase Storage |
| Navigation | go_router with go_router_builder |
| Error Handling | fpdart (Either<Failure, T>) |
| Models | Freezed for immutable models |
| Local Notifications | flutter_local_notifications |

### Key Dependencies

```yaml
dependencies:
  # Firebase
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.4
  cloud_firestore: ^5.5.1
  firebase_storage: ^12.3.7
  google_sign_in: ^6.2.2

  # State Management
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1

  # Networking & Error Handling
  dio: ^5.4.1
  fpdart: ^1.1.0

  # Navigation
  go_router: ^14.6.2

  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
```

---

## Architecture

This project follows **Clean Architecture** with feature-based modules (excluding use-cases for simplicity):

```
Feature/
├── data/
│   ├── datasources/        # Firebase services & API calls
│   └── repositories/       # Repository implementations
├── domain/
│   ├── models/             # Freezed entity models
│   └── repositories/       # Abstract repository interfaces
└── presentation/
    ├── providers/          # Riverpod providers (@riverpod)
    ├── screens/            # UI screens (ConsumerWidget)
    └── widgets/            # Feature-specific widgets
```

### Centralized Firestore Paths

Collection names are centralized in `core/constants/firestore_paths.dart`:

```dart
class FirestorePaths {
  FirestorePaths._();

  // Collections
  static const String users = 'users';
  static const String swaps = 'swaps';
  static const String chats = 'chats';
  static const String categories = 'categories';
  static const String transactions = 'transactions';
  static const String reports = 'reports';

  // Subcollections
  static String messages(String chatId) => 'chats/$chatId/messages';
  static String userTransactions(String userId) => 'transactions/$userId/history';
}
```

### Error Handling Pattern

```dart
typedef FutureEither<T> = Future<Either<Failure, T>>;

// Usage in repository
FutureEither<UserModel?> getUserById(String userId) async {
  return apiHandler(() async {
    final doc = await _firestore
        .collection(FirestorePaths.users)
        .doc(userId)
        .get();
    return doc.exists ? UserModel.fromJson(doc.data()!) : null;
  });
}
```

---

## Getting Started

### Prerequisites

- Flutter SDK 3.27.0 or higher
- Dart SDK 3.6.0 or higher
- Firebase account
- Android Studio / VS Code
- iOS: Xcode 15+ (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/skill_swap_marketplace.git
   cd skill_swap_marketplace
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (Freezed, Riverpod, JSON serialization)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Setup

1. **Create a Firebase project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project (or use existing)
   - Enable **Authentication** (Email/Password + Google Sign-In)
   - Enable **Cloud Firestore**
   - Enable **Firebase Storage**

2. **Configure Firebase for Flutter**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli

   # Configure Firebase
   flutterfire configure --project=your-project-id
   ```

3. **Deploy Firestore Security Rules**
   ```bash
   # Copy rules from docs/projectConcept/projectConcept.md
   # Deploy via Firebase Console or CLI
   firebase deploy --only firestore:rules
   ```

4. **Initialize Firestore Collections**
   - Seed `categories` collection with predefined skill categories
   - See `docs/projectConcept/projectConcept.md` for data structure

### Environment Configuration

Create a `.env` file in the project root (if using environment variables):

```env
# Optional: Add any additional configuration
GOOGLE_WEB_CLIENT_ID=your-web-client-id
```

---

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Root MaterialApp with ProviderScope
│
├── core/                        # Shared infrastructure
│   ├── config/                  # Router, theme, Firebase options
│   ├── constants/               # Colors, dimensions, paths
│   ├── network/                 # Dio client, API handler
│   ├── shared/                  # Common models, helpers, widgets
│   └── utils/                   # Extensions, typedefs
│
└── features/                    # Feature modules
    ├── auth/                    # Authentication
    ├── profile_setup/           # Profile setup wizard
    ├── home/                    # Home & discovery
    ├── swaps/                   # Swap management
    ├── chat/                    # Real-time chat
    ├── wallet/                  # Credits & transactions
    ├── profile/                 # User profile & settings
    └── notifications/           # Notifications
```

---

## Documentation

Detailed documentation is available in the `docs/` folder:

| Document | Description |
|----------|-------------|
| [Project Concept](docs/projectConcept/projectConcept.md) | Full project plan, data models, user flows |
| [Design System](docs/screenDesigns/00_design_system.md) | Colors, typography, components, spacing |
| [Screen Designs](docs/screenDesigns/) | UI/UX specifications for all 25 screens |

### Screen Design Folders

```
docs/screenDesigns/
├── auth/           # Splash, Onboarding, Login, Signup
├── setup/          # Profile setup wizard (4 steps)
├── home/           # Home, Search, Category
├── matches/        # Matches, Swap Request, Schedule, Session, Rating
├── chat/           # Chat List, Chat Detail
├── wallet/         # Wallet
├── profile/        # Profile, Edit, View, Settings
└── utility/        # Notifications, Report
```

---

## Scripts

```bash
# Generate code (Freezed, Riverpod, JSON)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .
```

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` before committing
- Write meaningful commit messages
- Add tests for new features

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- [Flutter](https://flutter.dev/) - UI framework
- [Firebase](https://firebase.google.com/) - Backend services
- [Riverpod](https://riverpod.dev/) - State management
- [Freezed](https://pub.dev/packages/freezed) - Immutable models

---

**Made with Flutter**