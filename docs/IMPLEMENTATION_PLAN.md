# Skill Swap Marketplace - Implementation Plan

## Current Status
- [x] Project setup & Firebase configuration
- [x] Clean Architecture folder structure
- [x] Type-safe routing with go_router_builder
- [x] Core constants (routes, Firestore paths, theme)
- [x] Android & iOS build configuration

---

## Phase 1: Foundation (MVP Core)
**Goal**: Complete the basic swap loop - users can sign up, find others, request swap, chat, complete session, rate, and transfer credits.

### Step 1.1: Data Models (Freezed)
Create all Freezed models with JSON serialization.

| Task | Files | Priority |
|------|-------|----------|
| User model | `lib/features/auth/domain/models/user_model.dart` | High |
| Skill model | `lib/features/skills/domain/models/skill_model.dart` | High |
| Category model | `lib/features/skills/domain/models/category_model.dart` | High |
| Swap model | `lib/features/swap/domain/models/swap_model.dart` | High |
| Chat model | `lib/features/chat/domain/models/chat_model.dart` | Medium |
| Message model | `lib/features/chat/domain/models/message_model.dart` | Medium |
| Transaction model | `lib/features/wallet/domain/models/transaction_model.dart` | Medium |
| Rating model | `lib/features/rating/domain/models/rating_model.dart` | Medium |

### Step 1.2: Authentication Feature
Complete auth flow with Firebase.

| Task | Files | Priority |
|------|-------|----------|
| Auth repository interface | `lib/features/auth/domain/repositories/auth_repository.dart` | High |
| Auth repository impl | `lib/features/auth/data/repositories/auth_repository_impl.dart` | High |
| Auth providers (Riverpod) | `lib/features/auth/presentation/providers/auth_provider.dart` | High |
| Splash screen | `lib/features/auth/presentation/screens/splash_screen.dart` | High |
| Onboarding screen (3 slides) | `lib/features/auth/presentation/screens/onboarding_screen.dart` | High |
| Login screen | `lib/features/auth/presentation/screens/login_screen.dart` | High |
| Signup screen | `lib/features/auth/presentation/screens/signup_screen.dart` | High |
| Google Sign-In integration | (within auth repository) | High |
| Auth state listener | `lib/features/auth/presentation/providers/auth_state_provider.dart` | High |

### Step 1.3: Profile Setup Feature
User onboarding wizard (4 steps).

| Task | Files | Priority |
|------|-------|----------|
| User repository interface | `lib/features/user/domain/repositories/user_repository.dart` | High |
| User repository impl | `lib/features/user/data/repositories/user_repository_impl.dart` | High |
| Setup Basic Info screen | `lib/features/setup/presentation/screens/setup_basic_info_screen.dart` | High |
| Setup Skills Offered screen | `lib/features/setup/presentation/screens/setup_skills_offered_screen.dart` | High |
| Setup Skills Wanted screen | `lib/features/setup/presentation/screens/setup_skills_wanted_screen.dart` | High |
| Setup Availability screen | `lib/features/setup/presentation/screens/setup_availability_screen.dart` | High |
| Setup progress provider | `lib/features/setup/presentation/providers/setup_provider.dart` | High |
| Skill selector widget | `lib/features/setup/presentation/widgets/skill_selector_widget.dart` | High |

### Step 1.4: Home & Discovery Feature
Main app shell with bottom navigation.

| Task | Files | Priority |
|------|-------|----------|
| Main shell with BottomNav | `lib/features/main/presentation/screens/main_shell_screen.dart` | High |
| Home screen | `lib/features/home/presentation/screens/home_screen.dart` | High |
| User card widget | `lib/core/shared/widgets/user_card.dart` | High |
| User avatar widget | `lib/core/shared/widgets/user_avatar.dart` | High |
| Skill chip widget | `lib/core/shared/widgets/skill_chip.dart` | High |
| Users list provider | `lib/features/home/presentation/providers/users_provider.dart` | High |
| User profile view screen | `lib/features/user/presentation/screens/user_profile_view_screen.dart` | High |

### Step 1.5: Swap Request Feature
Request and manage skill swaps.

| Task | Files | Priority |
|------|-------|----------|
| Swap repository interface | `lib/features/swap/domain/repositories/swap_repository.dart` | High |
| Swap repository impl | `lib/features/swap/data/repositories/swap_repository_impl.dart` | High |
| Swap request screen | `lib/features/swap/presentation/screens/swap_request_screen.dart` | High |
| Matches screen (tabs) | `lib/features/swap/presentation/screens/matches_screen.dart` | High |
| Swap card widget | `lib/features/swap/presentation/widgets/swap_card.dart` | High |
| Swap status badge widget | `lib/features/swap/presentation/widgets/swap_status_badge.dart` | High |
| Swaps provider | `lib/features/swap/presentation/providers/swaps_provider.dart` | High |

### Step 1.6: Chat Feature
Real-time messaging.

| Task | Files | Priority |
|------|-------|----------|
| Chat repository interface | `lib/features/chat/domain/repositories/chat_repository.dart` | High |
| Chat repository impl | `lib/features/chat/data/repositories/chat_repository_impl.dart` | High |
| Chat list screen | `lib/features/chat/presentation/screens/chat_list_screen.dart` | High |
| Chat detail screen | `lib/features/chat/presentation/screens/chat_detail_screen.dart` | High |
| Message bubble widget | `lib/features/chat/presentation/widgets/message_bubble.dart` | High |
| Chat input widget | `lib/features/chat/presentation/widgets/chat_input.dart` | High |
| Chats provider | `lib/features/chat/presentation/providers/chats_provider.dart` | High |
| Messages stream provider | `lib/features/chat/presentation/providers/messages_provider.dart` | High |

### Step 1.7: Rating & Credits Feature
Post-session rating and credit transfer.

| Task | Files | Priority |
|------|-------|----------|
| Rating screen | `lib/features/rating/presentation/screens/rating_screen.dart` | High |
| Rating tags widget | `lib/features/rating/presentation/widgets/rating_tags.dart` | High |
| Star rating widget | `lib/features/rating/presentation/widgets/star_rating.dart` | High |
| Credit transfer service | `lib/features/wallet/data/services/credit_service.dart` | High |
| Wallet screen | `lib/features/wallet/presentation/screens/wallet_screen.dart` | High |
| Transaction list widget | `lib/features/wallet/presentation/widgets/transaction_list.dart` | High |
| Wallet provider | `lib/features/wallet/presentation/providers/wallet_provider.dart` | High |

### Step 1.8: Profile Feature
User's own profile management.

| Task | Files | Priority |
|------|-------|----------|
| Profile screen | `lib/features/profile/presentation/screens/profile_screen.dart` | Medium |
| Edit profile screen | `lib/features/profile/presentation/screens/edit_profile_screen.dart` | Medium |
| Settings screen | `lib/features/profile/presentation/screens/settings_screen.dart` | Medium |

---

## Phase 2: Discovery & UX
**Goal**: Enhanced findability and polished user experience.

### Step 2.1: Search & Filters
| Task | Files |
|------|-------|
| Search screen | `lib/features/search/presentation/screens/search_screen.dart` |
| Search provider with debounce | `lib/features/search/presentation/providers/search_provider.dart` |
| Filter bottom sheet | `lib/features/search/presentation/widgets/filter_sheet.dart` |
| Sort options | `lib/features/search/presentation/widgets/sort_options.dart` |

### Step 2.2: Categories
| Task | Files |
|------|-------|
| Category screen | `lib/features/category/presentation/screens/category_screen.dart` |
| Category grid widget | `lib/features/category/presentation/widgets/category_grid.dart` |
| Categories provider | `lib/features/category/presentation/providers/categories_provider.dart` |
| Seed categories to Firestore | Firebase Console / Script |

### Step 2.3: Match Algorithm
| Task | Files |
|------|-------|
| Match calculator utility | `lib/core/utils/match_calculator.dart` |
| Perfect match badge widget | `lib/core/shared/widgets/perfect_match_badge.dart` |
| Recommended users provider | `lib/features/home/presentation/providers/recommended_provider.dart` |

### Step 2.4: UX Polish
| Task | Files |
|------|-------|
| Loading shimmer widgets | `lib/core/shared/widgets/shimmer_loading.dart` |
| Empty state widgets | `lib/core/shared/widgets/empty_state.dart` |
| Error widgets | `lib/core/shared/widgets/error_widget.dart` |
| Snackbar/toast service | `lib/core/services/toast_service.dart` |

---

## Phase 3: Session Management
**Goal**: Complete session lifecycle with scheduling and tracking.

### Step 3.1: Scheduling
| Task | Files |
|------|-------|
| Schedule session screen | `lib/features/session/presentation/screens/schedule_session_screen.dart` |
| Date/time picker widgets | `lib/features/session/presentation/widgets/datetime_picker.dart` |
| Session provider | `lib/features/session/presentation/providers/session_provider.dart` |

### Step 3.2: Active Session
| Task | Files |
|------|-------|
| Active session screen | `lib/features/session/presentation/screens/active_session_screen.dart` |
| Session timer widget | `lib/features/session/presentation/widgets/session_timer.dart` |
| Video link button | `lib/features/session/presentation/widgets/video_link_button.dart` |

### Step 3.3: Local Notifications
| Task | Files |
|------|-------|
| Notification service | `lib/core/services/notification_service.dart` |
| Session reminders (24h, 1h, 15m) | (within notification service) |
| New message notifications | (within notification service) |

---

## Phase 4: Trust & Safety
**Goal**: Basic platform integrity mechanisms.

### Step 4.1: Verification
| Task | Files |
|------|-------|
| Email verification flow | `lib/features/auth/presentation/screens/verify_email_screen.dart` |
| Verification gate | `lib/features/auth/presentation/widgets/verification_gate.dart` |

### Step 4.2: Reporting
| Task | Files |
|------|-------|
| Report screen | `lib/features/report/presentation/screens/report_screen.dart` |
| Report repository | `lib/features/report/data/repositories/report_repository.dart` |
| Block user functionality | (within user repository) |

### Step 4.3: Anti-Abuse
| Task | Files |
|------|-------|
| Rate limiting checks | `lib/core/utils/rate_limiter.dart` |
| Firestore security rules | `firestore.rules` |

---

## Phase 5: Polish & Launch
**Goal**: Production-ready application.

### Step 5.1: Performance
| Task | Description |
|------|-------------|
| Pagination | Add pagination to user lists |
| Image caching | Optimize cached_network_image usage |
| Query optimization | Index Firestore queries |

### Step 5.2: Offline Support
| Task | Description |
|------|-------------|
| Firestore persistence | Enable offline persistence |
| Offline indicators | Show connection status |

### Step 5.3: Final Polish
| Task | Description |
|------|-------------|
| App icons | Generate app icons for all platforms |
| Splash screen assets | Native splash configuration |
| Store listings | Screenshots, descriptions |
| Testing | End-to-end testing |

---

## Implementation Order (Recommended)

```
Week 1-2: Foundation Setup
├── 1.1 Data Models (all Freezed models)
├── 1.2 Authentication (splash → onboarding → login/signup)
└── Run build_runner, test auth flow

Week 3-4: Profile & Home
├── 1.3 Profile Setup (4-step wizard)
├── 1.4 Home & Discovery (main shell, user list)
└── Test: User can sign up and see other users

Week 5-6: Core Swap Flow
├── 1.5 Swap Request (request, matches screen)
├── 1.6 Chat (list, detail, real-time messages)
└── Test: Users can request swap and chat

Week 7-8: Complete MVP Loop
├── 1.7 Rating & Credits (rating screen, wallet)
├── 1.8 Profile (view, edit, settings)
└── Test: Full swap cycle works end-to-end

Week 9-10: Discovery Enhancement
├── 2.1 Search & Filters
├── 2.2 Categories
├── 2.3 Match Algorithm
└── 2.4 UX Polish

Week 11-12: Sessions & Safety
├── 3.1-3.3 Session Management
├── 4.1-4.3 Trust & Safety
└── 5.1-5.3 Polish & Launch Prep
```

---

## Next Immediate Steps

1. **Create Data Models** - Start with Freezed models for User, Skill, Category
2. **Auth Feature** - Implement Firebase Auth with Email + Google
3. **Update Router** - Connect routes to actual screens as we build them

Ready to start with Step 1.1 (Data Models)?