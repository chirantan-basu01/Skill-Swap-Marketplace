# Skill Swap Marketplace - Implementation Plan

## Current Status
- [x] Project setup & Firebase configuration
- [x] Clean Architecture folder structure
- [x] Type-safe routing with go_router_builder
- [x] Core constants (routes, Firestore, theme, assets)
- [x] Android & iOS build configuration
- [x] **Step 1.1: Data Models** - User, Skill, Category, Swap, Chat, Message, Transaction models
- [x] **Step 1.2: Authentication** - Splash, Onboarding, Login, Signup screens with Email + Google
- [x] **Step 1.3: Profile Setup** - 4-step wizard with modern UI
- [x] **Step 1.4: Home & Discovery** - Main shell, Home screen, User cards, User profile view
- [x] **Step 1.5: Swap Request Feature** - Swap repository, Matches screen with tabs, Swap request screen
- [x] **Step 1.6: Chat Feature** - Chat list, Chat detail, Real-time messaging, Swap-chat integration
- [x] **Step 1.7: Rating & Credits Feature** - Star rating, Rating tags, Rating screen, Wallet screen
- [x] **Step 1.8: Profile Feature** - Profile screen, Edit profile, Settings with logout
- [x] **Step 2.1: Search & Filters** - Search screen, debounced search, filters, sort options
- [x] **Step 2.2: Categories** - Category screen, skill filters, teacher cards, sort sheet
- [x] **Step 2.3: Match Algorithm** - Match calculator, perfect match badge, scoring system
- [x] **Step 2.4: UX Polish** - Shimmer loading, empty states, error widgets, toast service
- [x] **Step 2.5: Skill Editing** - Edit skills offered/wanted screens, Edit Profile skill buttons

**Progress: Phase 1 - 100% complete (8/8 steps) ✅**
**Progress: Phase 2 - 100% complete (5/5 steps) ✅**
**Progress: Phase 3 - 33% complete (1/3 steps) 🔄**

### Recent Bug Fixes & Improvements
- Fixed stale user data when switching accounts (providers now watch `authStateChangesProvider`)
- Fixed "disposed during loading state" error with `isProfileCompleteProvider`
- Fixed navigation buttons in Wallet screen ("Find a Swap Partner")
- Fixed navigation buttons in Matches screen ("Find Someone to Swap With", "Browse Pending Requests")

---

## Phase 1: Foundation (MVP Core)
**Goal**: Complete the basic swap loop - users can sign up, find others, request swap, chat, complete session, rate, and transfer credits.

### ✅ Step 1.1: Data Models (Freezed) - COMPLETED
Create all Freezed models with JSON serialization.

| Status | Task | Files |
|--------|------|-------|
| ✅ | User model | `lib/features/auth/domain/models/user_model.dart` |
| ✅ | Skill model | `lib/features/skills/domain/models/skill_model.dart` |
| ✅ | Category model | `lib/features/skills/domain/models/category_model.dart` |
| ✅ | Swap model | `lib/features/swap/domain/models/swap_model.dart` |
| ✅ | Chat model | `lib/features/chat/domain/models/chat_model.dart` |
| ✅ | Message model | `lib/features/chat/domain/models/message_model.dart` |
| ✅ | Transaction model | `lib/features/wallet/domain/models/transaction_model.dart` |
| ✅ | Rating model | `lib/features/rating/domain/models/rating_model.dart` |

### ✅ Step 1.2: Authentication Feature - COMPLETED
Complete auth flow with Firebase.

| Status | Task | Files |
|--------|------|-------|
| ✅ | Auth repository interface | `lib/features/auth/domain/repositories/auth_repository.dart` |
| ✅ | Auth repository impl | `lib/features/auth/data/repositories/auth_repository_impl.dart` |
| ✅ | Auth providers (Riverpod) | `lib/features/auth/presentation/providers/auth_provider.dart` |
| ✅ | Splash screen | `lib/features/auth/presentation/screens/splash_screen.dart` |
| ✅ | Onboarding screen (3 slides) | `lib/features/auth/presentation/screens/onboarding_screen.dart` |
| ✅ | Login screen | `lib/features/auth/presentation/screens/login_screen.dart` |
| ✅ | Signup screen | `lib/features/auth/presentation/screens/signup_screen.dart` |
| ✅ | Google Sign-In integration | (within auth repository) |
| ✅ | Auth state listener | (within auth_provider.dart) |

### ✅ Step 1.3: Profile Setup Feature - COMPLETED
User onboarding wizard (4 steps).

| Status | Task | Files |
|--------|------|-------|
| ✅ | User repository interface | `lib/features/auth/domain/repositories/user_repository.dart` |
| ✅ | User repository impl | `lib/features/auth/data/repositories/user_repository_impl.dart` |
| ✅ | User providers | `lib/features/auth/presentation/providers/user_provider.dart` |
| ✅ | Category provider | `lib/features/skills/presentation/providers/category_provider.dart` |
| ✅ | Setup Basic Info screen | `lib/features/profile/presentation/screens/setup_basic_info_screen.dart` |
| ✅ | Setup Skills Offered screen | `lib/features/profile/presentation/screens/setup_skills_offered_screen.dart` |
| ✅ | Setup Skills Wanted screen | `lib/features/profile/presentation/screens/setup_skills_wanted_screen.dart` |
| ✅ | Setup Availability screen | `lib/features/profile/presentation/screens/setup_availability_screen.dart` |
| ✅ | Setup progress indicator | `lib/features/profile/presentation/widgets/setup_progress_indicator.dart` |
| ✅ | Skill chip list widget | `lib/features/profile/presentation/widgets/skill_chip_list.dart` |
| ✅ | Add skill dialog | `lib/features/profile/presentation/widgets/add_skill_dialog.dart` |

### ✅ Step 1.4: Home & Discovery Feature - COMPLETED
Main app shell with bottom navigation.

| Status | Task | Files |
|--------|------|-------|
| ✅ | Main shell with BottomNav | `lib/features/main/presentation/screens/main_shell_screen.dart` |
| ✅ | Home screen | `lib/features/home/presentation/screens/home_screen.dart` |
| ✅ | User card widget | `lib/core/shared/widgets/user_card.dart` |
| ✅ | User avatar widget | `lib/core/shared/widgets/user_avatar.dart` |
| ✅ | Skill chip widget | `lib/core/shared/widgets/skill_chip.dart` |
| ✅ | Users list provider | `lib/features/home/presentation/providers/users_provider.dart` |
| ✅ | User profile view screen | `lib/features/user/presentation/screens/user_profile_view_screen.dart` |

### ✅ Step 1.5: Swap Request Feature - COMPLETED
Request and manage skill swaps.

| Status | Task | Files |
|--------|------|-------|
| ✅ | Swap repository interface | `lib/features/swap/domain/repositories/swap_repository.dart` |
| ✅ | Swap repository impl | `lib/features/swap/data/repositories/swap_repository_impl.dart` |
| ✅ | Swap request screen | `lib/features/swap/presentation/screens/swap_request_screen.dart` |
| ✅ | Matches screen (tabs) | `lib/features/swap/presentation/screens/matches_screen.dart` |
| ✅ | Swap card widget | `lib/features/swap/presentation/widgets/swap_card.dart` |
| ✅ | Swap status badge widget | `lib/features/swap/presentation/widgets/swap_status_badge.dart` |
| ✅ | Swaps provider | `lib/features/swap/presentation/providers/swaps_provider.dart` |

### ✅ Step 1.6: Chat Feature - COMPLETED
Real-time messaging with swap integration.

| Status | Task | Files |
|--------|------|-------|
| ✅ | Chat repository interface | `lib/features/chat/domain/repositories/chat_repository.dart` |
| ✅ | Chat repository impl | `lib/features/chat/data/repositories/chat_repository_impl.dart` |
| ✅ | Chat list screen | `lib/features/chat/presentation/screens/chat_list_screen.dart` |
| ✅ | Chat detail screen | `lib/features/chat/presentation/screens/chat_detail_screen.dart` |
| ✅ | Message bubble widget | `lib/features/chat/presentation/widgets/message_bubble.dart` |
| ✅ | Chat input widget | `lib/features/chat/presentation/widgets/chat_input.dart` |
| ✅ | Chat provider (combined) | `lib/features/chat/presentation/providers/chat_provider.dart` |
| ✅ | Swap-chat integration | Auto-create chat on swap acceptance |
| ✅ | Typing indicators | Real-time typing status |
| ✅ | Online status | User active status display |

### ✅ Step 1.7: Rating & Credits Feature - COMPLETED
Post-session rating and credit transfer.

| Status | Task | Files |
|--------|------|-------|
| ✅ | Rating screen | `lib/features/rating/presentation/screens/rating_screen.dart` |
| ✅ | Rating tags widget | `lib/features/rating/presentation/widgets/rating_tags.dart` |
| ✅ | Star rating widget | `lib/features/rating/presentation/widgets/star_rating.dart` |
| ✅ | Rating provider | `lib/features/rating/presentation/providers/rating_provider.dart` |
| ✅ | Wallet screen | `lib/features/wallet/presentation/screens/wallet_screen.dart` |
| ✅ | Transaction list widget | `lib/features/wallet/presentation/widgets/transaction_list.dart` |
| ✅ | Wallet provider | `lib/features/wallet/presentation/providers/wallet_provider.dart` |

### ✅ Step 1.8: Profile Feature - COMPLETED
User's own profile management.

| Status | Task | Files |
|--------|------|-------|
| ✅ | Profile screen | `lib/features/profile/presentation/screens/profile_screen.dart` |
| ✅ | Edit profile screen | `lib/features/profile/presentation/screens/edit_profile_screen.dart` |
| ✅ | Settings screen (with logout) | `lib/features/profile/presentation/screens/settings_screen.dart` |

---

## Phase 2: Discovery & UX
**Goal**: Enhanced findability and polished user experience.

### ✅ Step 2.1: Search & Filters - COMPLETED
| Status | Task | Files |
|--------|------|-------|
| ✅ | Search screen | `lib/features/search/presentation/screens/search_screen.dart` |
| ✅ | Search provider with debounce | `lib/features/search/presentation/providers/search_provider.dart` |
| ✅ | Filter bottom sheet | `lib/features/search/presentation/widgets/filter_sheet.dart` |
| ✅ | Sort options | `lib/features/search/presentation/widgets/sort_options.dart` |

### ✅ Step 2.2: Categories - COMPLETED
| Status | Task | Files |
|--------|------|-------|
| ✅ | Category screen | `lib/features/category/presentation/screens/category_screen.dart` |
| ✅ | Category header widget | `lib/features/category/presentation/widgets/category_header.dart` |
| ✅ | Teacher card widget | `lib/features/category/presentation/widgets/teacher_card.dart` |
| ✅ | Skill filter chips widget | `lib/features/category/presentation/widgets/skill_filter_chips.dart` |
| ✅ | Category sort sheet | `lib/features/category/presentation/widgets/category_sort_sheet.dart` |
| ✅ | Category users provider | `lib/features/category/presentation/providers/category_users_provider.dart` |
| ✅ | Seed categories to Firestore | `lib/core/utils/firestore_seeder.dart` + Settings screen Developer section |

### ✅ Step 2.3: Match Algorithm - COMPLETED
| Status | Task | Files |
|--------|------|-------|
| ✅ | Match calculator utility | `lib/core/utils/match_calculator.dart` |
| ✅ | Perfect match badge widget | `lib/core/shared/widgets/perfect_match_badge.dart` |
| ✅ | Updated users provider with MatchCalculator | `lib/features/home/presentation/providers/users_provider.dart` |

**Match Scoring (0-100 points):**
- Skill overlap: 50 points max (perfect match 40 + bonus, one-way 20 + bonus)
- Rating: 20 points max (scaled from 0-5)
- Activity recency: 15 points max (active today = 15, yesterday = 12, etc.)
- Experience: 15 points max (completed swaps)

### ✅ Step 2.4: UX Polish - COMPLETED
| Status | Task | Files |
|--------|------|-------|
| ✅ | Loading shimmer widgets | `lib/core/shared/widgets/shimmer_loading.dart` |
| ✅ | Empty state widgets | `lib/core/shared/widgets/empty_state.dart` |
| ✅ | Error widgets | `lib/core/shared/widgets/error_widget.dart` |
| ✅ | Snackbar/toast service | `lib/core/services/toast_service.dart` |

**Components Created:**
- `Shimmer` - Animated shimmer effect with gradient shader
- `ShimmerBox`, `ShimmerCircle` - Basic shimmer shapes
- `ShimmerUserCardCompact`, `ShimmerUserCardFull` - User card loading states
- `ShimmerCategoryTile`, `ShimmerChatItem`, `ShimmerSwapCard` - Feature-specific loading states
- `EmptyState` - Generic empty state with icon, title, description, actions
- Pre-built empty states: `EmptyStateNoMatches`, `EmptyStateNoResults`, `EmptyStateNoMessages`, etc.
- `AppErrorWidget` - Generic error with retry action
- Pre-built errors: `NetworkErrorWidget`, `ServerErrorWidget`, `AuthErrorWidget`, `LoadFailureWidget`
- `InlineErrorWidget`, `ErrorBanner` - Contextual error displays
- `ToastService` - Global toast service with success/error/warning/info types
- Context extension and mixin for easy toast access

### ✅ Step 2.5: Skill Editing - COMPLETED
Allow users to update their skills after initial profile setup.

| Status | Task | Files |
|--------|------|-------|
| ✅ | Edit Skills Offered screen | `lib/features/profile/presentation/screens/edit_skills_offered_screen.dart` |
| ✅ | Edit Skills Wanted screen | `lib/features/profile/presentation/screens/edit_skills_wanted_screen.dart` |
| ✅ | Update user repository (updateSkillsOffered, updateSkillsWanted) | `lib/features/auth/data/repositories/user_repository_impl.dart` |
| ✅ | Update Edit Profile screen with skill edit buttons | `lib/features/profile/presentation/screens/edit_profile_screen.dart` |
| ✅ | Add routes for skill editing screens | `lib/core/config/app_router.dart` |

**Approach**: Reused existing AddSkillOfferedDialog and AddSkillWantedDialog widgets, SkillChipList for display, with local state management for unsaved changes detection.

---

## Phase 3: Session Management
**Goal**: Complete session lifecycle with scheduling and tracking.

### ✅ Step 3.1: Scheduling - COMPLETED
| Status | Task | Files |
|--------|------|-------|
| ✅ | Schedule session screen | `lib/features/session/presentation/screens/schedule_session_screen.dart` |
| ✅ | Date/time picker widgets | `lib/features/session/presentation/widgets/datetime_picker.dart` |
| ✅ | Session provider | `lib/features/session/presentation/providers/session_provider.dart` |

**Components Created:**
- `ScheduleSessionScreen` - Full-screen scheduling with calendar, time picker, video link input
- `SessionCalendar` - Custom calendar widget with month navigation, date selection
- `SessionTimePicker` - Dropdown with bottom sheet time slot selector (15-min intervals)
- `VideoLinkInput` - URL input with quick links for Google Meet/Zoom
- `SwapSummaryCard` - Displays skill exchange info and duration
- `ScheduleSessionNotifier` - Riverpod state management for scheduling flow
- `swapByIdProvider` - Fetch single swap by ID
- `showScheduleSessionSheet()` - Alternative bottom sheet presentation

### ⬜ Step 3.2: Active Session
| Status | Task | Files |
|--------|------|-------|
| ⬜ | Active session screen | `lib/features/session/presentation/screens/active_session_screen.dart` |
| ⬜ | Session timer widget | `lib/features/session/presentation/widgets/session_timer.dart` |
| ⬜ | Video link button | `lib/features/session/presentation/widgets/video_link_button.dart` |

### ⬜ Step 3.3: Local Notifications
| Status | Task | Files |
|--------|------|-------|
| ⬜ | Notification service | `lib/core/services/notification_service.dart` |
| ⬜ | Session reminders (24h, 1h, 15m) | (within notification service) |
| ⬜ | New message notifications | (within notification service) |

---

## Phase 4: Trust & Safety
**Goal**: Basic platform integrity mechanisms.

### ⬜ Step 4.1: Verification
| Status | Task | Files |
|--------|------|-------|
| ⬜ | Email verification flow | `lib/features/auth/presentation/screens/verify_email_screen.dart` |
| ⬜ | Verification gate | `lib/features/auth/presentation/widgets/verification_gate.dart` |

### ⬜ Step 4.2: Reporting
| Status | Task | Files |
|--------|------|-------|
| ⬜ | Report screen | `lib/features/report/presentation/screens/report_screen.dart` |
| ⬜ | Report repository | `lib/features/report/data/repositories/report_repository.dart` |
| ⬜ | Block user functionality | (within user repository) |

### ⬜ Step 4.3: Anti-Abuse
| Status | Task | Files |
|--------|------|-------|
| ⬜ | Rate limiting checks | `lib/core/utils/rate_limiter.dart` |
| ⬜ | Firestore security rules | `firestore.rules` |

---

## Phase 5: Polish & Launch
**Goal**: Production-ready application.

### ⬜ Step 5.1: Performance
| Status | Task | Description |
|--------|------|-------------|
| ⬜ | Pagination | Add pagination to user lists |
| ⬜ | Image caching | Optimize cached_network_image usage |
| ⬜ | Query optimization | Index Firestore queries |

### ⬜ Step 5.2: Offline Support
| Status | Task | Description |
|--------|------|-------------|
| ⬜ | Firestore persistence | Enable offline persistence |
| ⬜ | Offline indicators | Show connection status |

### ⬜ Step 5.3: Final Polish
| Status | Task | Description |
|--------|------|-------------|
| ⬜ | App icons | Generate app icons for all platforms |
| ⬜ | Splash screen assets | Native splash configuration |
| ⬜ | Store listings | Screenshots, descriptions |
| ⬜ | Testing | End-to-end testing |

---

## Implementation Order (Recommended)

```
Week 1-2: Foundation Setup ✅ DONE
├── 1.1 Data Models (all Freezed models) ✅
├── 1.2 Authentication (splash → onboarding → login/signup) ✅
└── 1.3 Profile Setup (4-step wizard) ✅

Week 3-4: Profile & Home ✅ DONE
├── 1.4 Home & Discovery (main shell, user list) ✅
└── Test: User can sign up and see other users ✅

Week 5-6: Core Swap Flow ✅ DONE
├── 1.5 Swap Request (request, matches screen) ✅
├── 1.6 Chat (list, detail, real-time messages) ✅
└── Test: Users can request swap and chat ✅

Week 7-8: Complete MVP Loop ✅ DONE
├── 1.7 Rating & Credits (rating screen, wallet) ✅
├── 1.8 Profile (view, edit, settings) ✅
└── Test: Full swap cycle works end-to-end ✅

Week 9-10: Discovery Enhancement ✅ DONE
├── 2.1 Search & Filters ✅
├── 2.2 Categories ✅
├── 2.3 Match Algorithm ✅
├── 2.4 UX Polish ✅
└── 2.5 Skill Editing ✅

Week 11-12: Sessions & Safety
├── 3.1-3.3 Session Management
├── 4.1-4.3 Trust & Safety
└── 5.1-5.3 Polish & Launch Prep
```

---

## Next Immediate Steps

1. **Phase 2: Discovery & UX** - ✅ COMPLETE (5/5)
   - ~~Step 2.1: Search & Filters~~ ✅ DONE
   - ~~Step 2.2: Categories~~ ✅ DONE (category screen, skill filter, sort, teacher cards)
   - ~~Step 2.3: Match Algorithm~~ ✅ DONE (match calculator, perfect match badge, scoring system)
   - ~~Step 2.4: UX Polish~~ ✅ DONE (shimmer loading, empty states, error widgets, toast service)
   - ~~Step 2.5: Skill Editing~~ ✅ DONE (edit skills offered/wanted screens accessible from Edit Profile)

2. **Phase 3: Session Management** - **IN PROGRESS**
   - ~~Step 3.1: Scheduling~~ ✅ DONE (schedule session screen with calendar, time picker, video link)
   - Step 3.2: Active Session - Session screen with timer and video link
   - Step 3.3: Local Notifications - Session reminders (24h, 1h, 15m)

3. **Note**: ScheduleSessionRoute and ActiveSessionRoute exist but use placeholder screens

---

## Technical Decisions Made

| Decision | Choice | Reason |
|----------|--------|--------|
| State Management | Riverpod (no setState) | Cleaner separation, testability |
| Constants | Centralized files | No hardcoded strings for assets/Firestore |
| JSON Serialization | `explicit_to_json: true` in build.yaml | Nested objects serialize properly |
| Form State | TextEditingController in StatefulWidget | Persists across navigation |
| Firestore Constants | Single merged file | Removed duplicate `firestore_paths.dart` |
| Bottom Navigation | `IndexedStack` + `navigationIndexProvider` | Preserves tab state; use provider (not go_router) for tab switching |
| Auth State | Providers watch `authStateChangesProvider` | Ensures data refreshes on account switch |
| FutureProvider | Never watch StreamProvider | Prevents "disposed during loading" race conditions |