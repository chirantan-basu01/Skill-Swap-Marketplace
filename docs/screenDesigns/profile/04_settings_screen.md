# Settings Screen

## Overview
App settings and account management. Includes notifications, privacy, account actions, and app info.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [←]          Settings               │
├─────────────────────────────────────┤
│                                     │
│  Account                            │
│  ┌───────────────────────────────┐  │
│  │ 👤 Edit Profile            → │  │
│  ├───────────────────────────────┤  │
│  │ ✉️  Email                     │  │
│  │    john@email.com       ✓    │  │
│  ├───────────────────────────────┤  │
│  │ 🔒 Change Password         → │  │
│  └───────────────────────────────┘  │
│                                     │
│  Notifications                      │
│  ┌───────────────────────────────┐  │
│  │ 🔔 Push Notifications    [●] │  │
│  ├───────────────────────────────┤  │
│  │ 💬 New Messages          [●] │  │
│  ├───────────────────────────────┤  │
│  │ 🔄 Swap Requests         [●] │  │
│  ├───────────────────────────────┤  │
│  │ ⏰ Session Reminders     [●] │  │
│  └───────────────────────────────┘  │
│                                     │
│  Privacy                            │
│  ┌───────────────────────────────┐  │
│  │ 👁️  Profile Visibility     → │  │
│  ├───────────────────────────────┤  │
│  │ 🚫 Blocked Users           → │  │
│  └───────────────────────────────┘  │
│                                     │
│  Support                            │
│  ┌───────────────────────────────┐  │
│  │ ❓ Help Center             → │  │
│  ├───────────────────────────────┤  │
│  │ 📝 Send Feedback           → │  │
│  ├───────────────────────────────┤  │
│  │ 📋 Terms of Service        → │  │
│  ├───────────────────────────────┤  │
│  │ 🔐 Privacy Policy          → │  │
│  └───────────────────────────────┘  │
│                                     │
│  App                                │
│  ┌───────────────────────────────┐  │
│  │ ℹ️  About                   → │  │
│  ├───────────────────────────────┤  │
│  │    Version 1.0.0 (build 1)   │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 🚪 Sign Out                   │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ⚠️  Delete Account            │  │
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### App Bar
```
Back Button:
  - Icon: arrow-left
  - Position: Left

Title:
  - Text: "Settings"
  - Style: H4, Gray 900
  - Center
```

### Section Header
```
Text:           Section name
Style:          Body S, SemiBold, Gray 500
Text Transform: Uppercase
Margin:         24px top, 20px horizontal, 8px bottom
```

### Settings Group
```
Container:
  - Background: White
  - Border Radius: 12px
  - Margin: 0 20px
  - Overflow: hidden

Items separated by 1px Gray 100 divider
```

### Standard Setting Row
```
Height:         56px
Padding:        16px

Layout:
┌───────────────────────────────────────┐
│ [Icon]  Label                      → │
└───────────────────────────────────────┘

Icon:
  - Size: 24px
  - Color: Gray 600
  - Or emoji

Label:
  - Style: Body L, Gray 900

Arrow:
  - Icon: chevron-right
  - Color: Gray 400

Tap: Navigate to detail screen
```

### Setting Row with Value
```
┌───────────────────────────────────────┐
│ [Icon]  Label                         │
│         Value                    → │
└───────────────────────────────────────┘

Value:
  - Style: Body M, Gray 500
  - Below or inline with label
  - Shows current setting

Badge (if applicable):
  - Verification checkmark
  - Warning indicator
```

### Toggle Setting Row
```
┌───────────────────────────────────────┐
│ [Icon]  Label                    [●] │
└───────────────────────────────────────┘

Toggle Switch:
  - Size: 51 × 31px (iOS standard)
  - On: Primary Blue track
  - Off: Gray 300 track
  - Thumb: White
```

### Destructive Action Row
```
Sign Out:
  - Text: "Sign Out"
  - Style: Body L, Error Red
  - Icon: log-out
  - Centered text

Delete Account:
  - Text: "Delete Account"
  - Style: Body L, Error Red
  - Icon: trash-2
  - More prominent warning style
```

---

## Setting Details

### Account Section

#### Edit Profile
```
Navigate to Edit Profile Screen
```

#### Email
```
Shows current email
Verified badge (✓) if verified
If unverified: "Verify" button
```

#### Change Password
```
Opens password change flow:
1. Enter current password
2. Enter new password
3. Confirm new password
4. Save
```

### Notifications Section

All toggles default ON:

#### Push Notifications
```
Master toggle for all notifications
If off, other toggles disabled
```

#### New Messages
```
Notify when new chat message received
```

#### Swap Requests
```
Notify when new swap request received
```

#### Session Reminders
```
Notify before scheduled sessions
24h, 1h, 15min before
```

### Privacy Section

#### Profile Visibility
```
Options:
  - Public (default) - Anyone can find you
  - Limited - Only matching users
  - Hidden - Only existing connections
```

#### Blocked Users
```
List of blocked users:
  - Avatar + Name
  - "Unblock" button
  - Empty: "No blocked users"
```

### Support Section

#### Help Center
```
Opens FAQ / Help documentation
In-app webview or external link
```

#### Send Feedback
```
Opens feedback form:
  - Subject dropdown
  - Message text
  - Optional screenshot
  - Send button
```

#### Terms of Service
```
Opens terms document
In-app webview
```

#### Privacy Policy
```
Opens privacy policy
In-app webview
```

### App Section

#### About
```
┌─────────────────────────────────────┐
│                                     │
│         Skill Swap                  │
│         Version 1.0.0               │
│                                     │
│   Trade skills, not money           │
│                                     │
│   Made with ❤️                      │
│                                     │
│   © 2024 Skill Swap                 │
│                                     │
│   [Rate on App Store]               │
│                                     │
└─────────────────────────────────────┘
```

#### Version Info
```
Non-interactive row
Shows: "Version 1.0.0 (build 1)"
Tap 7 times: Show debug info (dev feature)
```

---

## Actions

### Sign Out Flow
```
Confirmation Dialog:
┌─────────────────────────────────────┐
│                                     │
│   Sign out?                         │
│                                     │
│   You'll need to sign in again      │
│   to use Skill Swap.                │
│                                     │
│   [Cancel]            [Sign Out]    │
│                                     │
└─────────────────────────────────────┘

On confirm:
  - Clear local data
  - Sign out from Firebase
  - Navigate to Login screen
```

### Delete Account Flow
```
Step 1 - Warning:
┌─────────────────────────────────────┐
│                                     │
│   ⚠️ Delete Account?                 │
│                                     │
│   This will permanently delete:     │
│   • Your profile and skills         │
│   • All swap history                │
│   • Your credit balance             │
│   • Reviews you've given/received   │
│                                     │
│   This cannot be undone.            │
│                                     │
│   [Cancel]        [Continue]        │
│                                     │
└─────────────────────────────────────┘

Step 2 - Confirm:
  - Enter password
  - Type "DELETE" to confirm
  - Final delete button

On confirm:
  - Delete all user data
  - Sign out
  - Navigate to onboarding
  - Show "Account deleted" message
```

---

## States

### Loading
```
- Skeleton for current settings
- Toggles show loading state
```

### Toggle Loading
```
When toggling:
  - Show spinner on toggle
  - Disable until complete
```

### Error
```
If setting fails to save:
  - Revert toggle
  - Show error toast
  - "Failed to update setting"
```

---

## Animations

### Entry
```
- Slide from right
- Sections fade in
```

### Toggle
```
- Smooth thumb movement
- Track color transition
- Haptic feedback
```

### Navigation
```
- Push navigation for sub-screens
- Slide transitions
```

---

## Accessibility
- All rows are buttons with labels
- Toggle states announced
- Destructive actions have warnings
- Section headers are headings
- Navigation announced
