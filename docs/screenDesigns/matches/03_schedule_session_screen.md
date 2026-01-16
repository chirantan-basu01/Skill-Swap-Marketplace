# Schedule Session Screen

## Overview
Bottom sheet or screen for scheduling a swap session. Allows selecting date, time, and adding a video call link.

---

## Visual Design

### Layout (Bottom Sheet)
```
┌─────────────────────────────────────┐
│                                     │
│  ━━━━━  (handle)                    │
│                                     │
│  Schedule Session                   │
│  with Sarah Martinez                │
│                                     │
│  ─────────────────────────────────  │
│                                     │
│  🎸 Guitar ↔ 💻 Python              │
│  1 hour session                     │
│                                     │
│  ─────────────────────────────────  │
│                                     │
│  Select Date                        │
│  ┌─────────────────────────────┐    │
│  │      < January 2024 >       │    │
│  │ Su Mo Tu We Th Fr Sa        │    │
│  │     1  2  3  4  5  6        │    │
│  │  7  8  9 10 11 12 13        │    │
│  │ 14 15 [16] 17 18 19 20      │    │
│  │ 21 22 23 24 25 26 27        │    │
│  │ 28 29 30 31                 │    │
│  └─────────────────────────────┘    │
│                                     │
│  Select Time                        │
│  ┌─────────────────────────────┐    │
│  │ 🕐 3:00 PM                ▼ │    │
│  └─────────────────────────────┘    │
│  Your time (EST) • 8:00 PM their    │
│  time (GMT)                         │
│                                     │
│  Video Call Link                    │
│  ┌─────────────────────────────┐    │
│  │ 🔗 Paste Meet/Zoom link     │    │
│  └─────────────────────────────┘    │
│  Or create: [Google Meet] [Zoom]    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │      Confirm Schedule       │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### Header
```
Handle:
  - 40px wide, 4px tall
  - Gray 300
  - Centered, 12px from top

Title:
  - Text: "Schedule Session"
  - Style: H3, Gray 900

Subtitle:
  - Text: "with [Name]"
  - Style: Body M, Gray 500
```

### Swap Summary
```
Container:
  - Background: Gray 50
  - Border Radius: 8px
  - Padding: 12px
  - Margin: 16px horizontal

Content:
  - Skill exchange: "🎸 Guitar ↔ 💻 Python"
  - Duration: "1 hour session"
  - Style: Body M, Gray 700
```

### Date Picker
```
Label:
  - Text: "Select Date"
  - Style: Body M, SemiBold, Gray 700

Calendar:
  - Inline calendar widget
  - Background: White
  - Border: 1px Gray 200
  - Border Radius: 12px
  - Padding: 16px

Month Navigation:
  - < [Month Year] >
  - Arrows: Gray 400, tap to navigate
  - Month: Body L, SemiBold, Gray 900

Day Headers:
  - Su Mo Tu We Th Fr Sa
  - Style: Caption, Gray 500

Day Cells:
  - Size: 40px × 40px
  - Style: Body M

  Today:
    - Border: 1px Primary Blue
    - Background: Transparent

  Selected:
    - Background: Primary Blue
    - Text: White
    - Border Radius: full

  Available:
    - Text: Gray 900
    - Tappable

  Past:
    - Text: Gray 300
    - Not tappable

  Unavailable (optional):
    - Text: Gray 300
    - Strikethrough
```

### Time Picker
```
Label:
  - Text: "Select Time"
  - Style: Body M, SemiBold, Gray 700

Dropdown:
  - Height: 56px
  - Background: White
  - Border: 1.5px Gray 300
  - Border Radius: 12px
  - Padding: 16px

  Content:
    - Clock icon + Selected time
    - Format: "3:00 PM"
    - Chevron-down right

Timezone Info:
  - "Your time ([TZ]) • [Time] their time ([TZ])"
  - Style: Body S, Gray 500
  - Helps coordinate across timezones
```

### Time Selection Sheet
```
┌─────────────────────────────────────┐
│                                     │
│  ━━━━━  (handle)                    │
│                                     │
│  Select Time                        │
│                                     │
│  ┌─────────────────────────────┐    │
│  │                             │    │
│  │    ┌────┐   :   ┌────┐      │    │
│  │    │ 03 │       │ 00 │  PM  │    │
│  │    └────┘       └────┘      │    │
│  │      ▲            ▲         │    │
│  │      ▼            ▼         │    │
│  │                             │    │
│  └─────────────────────────────┘    │
│                                     │
│  [Done]                             │
│                                     │
└─────────────────────────────────────┘

Wheel Picker:
  - Hour (1-12) | Minutes (00, 15, 30, 45) | AM/PM
  - Scroll to select
  - Haptic feedback on selection
```

### Video Link Input
```
Label:
  - Text: "Video Call Link"
  - Style: Body M, SemiBold, Gray 700

Input:
  - Height: 56px
  - Placeholder: "Paste your Google Meet or Zoom link"
  - Prefix Icon: link (Gray 400)
  - Keyboard: url

Quick Create Links:
  - Text: "Or create:"
  - Style: Body S, Gray 500

  Buttons:
    - [Google Meet] [Zoom]
    - Style: Text buttons, Primary Blue
    - Tap: Opens respective service to create meeting
    - Note: External link, user copies link back
```

### Confirm Button
```
Text:           "Confirm Schedule"
Style:          Primary Button, full width
Position:       Bottom of sheet

Disabled:       Until date, time, and link provided
```

---

## Validation

### Required Fields
```
- Date: Required (must be future)
- Time: Required
- Video Link: Required

If link missing:
  - Can still confirm
  - Show warning: "Add a video link so you can meet"
  - Allow anyway (link can be added in chat)
```

### Link Validation
```
Accept patterns:
  - meet.google.com/*
  - zoom.us/*
  - teams.microsoft.com/*
  - Any https:// link (flexible)

Invalid:
  - Show error: "Please enter a valid video call link"
```

---

## States

### Default
```
- Date: Today or tomorrow pre-selected
- Time: Next available hour
- Link: Empty
```

### Scheduling
```
- Button: Spinner + "Scheduling..."
- Inputs disabled
```

### Success
```
1. Button shows checkmark
2. Success message:

┌─────────────────────────────────────┐
│                                     │
│         ✓                           │
│                                     │
│   Session Scheduled!                │
│                                     │
│   📅 Thursday, Jan 16 at 3:00 PM    │
│                                     │
│   You'll both receive reminders     │
│   before the session.               │
│                                     │
│   [Add to Calendar]                 │
│                                     │
│   ┌─────────────────────────────┐   │
│   │      Open Chat              │   │
│   └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘

"Add to Calendar":
  - Exports .ics file
  - Or opens calendar app
```

### Error
```
- Inline error: "Failed to schedule. Please try again."
- Retry option
```

---

## Reminders Setup

### Automatic Reminders
```
When session is scheduled:
  - 24 hours before
  - 1 hour before
  - 15 minutes before

Uses local notifications
User can customize in settings
```

### Reminder Preview
```
Small note after confirmation:
"📱 You'll receive reminders 24h, 1h, and 15min before"
Style: Body S, Gray 500
```

---

## Timezone Handling

### Display
```
Always show both timezones:
  "3:00 PM your time (EST)"
  "8:00 PM Sarah's time (GMT)"

Prevents confusion
```

### Conversion
```
- Store in UTC
- Display in each user's local timezone
- Recalculate on display
```

---

## Animations

### Sheet Entry
```
- Slide from bottom
- Backdrop fade
- Duration: 250ms
```

### Calendar Selection
```
- Selected day: scale pulse (1 → 1.1 → 1)
- Color transition: 150ms
```

### Success
```
- Checkmark scale in
- Calendar icon bounce
- Confetti (subtle)
```

---

## Rescheduling

### From Existing Session
```
If session already scheduled:
  - Pre-fill existing date/time/link
  - Title: "Reschedule Session"
  - Button: "Update Schedule"
  - Show previous time with strikethrough
```

### Notification
```
When rescheduled:
  - Both users notified
  - Previous reminders cancelled
  - New reminders set
```

---

## Accessibility
- Calendar navigable with keyboard
- Date selection announced
- Time picker wheels have labels
- Timezone info read out
- Success/confirmation announced
