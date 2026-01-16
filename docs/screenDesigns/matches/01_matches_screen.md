# Matches Screen

## Overview
Central hub for managing all swap requests and ongoing sessions. Uses tabs to organize by status: Pending, Active, and Completed.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│            My Swaps                 │
├─────────────────────────────────────┤
│  ┌─────────┬─────────┬─────────┐    │
│  │ Pending │ Active  │Completed│    │
│  │   (3)   │   (1)   │         │    │
│  └─────────┴─────────┴─────────┘    │
│  ━━━━━━━━━━                         │
├─────────────────────────────────────┤
│                                     │
│  Incoming Requests (2)              │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                        │  │
│  │ │    │ John wants to swap     │  │
│  │ └────┘ 🎸 Guitar ↔ 💻 Python  │  │
│  │        1 hour • 2 days ago    │  │
│  │                               │  │
│  │  [Decline]         [Accept]   │  │
│  └───────────────────────────────┘  │
│                                     │
│  Your Requests (1)                  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                        │  │
│  │ │    │ Waiting for Sarah      │  │
│  │ └────┘ 💻 Python ↔ 🇪🇸 Spanish │  │
│  │        30 min • Sent 1 day ago│  │
│  │                               │  │
│  │           ⏳ Pending          │  │
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### App Bar
```
Style:          Simple, no back button (main nav)
Title:          "My Swaps"
Style:          H3, Gray 900, centered
Height:         56px
Background:     White
```

### Tab Bar
```
Layout:
  - 3 tabs, equal width
  - Height: 48px
  - Background: White
  - Border Bottom: 2px Gray 200

Tab:
  - Text: Tab name
  - Badge: Count in parentheses (if > 0)
  - Style: Button text

  Active:
    - Text: Primary Blue
    - Bottom border: 2px Primary Blue
    - Badge: Primary Blue

  Inactive:
    - Text: Gray 500
    - No bottom border
    - Badge: Gray 400

Tabs:
  1. Pending (incoming + outgoing requests)
  2. Active (accepted, scheduled, in progress)
  3. Completed (finished swaps)
```

---

## Pending Tab

### Section Headers
```
"Incoming Requests (X)"
  - Requests from others to you

"Your Requests (X)"
  - Requests you sent to others

Style: Body M, SemiBold, Gray 700
Margin: 20px horizontal, 16px top
```

### Incoming Request Card
```
Container:
  - Background: White
  - Border: 1.5px Primary Light (highlight incoming)
  - Border Radius: 16px
  - Padding: 16px
  - Shadow: shadow-sm

Layout:
┌───────────────────────────────────────┐
│ ┌────┐                          NEW   │
│ │Ava │  [Name] wants to swap          │
│ │ 48 │                                │
│ └────┘  🎸 Guitar  ↔  💻 Python       │
│         (theirs)     (yours)          │
│                                       │
│  Duration: 1 hour                     │
│  📅 Received 2 days ago               │
│                                       │
│  "Hey, I'd love to learn Python..."   │
│                                       │
│  ┌──────────┐      ┌──────────┐       │
│  │ Decline  │      │  Accept  │       │
│  └──────────┘      └──────────┘       │
└───────────────────────────────────────┘

NEW Badge:
  - Position: Top right
  - Background: Error Red
  - Text: "NEW" (White, Caption)
  - Visible for first 24 hours

Avatar:
  - Size: 48px
  - Tap: View their profile

Header Text:
  - "[Name] wants to swap"
  - Style: Body L, SemiBold, Gray 900

Skill Exchange:
  - Their skill → Your skill
  - Emoji + name for each
  - ↔ swap icon between
  - Labels below: "(theirs)" "(yours)" in Gray 400

Duration:
  - "Duration: X hour(s)"
  - Style: Body S, Gray 600

Timestamp:
  - Calendar icon + "Received X ago"
  - Style: Body S, Gray 500

Message (if provided):
  - Quoted text
  - Background: Gray 50
  - Max 2 lines, expandable
  - Style: Body S, Gray 600

Action Buttons:
  - Decline: Secondary Button (outline)
  - Accept: Primary Button
  - Equal width, 12px gap
```

### Outgoing Request Card
```
Similar to incoming but:
  - Border: Gray 200 (not highlighted)
  - Header: "Waiting for [Name]"
  - No action buttons
  - Status badge instead

Status Badge:
  ⏳ Pending
  - Background: Warning Light
  - Text: Warning Dark
  - Centered at bottom
```

---

## Active Tab

### Active Swap Card
```
Container:
  - Background: White
  - Border: 1.5px Success Green (active indicator)
  - Border Radius: 16px
  - Padding: 16px
  - Shadow: shadow-sm

Layout:
┌───────────────────────────────────────┐
│ ┌────┐                                │
│ │Ava │  Swap with Sarah         ●Live │
│ │ 48 │                                │
│ └────┘  🎸 Guitar  ↔  💻 Python       │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ 📅 Tomorrow, 3:00 PM            │  │
│  │ ⏱  1 hour session              │  │
│  │ 🔗 Google Meet                  │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌────────────────────────────────┐   │
│  │        Open Chat               │   │
│  └────────────────────────────────┘   │
└───────────────────────────────────────┘

Status Indicators:
  - "● Live" - Session in progress (pulsing green)
  - "Scheduled" - Has date/time
  - "Accepted" - Not yet scheduled

Session Info Box:
  - Background: Primary Surface
  - Border Radius: 8px
  - Shows scheduled time, duration, video link
  - Only visible if scheduled

Session States:

1. Accepted (not scheduled):
   Button: "Schedule Session"

2. Scheduled:
   Button: "Open Chat"
   Secondary: "Start Session" (if within 15 min of time)

3. In Progress:
   - Green pulsing border
   - Button: "Return to Session"
   - Shows elapsed time
```

### Upcoming Sessions Section
```
If multiple active swaps:

"Upcoming Sessions"
  - Sort by scheduled date
  - Nearest first
```

---

## Completed Tab

### Completed Swap Card
```
Container:
  - Background: White
  - Border: 1px Gray 200
  - Border Radius: 16px
  - Padding: 16px
  - Slightly muted appearance

Layout:
┌───────────────────────────────────────┐
│ ┌────┐                                │
│ │Ava │  Swap with John          ✓Done │
│ │ 48 │                                │
│ └────┘  🎸 Guitar  ↔  💻 Python       │
│                                       │
│  📅 Completed Jan 15, 2024            │
│  ⏱  1 hour • +1.0 credits earned     │
│                                       │
│  Your Review                          │
│  ★★★★★ "Great session!"              │
│                                       │
│  ┌────────────────────────────────┐   │
│  │       View Details             │   │
│  └────────────────────────────────┘   │
└───────────────────────────────────────┘

Done Badge:
  - Background: Gray 200
  - Text: "✓ Done" (Gray 600)

Credits:
  - If you taught: "+X credits earned" (Success Green)
  - If you learned: "-X credits spent" (Gray 600)

Review Section:
  - Show your rating
  - Truncated review text
  - "View Details" to see full exchange
```

---

## Empty States

### Empty Pending
```
┌─────────────────────────────────────┐
│                                     │
│         📭                          │
│                                     │
│   No pending requests               │
│                                     │
│   When you send or receive swap     │
│   requests, they'll appear here     │
│                                     │
│   [Find Someone to Swap With]       │
│                                     │
└─────────────────────────────────────┘
```

### Empty Active
```
┌─────────────────────────────────────┐
│                                     │
│         🤝                          │
│                                     │
│   No active swaps                   │
│                                     │
│   Accept a request or have one      │
│   accepted to start swapping        │
│                                     │
│   [Browse Pending Requests]         │
│                                     │
└─────────────────────────────────────┘
```

### Empty Completed
```
┌─────────────────────────────────────┐
│                                     │
│         🏆                          │
│                                     │
│   No completed swaps yet            │
│                                     │
│   Complete your first swap to       │
│   start building your reputation    │
│                                     │
│   [Start Your First Swap]           │
│                                     │
└─────────────────────────────────────┘
```

---

## Actions

### Accept Request Flow
```
1. Tap "Accept"
2. Confirmation dialog:
   "Accept swap with [Name]?
    You'll exchange [skill] for [skill]
    for [duration]"
   [Cancel] [Accept]
3. On confirm:
   - Card animates out of Pending
   - Moves to Active tab
   - Chat is created
   - Notification sent
```

### Decline Request Flow
```
1. Tap "Decline"
2. Optional reason sheet:
   "Let [Name] know why (optional)"
   - Not available at this time
   - Skills don't match my needs
   - Other reason: [text input]
   [Skip] [Send]
3. Card fades out
4. Request marked declined
```

---

## Animations

### Tab Switch
```
- Underline slides to new tab
- Content crossfades
- Duration: 200ms
```

### Card Actions
```
Accept:
  - Button shows checkmark
  - Card scales down slightly
  - Slides out to right
  - Success haptic

Decline:
  - Card fades out
  - Other cards slide up
  - Duration: 250ms
```

### Pull to Refresh
```
- Standard refresh pattern
- Reloads all tabs
```

---

## Real-time Updates
```
- New requests appear automatically
- Status changes reflected immediately
- Use Firestore listeners
- Badge counts update in real-time
```

---

## Accessibility
- Tab bar uses proper tab semantics
- Cards announce full context
- Action buttons clearly labeled
- Status changes announced
- Badge counts read with tab names
