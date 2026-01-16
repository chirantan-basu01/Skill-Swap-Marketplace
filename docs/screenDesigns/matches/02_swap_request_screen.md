# Swap Request Screen

## Overview
Form for sending a swap request to another user. Allows selecting which skills to exchange, duration, and an optional message.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [✕]      Request Swap               │
├─────────────────────────────────────┤
│                                     │
│  ┌────┐                             │
│  │Ava │  Sarah Martinez             │
│  │ 64 │  ★ 4.9 • 23 swaps           │
│  └────┘                             │
│                                     │
│  ─────────────────────────────────  │
│                                     │
│  Skill You Want From Them           │
│  ┌─────────────────────────────┐    │
│  │ 🎸 Guitar                 ▼ │    │
│  └─────────────────────────────┘    │
│  Expert level                       │
│                                     │
│  Skill You're Offering              │
│  ┌─────────────────────────────┐    │
│  │ 💻 Python                 ▼ │    │
│  └─────────────────────────────┘    │
│  Intermediate level                 │
│                                     │
│           ┌─────────┐               │
│     🎸    │   ↔    │    💻         │
│   Guitar  └─────────┘   Python      │
│                                     │
│  Session Duration                   │
│  ┌──────┬──────┬──────┬──────┐      │
│  │30min │ 1hr  │1.5hr │ 2hr  │      │
│  └──────┴──────┴──────┴──────┘      │
│  = 1.0 credits                      │
│                                     │
│  Message (Optional)                 │
│  ┌─────────────────────────────┐    │
│  │ Introduce yourself...       │    │
│  │                             │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │      Send Request           │    │
│  └─────────────────────────────┘    │
│                                     │
│  Your balance: 1.5 credits          │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### Header
```
Close Button:
  - Icon: × (24px)
  - Position: Top left
  - Tap: Dismiss with confirmation if form edited

Title:
  - Text: "Request Swap"
  - Style: H4, Gray 900
  - Position: Center
```

### User Info Section
```
Avatar:
  - Size: 64px
  - Position: Left

Info:
  - Name: H3, Gray 900
  - Stats: "★ X.X • Y swaps"
  - Style: Body M, Gray 500

Divider:
  - 1px Gray 200
  - Full width
  - Margin: 16px vertical
```

### Skill You Want (Dropdown)
```
Label:
  - Text: "Skill You Want From Them"
  - Style: Body M, SemiBold, Gray 700

Dropdown:
  - Height: 56px
  - Background: White
  - Border: 1.5px Gray 300
  - Border Radius: 12px
  - Padding: 16px

  Content:
    - Emoji + Skill name
    - Chevron-down right

  Tap: Opens skill selection sheet

Helper:
  - Text: "[Level] level"
  - Style: Body S, Gray 500

Options:
  - Only shows skills they offer
  - Pre-select if only one skill
  - Or pre-select based on what user clicked from profile
```

### Skill Selection Sheet
```
┌─────────────────────────────────────┐
│                                     │
│  ━━━━━  (handle)                    │
│                                     │
│  Select Skill You Want              │
│                                     │
│  Their Skills                       │
│  ┌─────────────────────────────┐    │
│  │ 🎸 Guitar              Expert│ ○ │
│  │    Acoustic & Electric       │   │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ 🎹 Piano          Intermediate│ ○│
│  │    Classical basics          │   │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘

Each option shows:
  - Skill emoji + name
  - Level badge
  - Radio button
  - Brief description
```

### Skill You're Offering (Dropdown)
```
Same pattern as "Skill You Want"

Options:
  - Only shows YOUR skills
  - Filtered to skills they might want (highlighted)

Helper:
  - If skill matches their wants: "✓ They want this!" (Success Green)
```

### Exchange Visualization
```
Visual representation of the swap:

    ┌─────────────────────────────┐
    │                             │
    │   🎸        ↔        💻    │
    │ Guitar            Python   │
    │ (learning)       (teaching)│
    │                             │
    └─────────────────────────────┘

Style:
  - Centered
  - Large emojis (32px)
  - Swap icon animated (subtle rotation)
  - Labels below in Gray 500
  - Background: Primary Surface (very light)
  - Border Radius: 12px
  - Padding: 20px
```

### Duration Selector
```
Label:
  - Text: "Session Duration"
  - Style: Body M, SemiBold, Gray 700

Segmented Control:
  - 4 options: 30min | 1hr | 1.5hr | 2hr
  - Height: 44px
  - Background: Gray 100
  - Border Radius: 8px

  Option:
    - Equal width
    - Text: Body M

  Selected:
    - Background: Primary Blue
    - Text: White
    - Shadow: shadow-xs

  Unselected:
    - Background: Transparent
    - Text: Gray 600

Credit Display:
  - Text: "= X.X credits"
  - Style: Body M, Primary Blue
  - Position: Below selector, centered
  - Updates based on selection
```

### Message Input
```
Label:
  - Text: "Message (Optional)"
  - Style: Body M, SemiBold, Gray 700

TextArea:
  - Height: 100px
  - Placeholder: "Introduce yourself and explain why you'd like to swap..."
  - Max Length: 500 characters
  - Character counter (bottom right)

Tips:
  - Show briefly: "A personal message increases acceptance rates"
  - Style: Body S, Gray 500, italic
```

### Send Request Button
```
Text:           "Send Request"
Style:          Primary Button, full width
Position:       Above balance info

Disabled States:
  - Skills not selected
  - Insufficient credits (for learning)
```

### Balance Info
```
Text:           "Your balance: X.X credits"
Style:          Body S, Gray 500
Position:       Bottom, centered

Warning (if low):
  - "You need X.X credits for this swap"
  - Style: Body S, Error Red
  - Icon: alert-circle
```

---

## Validation

### Credit Check
```
If user doesn't have enough credits:
  - Duration options that exceed balance are disabled
  - Or show warning and disable Send button

Message:
  "You need X.X credits. Teach a skill to earn more!"
  [Go to Profile] - to see teaching options
```

### Required Fields
```
- Skill you want: Required
- Skill you're offering: Required
- Duration: Required (default to 1hr)
- Message: Optional
```

---

## States

### Default
```
- User info displayed
- Dropdowns show placeholder or pre-selected
- Duration: 1hr selected by default
- Message empty
```

### Valid
```
- Both skills selected
- Duration selected
- Has sufficient credits
- Send button enabled
```

### Sending
```
- Send button: Spinner + "Sending..."
- All inputs disabled
- Can't dismiss
```

### Success
```
1. Button shows checkmark
2. Success feedback:

┌─────────────────────────────────────┐
│                                     │
│         ✓                           │
│                                     │
│   Request Sent!                     │
│                                     │
│   We'll notify you when Sarah       │
│   responds to your request.         │
│                                     │
│   [View Pending Requests]           │
│                                     │
│         Back to Home                │
│                                     │
└─────────────────────────────────────┘

3. Navigate to Matches (Pending tab)
```

### Error
```
- Inline error message
- "Failed to send request. Please try again."
- Retry button
```

---

## Limits & Restrictions

### Max Pending Requests
```
If user has 3 pending outgoing requests:

Banner at top:
  "You have 3 pending requests.
   Wait for responses before sending more."

Send button disabled
```

### Same User Cooldown
```
If swapped with this user in last 7 days:

Banner:
  "You recently swapped with Sarah.
   You can request again on [date]."

Send button disabled
```

---

## Animations

### Entry
```
- Slide up from bottom (modal style)
- Backdrop fade in
- Duration: 250ms
```

### Exchange Visualization
```
When both skills selected:
  - Emojis slide in from sides
  - Swap icon rotates once
  - Background fades in
```

### Duration Selection
```
- Selected pill slides to position
- Color transitions smoothly
- Credit amount fades/updates
```

### Success
```
- Checkmark scales up
- Confetti burst (subtle)
- Modal content crossfades
```

---

## Dismiss Handling

### With Unsaved Changes
```
"Discard this request?"
[Keep Editing] [Discard]
```

### Without Changes
```
Dismiss immediately, no prompt
```

---

## Accessibility
- Dropdowns have proper labels
- Selection sheets use list semantics
- Duration selector is radio button group
- Credit changes announced
- Success/error states announced
