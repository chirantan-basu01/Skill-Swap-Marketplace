# Login Screen

## Overview
Clean, focused login screen with email/password and social sign-in options. Minimal friction to get users into the app.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [←]                                 │
│                                     │
│                                     │
│         Welcome Back                │
│    Sign in to continue swapping     │
│                                     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ ✉  Email                    │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ 🔒 Password             👁  │    │
│  └─────────────────────────────┘    │
│                                     │
│                  Forgot Password?   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │         Sign In             │    │
│  └─────────────────────────────┘    │
│                                     │
│  ─────────── or ───────────        │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  [G] Continue with Google   │    │
│  └─────────────────────────────┘    │
│                                     │
│                                     │
│                                     │
│    Don't have an account? Sign Up   │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### Header Section
```
Back Button:
  - Position: Top left, 16px from edges
  - Style: Icon Button (arrow-left)
  - Size: 44px touch target
  - Only shows if: came from onboarding

Title:
  - Text: "Welcome Back"
  - Style: H1, Gray 900
  - Position: 60px from top (or 32px below back button)
  - Alignment: Left (20px padding)

Subtitle:
  - Text: "Sign in to continue swapping"
  - Style: Body L, Gray 500
  - Position: 8px below title
```

### Email Input
```
Label:          "Email"
Placeholder:    "Enter your email"
Prefix Icon:    mail (Gray 400)
Keyboard:       email
Autocomplete:   email
Validation:     Valid email format

Specs:
  - Height: 56px
  - Margin: 32px top, 20px horizontal
```

### Password Input
```
Label:          "Password"
Placeholder:    "Enter your password"
Prefix Icon:    lock (Gray 400)
Suffix Icon:    eye / eye-off (toggle visibility)
Keyboard:       text (secure)
Autocomplete:   current-password

Specs:
  - Height: 56px
  - Margin: 16px top
```

### Forgot Password Link
```
Text:           "Forgot Password?"
Style:          Body M, Primary Blue
Position:       Right-aligned, 12px below password field
Action:         Navigate to password reset flow
```

### Sign In Button
```
Text:           "Sign In"
Style:          Primary Button, full width
Position:       32px below forgot password
State:          Disabled until valid input
```

### Divider
```
Style:          Horizontal line with "or" text
Line:           1px Gray 200
Text:           Body S, Gray 400, centered
Position:       24px below sign in button
```

### Google Sign In Button
```
Text:           "Continue with Google"
Icon:           Google "G" logo (24px)
Style:
  - Background: White
  - Border: 1.5px Gray 300
  - Height: 52px
  - Border Radius: 12px
Position:       24px below divider
```

### Sign Up Link
```
Text:           "Don't have an account? Sign Up"
Style:          Body M, Gray 600
              "Sign Up" in Primary Blue, SemiBold
Position:       Bottom of screen, 32px from bottom safe area
```

---

## Input Validation

### Email Field
```
On Change:      Remove error state
On Blur:        Validate format
Invalid:
  - Border: Error Red
  - Helper: "Please enter a valid email"
  - Icon: alert-circle (Error Red)
```

### Password Field
```
On Change:      Remove error state
On Submit:      Validate not empty
Invalid:
  - Border: Error Red
  - Helper: "Password is required"
```

---

## States

### Default
- Empty fields
- Sign In button disabled (Gray 300 bg)

### Valid Input
- Both fields filled and valid
- Sign In button enabled (Primary Blue)

### Loading
```
Sign In Button:
  - Show spinner (20px, white)
  - Text: "Signing In..."
  - Disabled state
  - All inputs disabled

Google Button:
  - Similar loading state
```

### Error States

#### Invalid Credentials
```
Display:        Inline banner above form
Banner Style:
  - Background: Error Light
  - Border-left: 4px Error Red
  - Padding: 16px
  - Border Radius: 8px

Icon:           alert-circle (Error Red)
Text:           "Invalid email or password. Please try again."
Style:          Body M, Gray 900
```

#### Network Error
```
Banner Text:    "Unable to connect. Please check your internet."
Action:         "Retry" link
```

#### Too Many Attempts
```
Banner Text:    "Too many attempts. Please try again in 5 minutes."
```

---

## Animations

### Page Entry
```
Content:
  - Opacity: 0 → 1
  - TranslateY: 20px → 0
  - Duration: 300ms
  - Stagger: 50ms between elements
```

### Button Loading
```
Text → Spinner:
  - Crossfade, 150ms
  - Spinner rotation starts immediately
```

### Error Banner
```
Entry:
  - Height: 0 → auto
  - Opacity: 0 → 1
  - Duration: 250ms
```

### Success
```
On successful login:
  - Brief checkmark animation (300ms)
  - Fade out screen (200ms)
  - Navigate to Home/Setup
```

---

## Keyboard Handling

### Behavior
- Email field: "Next" button → focus password
- Password field: "Done" button → submit form
- Keyboard dismiss on tap outside fields

### Layout Adjustment
- Content scrolls up when keyboard appears
- Sign In button visible above keyboard
- Sign Up link hidden when keyboard open

---

## Accessibility
- Labels properly associated with inputs
- Error messages announced to screen readers
- Password visibility toggle has clear label
- Minimum touch targets: 44px
- Focus order: Email → Password → Forgot → Sign In → Google → Sign Up
