# Sign Up Screen

## Overview
Account creation screen with email/password registration and Google sign-up. Emphasizes the welcome bonus to encourage completion.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [←]                                 │
│                                     │
│         Create Account              │
│     Join and get 1 free credit!     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ 👤 Full Name                │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ ✉  Email                    │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ 🔒 Password             👁  │    │
│  └─────────────────────────────┘    │
│       ✓ Min 8 characters            │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ 🔒 Confirm Password     👁  │    │
│  └─────────────────────────────┘    │
│                                     │
│  ☐ I agree to the Terms of Service  │
│    and Privacy Policy               │
│                                     │
│  ┌─────────────────────────────┐    │
│  │       Create Account        │    │
│  └─────────────────────────────┘    │
│                                     │
│  ─────────── or ───────────        │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  [G] Continue with Google   │    │
│  └─────────────────────────────┘    │
│                                     │
│   Already have an account? Sign In  │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### Header
```
Back Button:
  - Icon: arrow-left
  - Position: Top left, 16px padding
  - Action: Return to previous screen

Title:
  - Text: "Create Account"
  - Style: H1, Gray 900
  - Margin: 60px top

Subtitle:
  - Text: "Join and get 1 free credit!"
  - Style: Body L, Primary Blue (emphasize reward)
  - Icon: Optional sparkle/gift icon
  - Margin: 8px below title
```

### Form Fields

#### Full Name Input
```
Label:          "Full Name"
Placeholder:    "Enter your full name"
Prefix Icon:    user (Gray 400)
Keyboard:       text
Autocomplete:   name
Autocapitalize: words
Validation:     Min 2 characters
```

#### Email Input
```
Label:          "Email"
Placeholder:    "Enter your email"
Prefix Icon:    mail (Gray 400)
Keyboard:       email
Autocomplete:   email
Validation:     Valid email format
```

#### Password Input
```
Label:          "Password"
Placeholder:    "Create a password"
Prefix Icon:    lock (Gray 400)
Suffix Icon:    eye / eye-off
Keyboard:       text (secure)
Autocomplete:   new-password
```

#### Password Requirements
```
Display:        Below password field, 8px margin
Style:          Body S

Requirements (each with check icon):
  ○ Min 8 characters          → ✓ when met (Success Green)
  ○ One uppercase letter      → ✓ when met
  ○ One number                → ✓ when met

Unmet:          Gray 400 text, empty circle
Met:            Success Green text, filled check
```

#### Confirm Password Input
```
Label:          "Confirm Password"
Placeholder:    "Re-enter your password"
Prefix Icon:    lock (Gray 400)
Suffix Icon:    eye / eye-off
Validation:     Must match password field
```

### Terms Checkbox
```
Layout:         Checkbox + text, left-aligned
Checkbox:
  - Size: 24px
  - Unchecked: Gray 300 border, white fill
  - Checked: Primary Blue fill, white check icon
  - Border Radius: 6px

Text:
  - "I agree to the "
  - "Terms of Service" (Primary Blue, tappable)
  - " and "
  - "Privacy Policy" (Primary Blue, tappable)

Style:          Body S, Gray 600
```

### Create Account Button
```
Text:           "Create Account"
Style:          Primary Button, full width
Disabled:       Until all fields valid + terms checked
```

### Divider & Google Button
```
Same as Login Screen
```

### Sign In Link
```
Text:           "Already have an account? Sign In"
Position:       Bottom, 32px from safe area
```

---

## Validation

### Real-time Validation
```
Full Name:
  - On blur: Check min length
  - Error: "Name must be at least 2 characters"

Email:
  - On blur: Check format
  - Error: "Please enter a valid email"

  - On submit: Check if exists
  - Error: "This email is already registered. Sign in instead?"

Password:
  - On change: Update requirement checklist
  - All must be green to proceed

Confirm Password:
  - On change: Compare with password
  - Error: "Passwords don't match"
```

### Form Submission Validation
```
All fields must be:
  - Filled
  - Valid
  - Terms checkbox checked

If any invalid:
  - Shake animation on button
  - Scroll to first error
  - Focus first invalid field
```

---

## States

### Default
- All fields empty
- Requirements show as unmet (gray)
- Button disabled

### Partial Input
- Show validation feedback on blur
- Button remains disabled

### Valid & Ready
- All checks green
- Terms checked
- Button enabled with Primary Blue

### Loading
```
Create Account Button:
  - Spinner + "Creating Account..."
  - All inputs disabled
```

### Error States

#### Email Already Exists
```
Email Field:
  - Error border
  - Helper: "This email is already registered"
  - Link: "Sign in instead?" (navigates to login with email pre-filled)
```

#### Weak Password
```
Password Field:
  - Show unmet requirements in red
```

#### Network Error
```
Banner:
  - "Unable to create account. Please try again."
  - Retry button
```

---

## Success Flow

### Account Created
```
1. Button shows checkmark (300ms)
2. Success modal/overlay:

   ┌─────────────────────────────┐
   │                             │
   │     🎉                      │
   │                             │
   │   Account Created!          │
   │                             │
   │   We've sent a verification │
   │   email to your inbox.      │
   │                             │
   │   ┌─────────────────────┐   │
   │   │   Continue Setup    │   │
   │   └─────────────────────┘   │
   │                             │
   │     Open Email App          │
   │                             │
   └─────────────────────────────┘

3. "Continue Setup" → Profile Setup Wizard
4. "Open Email App" → Open email client (optional)
```

---

## Keyboard Handling

### Focus Flow
```
Name → Email → Password → Confirm → (scroll to terms/button)
```

### Keyboard Actions
- Each field: "Next" to advance
- Confirm Password: "Done" to dismiss and scroll to terms

### Layout
- Form scrollable
- Active field always visible above keyboard

---

## Animations

### Entry
```
- Staggered fade-in for form fields
- 50ms delay between each field
```

### Password Requirements
```
Met Requirement:
  - Circle → Check morph (200ms)
  - Color change with slight scale pulse
```

### Success
```
- Confetti burst from button
- Modal slides up from bottom
```

---

## Accessibility
- Clear error messages associated with fields
- Password requirements announced as list
- Checkbox has proper label association
- Terms links distinguishable and tappable
- Form submission errors announced
