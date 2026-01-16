# Skill Swap Marketplace - Final Project Plan

## Project Decisions

| Decision | Choice | Implication |
|----------|--------|-------------|
| Firebase Plan | **Spark (Free)** | No Cloud Functions - all logic client-side |
| Video Calls | **External links** | Users share Meet/Zoom links in chat |
| Session Mode | **Online only** | No location features needed |
| Skills | **Predefined + Custom** | Base categories with user suggestions |
| Paid Services | **None** | 100% free stack |
| Image Storage | **Skip for MVP** | Use Google photo, URL input, or default avatars |

---

## Constraints & Workarounds (No Cloud Functions)

Since Firebase Spark doesn't support Cloud Functions, we need client-side alternatives:

| Original Function | Client-Side Workaround |
|-------------------|------------------------|
| Credit transfer on swap complete | Firestore transaction with security rules validation |
| Match score calculation | Calculate in-app, cache in Firestore |
| Push notifications on new message | Firestore listeners + local notifications |
| Fraud detection | Client-side checks + security rules |
| Session reminders | Local scheduled notifications |
| Welcome bonus | Security rules allow one-time self-write |

**Security Consideration**: Without Cloud Functions, credit manipulation is harder to prevent. We'll use strict Firestore security rules and client-side validation, accepting this as an MVP limitation.

---

## Project Overview

**Skill Swap Marketplace** - A time-banking platform where users exchange skills using time credits as currency. 1 hour taught = 1 credit earned, regardless of skill type.

**Core Concept**: No money exchanged. Users barter skills directly or use time credits as intermediate currency.

---

## Complete User Flows

### Flow 1: Onboarding
```
App Launch
    ↓
Splash Screen (2-3s)
    ↓
Welcome Carousel (3 slides)
├── Slide 1: "Trade skills, not money"
├── Slide 2: "Teach what you know, learn what you want"
└── Slide 3: "1 hour = 1 credit, any skill"
    ↓
Auth Options
├── Sign up with Email
├── Sign in with Google
└── Already have account? Login
    ↓
Profile Setup Wizard
├── Step 1: Basic Info
│   ├── Display name
│   ├── Profile photo (optional)
│   └── Short bio (optional)
│
├── Step 2: Skills You Can Teach (min 1)
│   ├── Select category (dropdown)
│   ├── Select/type skill name
│   ├── Your level: Beginner/Intermediate/Expert
│   └── Brief description of experience
│
├── Step 3: Skills You Want to Learn (min 1)
│   ├── Select category
│   ├── Select/type skill name
│   └── Desired level
│
└── Step 4: Availability
    ├── Timezone selection
    └── General availability (Morning/Afternoon/Evening/Flexible)
    ↓
Email Verification Prompt
    ↓
Welcome Credits: +1 hour added to wallet
    ↓
Home Screen with Tutorial Tooltips
```

### Flow 2: Discovery & Matching
```
Home Screen
├── Search bar
├── "Perfect Matches" section (bidirectional)
├── "Recommended for You" section
├── Browse by Category
└── Recent Activity
    ↓
Search/Browse
├── Text search (skill keywords)
├── Category filter
├── Level filter (Beginner/Intermediate/Expert)
├── Availability filter
└── Sort: Best Match / Highest Rated / Recently Active
    ↓
Results List
├── User card shows:
│   ├── Photo, Name
│   ├── Skills they teach (matched highlighted)
│   ├── Rating (stars + count)
│   └── "Perfect Match" badge if applicable
└── Tap to view full profile
    ↓
User Profile View
├── Header: Photo, Name, Bio
├── "Skills I Teach" with levels
├── "Skills I Want"
├── Rating breakdown
├── Recent reviews
├── Availability indicator
└── Actions: "Request Swap" / "Send Message"
```

### Flow 3: Swap Request
```
Tap "Request Swap"
    ↓
Request Form
├── Skill you want from them (dropdown from their skills)
├── Skill you're offering (dropdown from your skills)
├── Proposed duration: 30min / 1hr / 1.5hr / 2hr
├── Message to introduce yourself (optional)
└── Submit Request
    ↓
Request Sent → Status: Pending
Notification sent to other user
    ↓
Other User Receives
├── Accept → Chat opens, status: Accepted
├── Decline → Optional reason, status: Declined
└── Counter → Modify skills/duration, status: Countered
```

### Flow 4: Chat & Scheduling
```
Swap Accepted → Chat Opens
    ↓
Chat Features
├── Text messages
├── Image sharing
├── "Schedule Session" button
└── Swap details banner at top
    ↓
Tap "Schedule Session"
    ↓
Scheduling Sheet
├── Select date (date picker)
├── Select time
├── Duration (pre-filled from request)
├── Add video link (Google Meet/Zoom - user pastes)
└── Confirm → Both parties notified
    ↓
Session Scheduled
├── Added to "Upcoming" in Matches tab
├── Local notification reminders set (24h, 1h, 15min)
└── Calendar export option (ics file)
```

### Flow 5: Session Execution
```
Session Time Arrives
    ↓
Both users see "Start Session" button in chat
    ↓
User taps "Start Session"
├── Timer begins for that user
├── Waiting for other user indicator
└── 15-minute grace period
    ↓
Both Started → Session In Progress
├── Timer visible
├── Video link accessible
├── "End Session" button
└── "Report Issue" option
    ↓
Session Ends (tap "End Session" or scheduled time)
    ↓
Duration Recorded
├── Actual time both were "in session"
└── → Rating Flow
```

### Flow 6: Rating & Credits
```
Session Ended
    ↓
Rating Screen (Mandatory before credits transfer)
├── Star rating (1-5) - Required
├── Quick tags: "Great Teacher" / "Patient" / "Knowledgeable" / "Punctual"
├── Written review (optional, 20-300 chars)
└── Submit
    ↓
Wait for Other Party
├── Show: "Waiting for [Name] to rate"
├── After both rate OR 48 hours pass:
└── → Credits Transfer
    ↓
Credits Transfer (Firestore Transaction)
├── Teacher: +credits (based on duration)
├── Learner: -credits
├── Transaction recorded
└── Swap status: Completed
    ↓
Reviews Become Visible
Both parties can now see each other's reviews
```

### Flow 7: Wallet & History
```
Wallet Tab
├── Current Balance: X credits
├── Transaction History
│   ├── +1.0 | Taught Guitar to @john | Date
│   ├── -0.5 | Learned Python from @sarah | Date
│   └── +1.0 | Welcome Bonus | Date
└── "Earn More" prompt → Link to complete profile
    ↓
Tap Transaction → Details
├── Swap details
├── Duration
├── Other party
└── Link to review
```

---

## Feature Specifications

### 1. Credit System

**Rules:**
- New users: +1 credit welcome bonus (one-time)
- Teaching: +credits equal to session duration
- Learning: -credits equal to session duration
- Minimum session: 0.5 credits (30 min)
- Maximum session: 2 credits (2 hours)
- Minimum balance to request: 0.5 credits
- No negative balance allowed

**Anti-Abuse (Client-Side):**
- Email verification required before first swap
- Maximum 3 pending requests at a time
- 7-day cooldown for same-user swaps
- New users limited to 2 swaps in first week

**Credit Transfer Logic (Firestore Transaction):**
```dart
// Pseudo-code for atomic credit transfer
await firestore.runTransaction((transaction) {
  // Read both user docs
  // Verify learner has enough credits
  // Verify swap is in correct state
  // Update learner balance (subtract)
  // Update teacher balance (add)
  // Update swap status to completed
  // Create transaction records
});
```

### 2. Matching Algorithm (Client-Side)

```dart
double calculateMatchScore(User currentUser, User otherUser) {
  double score = 0;

  // Perfect match: They want what I teach AND teach what I want
  bool theyWantMySkill = otherUser.skillsWanted
      .any((s) => currentUser.skillsOffered.contains(s));
  bool theyTeachWhatIWant = otherUser.skillsOffered
      .any((s) => currentUser.skillsWanted.contains(s));

  if (theyWantMySkill && theyTeachWhatIWant) {
    score += 50; // Perfect bidirectional match
  } else if (theyWantMySkill || theyTeachWhatIWant) {
    score += 25; // One-way match
  }

  // Rating factor (0-20 points)
  score += (otherUser.rating.average / 5) * 20;

  // Activity recency (0-15 points)
  int daysSinceActive = DateTime.now()
      .difference(otherUser.lastActive).inDays;
  score += max(0, 15 - daysSinceActive);

  // Completed swaps bonus (0-15 points)
  score += min(otherUser.swapsCompleted, 15);

  return score; // 0-100
}
```

### 3. Chat System

**Features:**
- Real-time messaging via Firestore listeners
- Text messages
- Image sharing (Firebase Storage, max 2MB)
- Read receipts
- Typing indicator (optional)
- Swap details pinned at top
- Schedule session widget
- Report/block user

**Message Types:**
- `text`: Regular message
- `image`: Image attachment
- `system`: "Session scheduled", "Swap completed", etc.

**Local Notifications:**
- New message while app in background
- Session reminders (local scheduled)

### 4. Rating System

**Components:**
- Overall rating: 1-5 stars (required)
- Tags: Predefined positive tags (multi-select)
- Written review: 20-300 characters (optional)

**Tags Available:**
- Great Teacher
- Patient
- Knowledgeable
- Good Communicator
- Punctual
- Well Prepared

**Display:**
- Average rating with count
- Tag frequency badges
- Recent reviews (last 5)
- Rating distribution chart

**Rules:**
- Both must rate before credits transfer
- Reviews hidden until both submit (prevents retaliation)
- 48-hour auto-complete if one party doesn't rate
- No editing after submission

### 5. Skill Categories (Predefined)

```
Technology
├── Programming (Flutter, Python, JavaScript, etc.)
├── Web Development
├── Mobile Development
├── Data Science
├── UI/UX Design
└── DevOps

Creative
├── Graphic Design
├── Video Editing
├── Photography
├── Music Production
├── Writing
└── Animation

Music
├── Guitar
├── Piano
├── Vocals
├── Drums
└── Music Theory

Languages
├── English
├── Spanish
├── French
├── German
├── Japanese
└── Others

Business
├── Marketing
├── Finance
├── Entrepreneurship
├── Public Speaking
└── Leadership

Lifestyle
├── Cooking
├── Fitness
├── Yoga
├── Meditation
└── Personal Development

Academic
├── Mathematics
├── Science
├── History
├── Test Prep
└── Research
```

**Custom Skills:**
- Users can type custom skill if not in list
- Custom skills tagged for admin review
- Popular custom skills added to predefined list

---

## Screen Inventory (25 Screens)

```
📱 Authentication (4)
├── splash_screen.dart
├── onboarding_screen.dart
├── login_screen.dart
└── signup_screen.dart

📱 Profile Setup (4)
├── setup_basic_info_screen.dart
├── setup_skills_offered_screen.dart
├── setup_skills_wanted_screen.dart
└── setup_availability_screen.dart

📱 Main App - Bottom Navigation (5 tabs)
├── home_screen.dart
│   ├── search_screen.dart
│   └── category_screen.dart
├── matches_screen.dart (with tabs: Pending/Active/Completed)
├── chat_list_screen.dart
│   └── chat_detail_screen.dart
├── wallet_screen.dart
└── profile_screen.dart
    ├── edit_profile_screen.dart
    └── settings_screen.dart

📱 Detail Screens (5)
├── user_profile_view_screen.dart
├── swap_request_screen.dart
├── schedule_session_screen.dart
├── active_session_screen.dart
└── rating_screen.dart

📱 Utility (3)
├── skill_detail_screen.dart
├── notifications_screen.dart
└── report_screen.dart
```

---

## Data Models (Firestore)

### Collection: `users`
```javascript
users/{userId} {
  // Auth & Basic
  uid: string,
  email: string,
  emailVerified: boolean,
  displayName: string,
  photoUrl: string | null,
  bio: string,

  // Skills
  skillsOffered: [
    {
      id: string,
      categoryId: string,
      categoryName: string,
      skillName: string,
      level: 'beginner' | 'intermediate' | 'expert',
      description: string
    }
  ],

  skillsWanted: [
    {
      id: string,
      categoryId: string,
      categoryName: string,
      skillName: string,
      desiredLevel: 'beginner' | 'intermediate' | 'expert'
    }
  ],

  // Availability
  timezone: string,
  availability: 'morning' | 'afternoon' | 'evening' | 'flexible',

  // Stats
  creditBalance: number,
  swapsCompleted: number,
  hoursExchanged: number,

  // Rating
  rating: {
    average: number,
    count: number,
    tags: { [tagName]: count }
  },

  // Status
  status: 'active' | 'suspended',
  createdAt: timestamp,
  updatedAt: timestamp,
  lastActiveAt: timestamp,

  // For new user limits
  firstSwapDate: timestamp | null,
  swapsThisWeek: number
}
```

### Collection: `categories`
```javascript
categories/{categoryId} {
  name: string,
  icon: string,
  order: number,
  skills: [
    { id: string, name: string }
  ]
}
```

### Collection: `swaps`
```javascript
swaps/{swapId} {
  // Participants
  requesterId: string,
  requesterName: string,
  requesterPhoto: string,

  providerId: string,
  providerName: string,
  providerPhoto: string,

  // Skills being exchanged
  requesterOffers: { skillId, skillName, categoryName },
  requesterWants: { skillId, skillName, categoryName },

  // Terms
  duration: number, // in hours (0.5, 1, 1.5, 2)
  creditAmount: number,
  message: string,

  // Status
  status: 'pending' | 'accepted' | 'declined' | 'scheduled' |
          'in_progress' | 'completed' | 'cancelled',

  // Session (when scheduled)
  session: {
    scheduledDate: timestamp,
    scheduledTime: string,
    videoLink: string,
    actualStartTime: timestamp | null,
    actualEndTime: timestamp | null,
    requesterStarted: boolean,
    providerStarted: boolean
  } | null,

  // Ratings (after completion)
  ratings: {
    [oderId]: {
      oderId: string,
      stars: number,
      tags: string[],
      review: string,
      createdAt: timestamp
    }
  },

  // Metadata
  createdAt: timestamp,
  updatedAt: timestamp,
  completedAt: timestamp | null,
  cancelledBy: string | null,
  cancelReason: string | null
}
```

### Collection: `chats`
```javascript
chats/{chatId} {
  participants: [oderId, oderId],

  participantInfo: {
    [oderId]: { name, photoUrl }
  },

  swapId: string,

  lastMessage: {
    text: string,
    senderId: string,
    type: 'text' | 'image' | 'system',
    createdAt: timestamp
  },

  unreadCount: {
    [oderId]: number
  },

  createdAt: timestamp,
  updatedAt: timestamp
}

// Subcollection
chats/{chatId}/messages/{messageId} {
  senderId: string,
  senderName: string,
  type: 'text' | 'image' | 'system',
  content: string,
  imageUrl: string | null,
  readBy: [oderId],
  createdAt: timestamp
}
```

### Collection: `transactions`
```javascript
transactions/{oderId}/history/{transactionId} {
  oderId: string,
  type: 'welcome_bonus' | 'swap_earned' | 'swap_spent',
  amount: number,
  balanceAfter: number,

  // Related swap
  swapId: string | null,
  otherUserId: string | null,
  otherUserName: string | null,
  skillName: string | null,

  createdAt: timestamp
}
```

### Collection: `reports`
```javascript
reports/{reportId} {
  reporterId: string,
  reporterName: string,

  reportedUserId: string,
  reportedUserName: string,

  swapId: string | null,
  messageId: string | null,

  reason: 'inappropriate' | 'spam' | 'no_show' | 'fraud' | 'other',
  description: string,

  status: 'pending' | 'resolved',
  createdAt: timestamp
}
```

---

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ========== HELPER FUNCTIONS ==========
    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    function isParticipant(data) {
      return request.auth.uid in data.participants ||
             request.auth.uid == data.requesterId ||
             request.auth.uid == data.providerId;
    }

    function isEmailVerified() {
      return request.auth.token.email_verified == true;
    }

    // ========== USERS ==========
    match /users/{userId} {
      // Anyone signed in can read profiles
      allow read: if isSignedIn();

      // Users can create their own profile
      allow create: if isOwner(userId) &&
        request.resource.data.creditBalance == 1 && // Welcome bonus
        request.resource.data.swapsCompleted == 0;

      // Users can update their own profile
      // But cannot directly modify: creditBalance, rating, swapsCompleted
      allow update: if isOwner(userId) &&
        request.resource.data.creditBalance == resource.data.creditBalance &&
        request.resource.data.rating == resource.data.rating &&
        request.resource.data.swapsCompleted == resource.data.swapsCompleted;
    }

    // ========== CATEGORIES (Read Only) ==========
    match /categories/{categoryId} {
      allow read: if isSignedIn();
      allow write: if false; // Admin only via console
    }

    // ========== SWAPS ==========
    match /swaps/{swapId} {
      // Participants can read
      allow read: if isSignedIn() && isParticipant(resource.data);

      // Verified users can create swap requests
      allow create: if isSignedIn() && isEmailVerified() &&
        request.resource.data.requesterId == request.auth.uid &&
        request.resource.data.status == 'pending';

      // Participants can update (status changes, ratings)
      allow update: if isSignedIn() && isParticipant(resource.data);
    }

    // ========== CHATS ==========
    match /chats/{chatId} {
      allow read: if isSignedIn() &&
        request.auth.uid in resource.data.participants;

      allow create: if isSignedIn();

      allow update: if isSignedIn() &&
        request.auth.uid in resource.data.participants;

      // Messages subcollection
      match /messages/{messageId} {
        allow read: if isSignedIn() &&
          request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participants;

        allow create: if isSignedIn() &&
          request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participants &&
          request.resource.data.senderId == request.auth.uid;
      }
    }

    // ========== TRANSACTIONS ==========
    match /transactions/{userId}/history/{transactionId} {
      // Users can only read their own transactions
      allow read: if isOwner(userId);

      // Transactions created during swap completion (via batch write)
      allow create: if isOwner(userId);
    }

    // ========== REPORTS ==========
    match /reports/{reportId} {
      // Users can create reports
      allow create: if isSignedIn() &&
        request.resource.data.reporterId == request.auth.uid;

      // Users can read their own reports
      allow read: if isSignedIn() &&
        resource.data.reporterId == request.auth.uid;
    }
  }
}
```

**Note**: Without Cloud Functions, credit transfers happen via Firestore batch writes from the client. The security rules above are simplified. In production, additional validation would be needed.

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | **Flutter 3.27** |
| Architecture | **Clean Architecture** (without use-cases) |
| State Management | **Riverpod 2.x** with code generation |
| HTTP Client | **Dio** with interceptors |
| Backend | Firebase (Spark Plan - Free) |
| Database | Cloud Firestore |
| Auth | Firebase Auth (Email + Google) |
| Storage | Firebase Storage (images) |
| Notifications | Local notifications (flutter_local_notifications) |
| Navigation | go_router with go_router_builder |
| Error Handling | **fpdart** (Either<Failure, T>) |
| Models | **Freezed** for immutable models |
| Forms | flutter_form_builder |
| Images | cached_network_image |
| Date/Time | intl |

### Architecture Overview

We follow **Clean Architecture** with feature-based modules, excluding the use-case layer for simplicity:

```
Feature/
├── data/
│   ├── datasources/        # API services (Retrofit) & local data sources
│   └── repositories/       # Repository implementations
├── domain/
│   ├── models/            # Entity models (Freezed) & request DTOs
│   └── repositories/      # Abstract repository interfaces
└── presentation/
    ├── providers/         # Riverpod providers (@riverpod)
    ├── screens/           # UI screens (ConsumerWidget)
    └── widgets/           # Feature-specific widgets
```

**Key Packages:**
```yaml
environment:
  sdk: ^3.6.0
  flutter: 3.27.0

dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.4
  cloud_firestore: ^5.5.1
  firebase_storage: ^12.3.7
  google_sign_in: ^6.2.2

  # State Management
  flutter_riverpod: ^2.6.1
  hooks_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1

  # Networking
  dio: ^5.4.1
  retrofit: ^4.1.0
  pretty_dio_logger: ^1.3.1
  connectivity_plus: ^5.0.2

  # Functional Programming & Error Handling
  fpdart: ^1.1.0

  # Navigation
  go_router: ^14.6.2
  go_router_builder: ^2.4.1

  # Code Generation (Models)
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0

  # UI
  cached_network_image: ^3.4.1
  flutter_svg: ^2.0.16
  shimmer: ^3.0.0
  smooth_page_indicator: ^1.2.0+3

  # Forms
  flutter_form_builder: ^9.5.0
  form_builder_validators: ^11.0.0

  # Utils
  intl: ^0.20.1
  uuid: ^4.5.1
  image_picker: ^1.1.2
  url_launcher: ^6.3.1
  share_plus: ^10.1.3
  timeago: ^3.7.0
  equatable: ^2.0.7

  # Local Storage
  shared_preferences: ^2.2.3
  flutter_secure_storage: ^9.2.4

  # Local Notifications
  flutter_local_notifications: ^18.0.1
  timezone: ^0.10.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.13
  riverpod_generator: ^2.6.3
  freezed: ^2.4.7
  json_serializable: ^6.9.0
  retrofit_generator: ^8.1.0
  go_router_builder: ^2.4.1
```

### Centralized Firestore Paths

All Firestore collection names are centralized in `core/constants/firestore_paths.dart`:

```dart
// core/constants/firestore_paths.dart
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

  // Document references
  static String userDoc(String userId) => 'users/$userId';
  static String swapDoc(String swapId) => 'swaps/$swapId';
  static String chatDoc(String chatId) => 'chats/$chatId';
}
```

### Error Handling Pattern

Using `fpdart` for functional error handling:

```dart
// Type alias
typedef FutureEither<T> = Future<Either<Failure, T>>;

// Failure model
class Failure {
  final String? error;
  final String? message;
  Failure({this.error, this.message});
}

// API Handler wrapper
Future<Either<Failure, T>> apiHandler<T>(Future<T> Function() apiFunc) async {
  try {
    final result = await apiFunc();
    return right(result);
  } on FirebaseException catch (e) {
    return left(Failure(error: e.code, message: e.message));
  } catch (e) {
    return left(Failure(message: e.toString()));
  }
}

// Usage in repository
FutureEither<UserModel?> getUserProfile(String userId) async {
  return apiHandler(() async {
    final doc = await _firestore
        .collection(FirestorePaths.users)
        .doc(userId)
        .get();
    return doc.exists ? UserModel.fromJson(doc.data()!) : null;
  });
}

// Usage in provider
@riverpod
Future<UserModel?> userProfile(Ref ref, String userId) async {
  final result = await ref.read(userRepoProvider).getUserProfile(userId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (user) => user,
  );
}
```

---

## Project Structure (Clean Architecture)

```
lib/
├── main.dart                              # App entry point
├── app.dart                               # Root MaterialApp with ProviderScope
│
├── core/                                  # Shared infrastructure & utilities
│   ├── config/
│   │   ├── app_router.dart               # GoRouter configuration
│   │   ├── app_theme.dart                # Theme definitions
│   │   └── firebase_options.dart         # Firebase config (generated)
│   │
│   ├── constants/
│   │   ├── app_constants.dart            # App-wide constants
│   │   ├── color_constants.dart          # Color definitions
│   │   ├── dimensions.dart               # Spacing & sizing
│   │   └── firestore_paths.dart          # Collection names
│   │
│   ├── network/
│   │   ├── api_client.dart               # Dio configuration & providers
│   │   ├── api_handler.dart              # FutureEither wrapper
│   │   └── error_handler.dart            # Error to Failure conversion
│   │
│   ├── shared/
│   │   ├── models/
│   │   │   ├── failure.dart              # Error model
│   │   │   └── api_response.dart         # Generic response wrapper
│   │   ├── helpers/
│   │   │   ├── local_storage.dart        # SharedPrefs & SecureStorage
│   │   │   ├── date_helper.dart          # Date utilities
│   │   │   └── validators.dart           # Form validators
│   │   └── widgets/
│   │       ├── loader.dart               # Loading overlay
│   │       ├── toast.dart                # Toast notifications
│   │       ├── common_error_widget.dart  # Error display
│   │       ├── empty_state_widget.dart   # Empty state display
│   │       ├── custom_button.dart        # Styled buttons
│   │       ├── user_avatar.dart          # Avatar component
│   │       └── skill_chip.dart           # Skill badge component
│   │
│   └── utils/
│       ├── typedefs.dart                 # FutureEither typedef
│       ├── extensions.dart               # Dart extensions
│       └── match_calculator.dart         # Match score algorithm
│
├── features/                             # Feature modules (Clean Architecture)
│   │
│   ├── auth/                             # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_firebase_service.dart
│   │   │   └── repositories/
│   │   │       └── auth_repo_impl.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart       # Freezed model
│   │   │   │   ├── user_model.freezed.dart
│   │   │   │   └── user_model.g.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart  # Abstract interface
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── auth_providers.dart   # @riverpod providers
│   │       │   └── auth_providers.g.dart
│   │       ├── screens/
│   │       │   ├── splash_screen.dart
│   │       │   ├── onboarding_screen.dart
│   │       │   ├── login_screen.dart
│   │       │   └── signup_screen.dart
│   │       └── widgets/
│   │           └── auth_form_widgets.dart
│   │
│   ├── profile_setup/                    # Profile setup wizard feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── skill_model.dart
│   │   │   │   └── category_model.dart
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       │   ├── setup_basic_info_screen.dart
│   │       │   ├── setup_skills_offered_screen.dart
│   │       │   ├── setup_skills_wanted_screen.dart
│   │       │   └── setup_availability_screen.dart
│   │       └── widgets/
│   │
│   ├── home/                             # Home & discovery feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── home_firebase_service.dart
│   │   │   └── repositories/
│   │   │       └── home_repo_impl.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   │       └── home_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── home_providers.dart
│   │       ├── screens/
│   │       │   ├── home_screen.dart
│   │       │   ├── search_screen.dart
│   │       │   └── category_screen.dart
│   │       └── widgets/
│   │           ├── user_card.dart
│   │           └── category_tile.dart
│   │
│   ├── swaps/                            # Swap management feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── swap_firebase_service.dart
│   │   │   └── repositories/
│   │   │       └── swap_repo_impl.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── swap_model.dart
│   │   │   │   ├── session_model.dart
│   │   │   │   └── rating_model.dart
│   │   │   └── repositories/
│   │   │       └── swap_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── swap_providers.dart
│   │       ├── screens/
│   │       │   ├── matches_screen.dart
│   │       │   ├── swap_request_screen.dart
│   │       │   ├── schedule_session_screen.dart
│   │       │   ├── active_session_screen.dart
│   │       │   └── rating_screen.dart
│   │       └── widgets/
│   │           ├── swap_card.dart
│   │           └── swap_status_badge.dart
│   │
│   ├── chat/                             # Chat feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── chat_firebase_service.dart
│   │   │   └── repositories/
│   │   │       └── chat_repo_impl.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── chat_model.dart
│   │   │   │   └── message_model.dart
│   │   │   └── repositories/
│   │   │       └── chat_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── chat_providers.dart
│   │       ├── screens/
│   │       │   ├── chat_list_screen.dart
│   │       │   └── chat_detail_screen.dart
│   │       └── widgets/
│   │           ├── message_bubble.dart
│   │           └── chat_input.dart
│   │
│   ├── wallet/                           # Wallet & transactions feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── transaction_model.dart
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       │   └── wallet_screen.dart
│   │       └── widgets/
│   │
│   ├── profile/                          # Profile & settings feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       │   ├── profile_screen.dart
│   │       │   ├── edit_profile_screen.dart
│   │       │   ├── user_profile_view_screen.dart
│   │       │   └── settings_screen.dart
│   │       └── widgets/
│   │
│   └── notifications/                    # Notifications feature
│       ├── data/
│       ├── domain/
│       └── presentation/
│           ├── providers/
│           ├── screens/
│           │   └── notifications_screen.dart
│           └── widgets/
│
└── gen/                                  # Generated files (flutter_gen)
    ├── colors.gen.dart
    └── fonts.gen.dart
```

### Feature Module Structure

Each feature follows Clean Architecture with 3 layers:

```
feature_name/
├── data/                           # DATA LAYER
│   ├── datasources/
│   │   └── {feature}_firebase_service.dart   # Firebase operations
│   └── repositories/
│       └── {feature}_repo_impl.dart          # Implements domain interface
│
├── domain/                         # DOMAIN LAYER
│   ├── models/
│   │   ├── {model}.dart                      # @freezed model
│   │   ├── {model}.freezed.dart              # Generated
│   │   └── {model}.g.dart                    # Generated JSON
│   └── repositories/
│       └── {feature}_repository.dart         # Abstract interface
│
└── presentation/                   # PRESENTATION LAYER
    ├── providers/
    │   ├── {feature}_providers.dart          # @riverpod providers
    │   └── {feature}_providers.g.dart        # Generated
    ├── screens/
    │   └── {feature}_screen.dart             # ConsumerWidget screens
    └── widgets/
        └── {feature}_widgets.dart            # Feature-specific widgets
```

### Example: User Model with Freezed

```dart
// domain/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    @Default(false) bool emailVerified,
    required String displayName,
    String? photoUrl,
    @Default('') String bio,
    @Default([]) List<SkillOffered> skillsOffered,
    @Default([]) List<SkillWanted> skillsWanted,
    String? timezone,
    String? availability,
    @Default(1.0) double creditBalance,
    @Default(0) int swapsCompleted,
    @Default(0.0) double hoursExchanged,
    UserRating? rating,
    @Default('active') String status,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? lastActiveAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

DateTime? _timestampFromJson(dynamic value) {
  if (value is Timestamp) return value.toDate();
  return null;
}

dynamic _timestampToJson(DateTime? date) {
  if (date != null) return Timestamp.fromDate(date);
  return null;
}
```

### Example: Repository Pattern

```dart
// domain/repositories/user_repository.dart (Abstract)
abstract class UserRepository {
  FutureEither<UserModel?> getUserById(String userId);
  FutureEither<List<UserModel>> getRecommendedUsers(String currentUserId);
  FutureEither<void> updateUser(String userId, Map<String, dynamic> data);
  Stream<UserModel?> watchUser(String userId);
}

// data/repositories/user_repo_impl.dart (Implementation)
final userRepoProvider = Provider<UserRepository>((ref) {
  return UserRepoImpl(ref.read(firestoreProvider));
});

class UserRepoImpl implements UserRepository {
  final FirebaseFirestore _firestore;
  UserRepoImpl(this._firestore);

  @override
  FutureEither<UserModel?> getUserById(String userId) async {
    return apiHandler(() async {
      final doc = await _firestore
          .collection(FirestorePaths.users)
          .doc(userId)
          .get();
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    });
  }

  @override
  Stream<UserModel?> watchUser(String userId) {
    return _firestore
        .collection(FirestorePaths.users)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromJson(doc.data()!) : null);
  }
}
```

### Example: Riverpod Provider with Code Generation

```dart
// presentation/providers/home_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart';

@riverpod
Future<List<UserModel>> recommendedUsers(Ref ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final result = await ref.read(userRepoProvider)
      .getRecommendedUsers(currentUser.uid);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (users) => users,
  );
}

@riverpod
Stream<UserModel?> currentUserStream(Ref ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (user) => user != null
        ? ref.read(userRepoProvider).watchUser(user.uid)
        : Stream.value(null),
    orElse: () => Stream.value(null),
  );
}

// State providers for UI state
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String? build() => null;

  void select(String? categoryId) => state = categoryId;
}
```

---

## Implementation Phases

### Phase 1: Foundation (MVP Core)
**Goal**: Basic swap loop working

1. Project setup & Firebase configuration
2. Authentication (Email + Google Sign-In)
3. User model & Firestore integration
4. Profile setup wizard
5. Home screen with basic user list
6. User profile view
7. Basic swap request flow
8. Simple chat
9. Rating system
10. Credit transfer

**Deliverable**: Users can sign up, find others, request swap, chat, complete session, rate, and transfer credits.

### Phase 2: Discovery & UX
**Goal**: Findability and polish

1. Search functionality
2. Category browsing
3. Match algorithm implementation
4. Filters and sorting
5. "Perfect Match" badges
6. Improved onboarding
7. Empty states & loading states
8. Error handling

**Deliverable**: Users can easily discover relevant skill partners.

### Phase 3: Session Management
**Goal**: Structured session flow

1. Session scheduling
2. Calendar view
3. Session reminders (local notifications)
4. Active session screen with timer
5. Session start/end flow
6. Video link integration

**Deliverable**: Complete session lifecycle management.

### Phase 4: Trust & Safety
**Goal**: Platform integrity

1. Email verification enforcement
2. Report system
3. Block functionality
4. Anti-abuse measures (rate limits)
5. Review moderation basics

**Deliverable**: Basic trust mechanisms in place.

### Phase 5: Polish & Launch
**Goal**: Production ready

1. Performance optimization
2. Offline handling
3. Deep linking
4. App store assets
5. Testing & bug fixes

**Deliverable**: App ready for store submission.

---

## Verification & Testing

### Manual Testing Checklist

**Auth Flow:**
- [ ] Sign up with email
- [ ] Sign up with Google
- [ ] Email verification flow
- [ ] Login with email
- [ ] Login with Google
- [ ] Logout
- [ ] Password reset

**Profile Setup:**
- [ ] Complete all setup steps
- [ ] Add multiple skills offered
- [ ] Add multiple skills wanted
- [ ] Set availability
- [ ] Edit profile after setup

**Discovery:**
- [ ] Browse all users
- [ ] Search by skill name
- [ ] Filter by category
- [ ] View user profile
- [ ] See match percentage

**Swap Flow:**
- [ ] Send swap request
- [ ] Receive notification
- [ ] Accept request
- [ ] Decline request
- [ ] View pending/active/completed swaps

**Chat:**
- [ ] Send text message
- [ ] Send image
- [ ] See read receipts
- [ ] Schedule session from chat

**Session:**
- [ ] Start session (both users)
- [ ] See timer
- [ ] End session
- [ ] Handle no-show scenario

**Rating:**
- [ ] Rate after session
- [ ] See rating after both rate
- [ ] Credits transferred correctly

**Wallet:**
- [ ] See credit balance
- [ ] See transaction history
- [ ] Welcome bonus applied

---

## Notes

- This is an MVP implementation using Firebase Spark (free tier)
- No Cloud Functions means some security trade-offs are accepted
- Video calls handled via external links (Meet/Zoom)
- All sessions are online-only
- Local notifications used instead of push notifications
