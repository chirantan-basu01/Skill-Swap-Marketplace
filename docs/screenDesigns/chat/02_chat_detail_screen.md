# Chat Detail Screen

## Overview
Full conversation view with messaging, swap context banner, and session scheduling. Real-time messaging via Firestore.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [←]  Sarah Martinez           [⋮]  │
├─────────────────────────────────────┤
│ ┌───────────────────────────────┐   │
│ │ 🎸 Guitar ↔ 💻 Python         │   │
│ │ 1 hour • Scheduled: Tomorrow  │   │
│ │ [Start Session]               │   │
│ └───────────────────────────────┘   │
├─────────────────────────────────────┤
│                                     │
│                  📅 January 15      │
│                                     │
│ ┌──────────────────┐                │
│ │ Hi! I'm excited  │                │
│ │ to learn guitar! │  10:30 AM      │
│ └──────────────────┘                │
│                                     │
│              ┌──────────────────┐   │
│              │ Hey! Me too.     │   │
│    10:32 AM  │ What songs do    │   │
│              │ you want to      │   │
│              │ learn?           │   │
│              └──────────────────┘   │
│                            ✓✓       │
│                                     │
│ ┌──────────────────┐                │
│ │ Mostly pop and   │                │
│ │ some classics    │  10:35 AM      │
│ └──────────────────┘                │
│                                     │
│        ┌────────────────────┐       │
│        │ Session scheduled  │       │
│        │ for Jan 16, 3 PM   │       │
│        └────────────────────┘       │
│                                     │
├─────────────────────────────────────┤
│ [📷] [Type a message...    ] [➤]   │
└─────────────────────────────────────┘
```

---

## Components

### App Bar
```
Height:         56px
Background:     White
Shadow:         shadow-xs

Back Button:
  - Icon: arrow-left
  - Position: Left
  - Tap: Return to chat list

Title Section:
  - Avatar: 36px, centered with name
  - Name: Body L, SemiBold, Gray 900
  - Online status: "Active now" or "Last seen 2h ago"
  - Style: Caption, Gray 500
  - Tap: View user profile

Menu Button:
  - Icon: more-vertical (⋮)
  - Position: Right
  - Tap: Opens action menu
```

### Action Menu
```
┌─────────────────────────┐
│ View Profile            │
│ Schedule Session        │
│ View Swap Details       │
│ ─────────────────────── │
│ Mute Notifications      │
│ Report User             │
│ Block User              │
└─────────────────────────┘
```

### Swap Context Banner
```
Position:       Below app bar, sticky
Background:     Primary Surface
Border Bottom:  1px Primary Light
Padding:        12px 16px

Layout:
┌───────────────────────────────────────┐
│ 🎸 Guitar ↔ 💻 Python         [Button]│
│ 1 hour • Status text                  │
└───────────────────────────────────────┘

Skill Exchange:
  - Emoji + name ↔ emoji + name
  - Style: Body M, Gray 900

Status Line:
  - Style: Body S, Gray 600
  - Shows: "1 hour • [status]"

Status Variations:
  - "Accepted - Schedule a session"
    Button: "Schedule"
  - "Scheduled: Tomorrow, 3 PM"
    Button: "Start Session" (if within 15 min)
  - "In Progress"
    Button: "Return to Session"
  - "Awaiting Rating"
    Button: "Rate Now"
  - "Completed ✓"
    No button

Button:
  - Style: Small Primary Button
  - Position: Right side
  - Context-dependent action

Collapsible:
  - Tap to expand/collapse
  - Saves screen space
```

---

## Message List

### Date Separator
```
Text:           "January 15" or "Today" / "Yesterday"
Style:          Caption, Gray 400
Position:       Centered
Background:     Subtle pill (Gray 100, rounded)
Padding:        4px 12px
Margin:         16px vertical
```

### Message Bubble - Received
```
Position:       Left aligned
Max Width:      75% of screen
Background:     Gray 100
Border Radius:  16px 16px 16px 4px (tail bottom-left)
Padding:        12px 16px

Text:
  - Style: Body M, Gray 900
  - Links: Primary Blue, underlined

Timestamp:
  - Position: Below bubble, left
  - Style: Caption, Gray 400
  - Format: "10:30 AM"
```

### Message Bubble - Sent
```
Position:       Right aligned
Max Width:      75% of screen
Background:     Primary Blue
Border Radius:  16px 16px 4px 16px (tail bottom-right)
Padding:        12px 16px

Text:
  - Style: Body M, White

Timestamp:
  - Position: Below bubble, right
  - Style: Caption, Gray 400

Read Receipt:
  - Double check (✓✓) if read
  - Single check (✓) if delivered
  - Position: Next to timestamp
  - Color: Primary Blue if read, Gray 400 if not
```

### Image Message
```
Container:
  - Max Width: 240px
  - Max Height: 320px
  - Border Radius: 12px
  - Overflow: hidden

Image:
  - Object Fit: cover
  - Tap: Full-screen viewer

Loading:
  - Shimmer placeholder
  - Progress indicator

Sent Image:
  - Blue border or tint
```

### System Message
```
Position:       Centered
Background:     Gray 100
Border Radius:  full
Padding:        8px 16px
Max Width:      80%

Text:
  - Style: Body S, Gray 600
  - Centered

Examples:
  - "Session scheduled for Jan 16, 3 PM"
  - "Sarah started the session"
  - "Swap completed! Rate your experience."
```

### Typing Indicator
```
Position:       Left, below last message
Background:     Gray 100
Border Radius:  16px
Padding:        12px 16px
Width:          60px

Animation:
  - Three dots
  - Sequential bounce
  - "Sarah is typing..."
```

---

## Input Area

### Layout
```
Height:         Auto (min 56px, expands with content)
Background:     White
Border Top:     1px Gray 200
Padding:        8px 12px
Safe Area:      Bottom padding for notch

┌─────────────────────────────────────────┐
│ [📷]  ┌───────────────────────┐   [➤]  │
│       │ Type a message...     │        │
│       └───────────────────────┘        │
└─────────────────────────────────────────┘
```

### Attachment Button
```
Icon:           camera (or image picker)
Size:           44px × 44px touch target
Position:       Left
Color:          Gray 500

Tap: Opens attachment options
  - Camera
  - Photo Library
```

### Text Input
```
Placeholder:    "Type a message..."
Style:          Body M, Gray 900
Background:     Gray 100
Border Radius:  20px (pill shape)
Padding:        10px 16px
Min Height:     40px
Max Height:     120px (then scroll)

Multiline:      Yes, auto-expand
```

### Send Button
```
Icon:           send (arrow up)
Size:           40px × 40px
Background:     Primary Blue (when active)
Border Radius:  full
Position:       Right

States:
  - Empty input: Gray 300 bg, Gray 500 icon, disabled
  - Has text: Primary Blue bg, White icon, enabled

Animation:
  - On send: Scale pulse + icon transforms
```

---

## States

### Loading
```
- App bar visible
- Swap banner visible
- Messages: Shimmer placeholders
- Input area visible but disabled
```

### Empty Conversation
```
┌─────────────────────────────────────┐
│                                     │
│         👋                          │
│                                     │
│   Start the conversation!           │
│                                     │
│   Introduce yourself and discuss    │
│   your swap plans.                  │
│                                     │
└─────────────────────────────────────┘

Quick Suggestions:
  - "Hi! I'm excited about our swap!"
  - "When works best for you?"
  - Tap to send
```

### Sending Message
```
Message bubble appears immediately:
  - Slightly transparent
  - Shows sending indicator
  - Timestamp: "Sending..."

On success:
  - Full opacity
  - Timestamp updates
  - Check mark appears
```

### Send Failed
```
Failed message:
  - Red tint on bubble
  - Error icon
  - Tap to retry
  - "Failed to send. Tap to retry."
```

### User Blocked
```
Input disabled:
  - "You can't message this user"
  - Option to unblock
```

---

## Scroll Behavior

### Initial Load
```
- Scroll to bottom (most recent)
- Load last 50 messages
- Lazy load older on scroll up
```

### New Message (Theirs)
```
If scrolled to bottom:
  - Auto-scroll to new message

If scrolled up:
  - Show "New message" chip
  - Tap to scroll down
```

### New Message (Yours)
```
- Always scroll to bottom
- Smooth animation
```

---

## Real-time Features

### Message Sync
```
- Firestore listener on messages subcollection
- New messages appear instantly
- Read status updates in real-time
```

### Typing Indicator
```
- Show when other user is typing
- 3 second timeout
- Debounced updates
```

### Online Status
```
- Update in app bar
- Based on lastActiveAt field
```

---

## Animations

### New Message
```
Entry:
  - Slide up + fade in
  - Duration: 200ms
  - Sent messages: slide from right
  - Received messages: slide from left
```

### Send Button
```
On tap:
  - Scale to 0.9, then back
  - Icon transforms/rotates
  - Haptic feedback
```

### Typing Indicator
```
Dots:
  - Sequential bounce (y-axis)
  - 150ms between each
  - Loop continuously
```

---

## Accessibility
- Messages announced with sender and time
- Read receipts announced
- Input field properly labeled
- Send button state announced
- New message notifications
