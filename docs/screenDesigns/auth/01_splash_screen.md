# Splash Screen

## Overview
The splash screen is the first impression users have of the app. It displays the brand identity while the app initializes and checks authentication state.

**Duration**: 2-3 seconds (or until auth state is determined)

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│                                     │
│                                     │
│            ┌─────────┐              │
│            │  LOGO   │              │
│            │  ICON   │              │
│            └─────────┘              │
│                                     │
│           Skill Swap                │
│                                     │
│         ● ● ● (loading)             │
│                                     │
│                                     │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

### Specifications

#### Background
- **Type**: Gradient
- **Colors**: Primary Gradient (135deg, #4F46E5 → #7C3AED)
- **Alternative**: Solid Primary Blue for performance

#### Logo Container
- **Size**: 120px × 120px
- **Background**: White with 20% opacity
- **Border Radius**: 32px
- **Shadow**: shadow-xl with white tint

#### Logo Icon
- **Size**: 64px × 64px
- **Color**: White
- **Design**: Two arrows forming a circular swap motion
  - Represents exchange/swap concept
  - Modern, minimal line style
  - 2px stroke width

#### App Name
- **Text**: "Skill Swap"
- **Font**: Display (32px)
- **Color**: White
- **Spacing**: 24px below logo
- **Letter Spacing**: -0.5px

#### Loading Indicator
- **Type**: Three-dot pulse animation
- **Color**: White with 60% opacity
- **Dot Size**: 8px
- **Spacing**: 8px between dots
- **Position**: 40px below app name

---

## Animation Sequence

### Phase 1: Logo Entrance (0-500ms)
```
Logo Container:
  - Scale: 0.8 → 1.0
  - Opacity: 0 → 1
  - Easing: spring (bouncy)
```

### Phase 2: Text Fade In (300-600ms)
```
App Name:
  - Opacity: 0 → 1
  - TranslateY: 10px → 0
  - Easing: ease-out
```

### Phase 3: Loading Dots (500ms onwards)
```
Dots Animation:
  - Sequential pulse effect
  - Each dot: scale 1 → 1.3 → 1, opacity 0.6 → 1 → 0.6
  - Stagger: 150ms between each dot
  - Loop duration: 1.2s
```

### Phase 4: Exit (when ready)
```
Entire Screen:
  - Opacity: 1 → 0
  - Duration: 250ms
  - Easing: ease-in
```

---

## States

### Loading State (Default)
- Show logo, app name, and loading dots
- Loading dots animate continuously

### Auth Check Complete
- Stop loading animation
- Fade out splash screen
- Navigate to:
  - **Onboarding** (first launch)
  - **Login** (returning user, not logged in)
  - **Home** (logged in user with complete profile)
  - **Profile Setup** (logged in user with incomplete profile)

---

## Technical Notes

### Implementation
```dart
class SplashScreen extends StatefulWidget {
  // Auto-navigate after minimum display time
  // Check: isFirstLaunch, isLoggedIn, isProfileComplete
}
```

### Minimum Display Time
- 2 seconds minimum to prevent jarring flash
- Maximum 5 seconds before showing error

### Error Handling
- Network timeout: Show "Retry" button after 5s
- Auth error: Navigate to Login screen

---

## Accessibility
- Logo has semantic label: "Skill Swap Logo"
- Loading state announced to screen readers
- Respects "Reduce Motion" preference (skip animations)
