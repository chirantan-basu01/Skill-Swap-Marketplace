# Setup: Availability Screen

## Overview
Final step of the profile setup wizard. Users set their timezone and general availability preferences.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [←]              Step 4 of 4        │
│                                     │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                     │
│       When Are You Available?       │
│    Help others know the best time   │
│          to connect with you        │
│                                     │
│                                     │
│  Your Timezone                      │
│  ┌─────────────────────────────┐    │
│  │ 🌍 America/New_York     [▼] │    │
│  │    (UTC-05:00)              │    │
│  └─────────────────────────────┘    │
│                                     │
│  General Availability               │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ 🌅  Morning                 │    │
│  │     6:00 AM - 12:00 PM      │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ ☀️  Afternoon        [✓]    │    │
│  │     12:00 PM - 6:00 PM      │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ 🌙  Evening                 │    │
│  │     6:00 PM - 12:00 AM      │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ 🔄  Flexible          [✓]   │    │
│  │     I'm open to any time    │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │      Complete Setup         │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### Header
```
Progress: 100% (4/4) - filled completely
Back: Returns to Step 3
```

### Title Section
```
Title:
  - Text: "When Are You Available?"
  - Style: H2, Gray 900

Subtitle:
  - Text: "Help others know the best time to connect with you"
  - Style: Body L, Gray 500
```

### Timezone Selector
```
Label:
  - Text: "Your Timezone"
  - Style: Body M, SemiBold, Gray 700
  - Margin: 32px top

Dropdown:
  - Height: 64px
  - Background: White
  - Border: 1.5px Gray 300
  - Border Radius: 12px
  - Padding: 16px

  Content:
    ┌─────────────────────────────────┐
    │ 🌍  America/New_York        [▼] │
    │     (UTC-05:00) Eastern Time    │
    └─────────────────────────────────┘

  Primary Line: Timezone ID (Body L, Gray 900)
  Secondary Line: UTC offset + friendly name (Body S, Gray 500)
  Icon: globe (left), chevron-down (right)

Auto-detect:
  - Pre-fill with device timezone
  - Show "📍 Detected from your device" hint below
```

### Timezone Picker (Bottom Sheet)
```
┌─────────────────────────────────────┐
│                                     │
│  ━━━━━  (handle)                    │
│                                     │
│  Select Timezone                    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ 🔍 Search timezone...       │    │
│  └─────────────────────────────┘    │
│                                     │
│  📍 Detected                        │
│  ┌─────────────────────────────┐    │
│  │ America/New_York    (UTC-5) │ ✓  │
│  └─────────────────────────────┘    │
│                                     │
│  All Timezones                      │
│  ┌─────────────────────────────┐    │
│  │ Africa/Cairo        (UTC+2) │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ America/Chicago     (UTC-6) │    │
│  └─────────────────────────────┘    │
│           ... scrollable ...        │
│                                     │
└─────────────────────────────────────┘

Features:
  - Search by city name or timezone ID
  - Group by region (optional)
  - Current selection has checkmark
```

### Availability Section
```
Label:
  - Text: "General Availability"
  - Style: Body M, SemiBold, Gray 700
  - Margin: 24px top

Note:
  - Text: "Select all that apply"
  - Style: Body S, Gray 500
```

### Availability Option Card
```
Container:
  - Height: 72px
  - Background: White
  - Border: 1.5px Gray 200
  - Border Radius: 12px
  - Padding: 16px
  - Margin: 12px vertical

Selected State:
  - Border: 2px Primary Blue
  - Background: Primary Surface (very light)

Layout:
┌─────────────────────────────────────┐
│ [Emoji]  Title               [Check]│
│          Time range / description   │
└─────────────────────────────────────┘

Icon:
  - Size: 28px
  - Position: Left, vertically centered

Title:
  - Style: Body L, SemiBold, Gray 900

Description:
  - Style: Body S, Gray 500
  - 4px below title

Check Indicator:
  - Position: Right
  - Unselected: Empty circle outline (Gray 300)
  - Selected: Primary Blue filled circle with white check

Options:
  1. Morning   - 🌅 - "6:00 AM - 12:00 PM"
  2. Afternoon - ☀️ - "12:00 PM - 6:00 PM"
  3. Evening   - 🌙 - "6:00 PM - 12:00 AM"
  4. Flexible  - 🔄 - "I'm open to any time"
```

### Flexible Option Behavior
```
When "Flexible" is selected:
  - All other options become unchecked
  - Visually distinct (maybe different bg color)

When any specific time is selected:
  - "Flexible" becomes unchecked

Allow multiple specific times:
  - User can select Morning + Evening
  - Just not combined with Flexible
```

### Complete Setup Button
```
Text:           "Complete Setup"
Style:          Primary Button, full width
Icon:           Optional checkmark or sparkle
Position:       Bottom, 32px from safe area

Disabled:       Until timezone and at least one availability selected
```

---

## States

### Default
```
- Timezone: Auto-detected, pre-filled
- Availability: None selected
- Button: Disabled

If timezone can't be detected:
  - Show picker immediately
  - Or default to UTC
```

### Valid State
```
- Timezone: Selected
- Availability: At least one option selected
- Button: Enabled
```

### Loading (Completing Setup)
```
Button:
  - Spinner + "Setting up..."
  - All inputs disabled

After success:
  - Checkmark animation
  - Navigate to welcome/home screen
```

---

## Completion Flow

### Success Animation
```
1. Button shows checkmark (300ms)
2. Screen fades out (200ms)
3. Welcome modal appears:

┌─────────────────────────────────────┐
│                                     │
│           🎉                        │
│                                     │
│     You're All Set!                 │
│                                     │
│   Your profile is complete and      │
│   you've received 1 credit to       │
│   start learning!                   │
│                                     │
│   ┌─────────────────────────────┐   │
│   │  1.0 credits                │   │
│   │  🎁 Welcome Bonus           │   │
│   └─────────────────────────────┘   │
│                                     │
│   ┌─────────────────────────────┐   │
│   │     Start Exploring         │   │
│   └─────────────────────────────┘   │
│                                     │
│       View Your Profile             │
│                                     │
└─────────────────────────────────────┘

4. Confetti animation
5. Navigate to Home Screen
```

---

## Animations

### Progress Bar Completion
```
When entering this screen:
  - Progress animates from 75% → 100%
  - Slight celebration pulse when full
  - Color might briefly flash Success Green
```

### Availability Selection
```
Card Selection:
  - Border color transition (150ms)
  - Background color transition (150ms)
  - Check icon: scale 0 → 1, opacity 0 → 1 (200ms, spring)
```

### Timezone Picker
```
Bottom sheet:
  - Slide from bottom
  - Backdrop fade in
  - List items stagger in (subtle)
```

---

## Validation

### Requirements
```
- Timezone: Required
- Availability: At least one option selected
```

### Error States
```
Timezone not detected:
  - Show inline message
  - "Please select your timezone manually"

No availability selected:
  - Shake animation on section
  - Highlight cards briefly
```

---

## Accessibility
- Timezone picker searchable
- Availability options are toggle buttons
- Selection state clearly announced
- Progress completion announced
- Welcome modal is focusable and dismissible
