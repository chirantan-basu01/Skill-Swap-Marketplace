# Chat List Screen

## Overview
Lists all active conversations associated with swaps. Shows unread counts and last message preview.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│            Messages                 │
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                     •2 │  │
│  │ │Ava │ Sarah Martinez         │  │
│  │ │ ● │ 🎸 Guitar swap          │  │
│  │ └────┘ Thanks! See you tmrw   │  │
│  │        2:34 PM                │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                        │  │
│  │ │Ava │ John Doe               │  │
│  │ │    │ 💻 Python swap         │  │
│  │ └────┘ You: Sounds good!      │  │
│  │        Yesterday              │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐              Completed │  │
│  │ │Ava │ Mike Wilson            │  │
│  │ │    │ 🇪🇸 Spanish swap        │  │
│  │ └────┘ Great session!         │  │
│  │        Jan 10                 │  │
│  └───────────────────────────────┘  │
│                                     │
│         No more conversations       │
│                                     │
├─────────────────────────────────────┤
│  [🏠]   [🔄]   [💬]   [💰]   [👤]  │
│  Home  Matches  Chat  Wallet Profile │
└─────────────────────────────────────┘
```

---

## Components

### App Bar
```
Title:          "Messages"
Style:          H3, Gray 900, centered
Height:         56px
Background:     White

No back button (main navigation)
```

### Chat List Item
```
Container:
  - Height: 80px
  - Padding: 16px horizontal
  - Background: White
  - Border Bottom: 1px Gray 100

  Unread State:
    - Background: Primary Surface (very subtle)

Layout:
┌───────────────────────────────────────┐
│ ┌────┐                          Badge │
│ │Ava │  Name                          │
│ │ ●  │  Swap context                  │
│ └────┘  Last message preview          │
│         Timestamp                     │
└───────────────────────────────────────┘

Avatar:
  - Size: 48px
  - Position: Left
  - Online indicator: Green dot (8px) if recently active
  - Margin right: 12px

Content:
  Name:
    - Style: Body L, SemiBold, Gray 900
    - Truncate if too long

  Swap Context:
    - Style: Body S, Gray 500
    - Format: "🎸 Guitar swap" or "[Skill] swap"

  Last Message:
    - Style: Body M, Gray 600
    - Max 1 line, truncate with "..."
    - If from you: "You: [message]"
    - If image: "📷 Photo"
    - If system: "[System message]"

  Timestamp:
    - Style: Body S, Gray 400
    - Position: Below last message
    - Format: "2:34 PM", "Yesterday", "Jan 10"

Unread Badge:
  - Position: Top right
  - Background: Error Red
  - Size: 20px × 20px (min)
  - Text: White, Caption, Bold
  - Shows count (max "9+")
  - Only visible if unread > 0

Completed Badge:
  - For completed swaps
  - Style: Chip, Gray 200 bg, Gray 600 text
  - Text: "Completed"
  - Position: Top right (instead of unread)
```

### Swipe Actions (Optional)
```
Swipe Right:
  - Archive/Hide conversation
  - Background: Gray 500
  - Icon: archive

Swipe Left:
  - Mute notifications
  - Background: Warning
  - Icon: bell-off
```

---

## Sections (Optional Grouping)

### Active Swaps First
```
"Active Conversations"
  - Swaps in progress or scheduled
  - Highlighted

"Past Conversations"
  - Completed swaps
  - Slightly muted appearance
```

---

## States

### Loading
```
- Shimmer placeholders
- 5-6 items
- Avatar, lines for text
```

### Empty State
```
┌─────────────────────────────────────┐
│                                     │
│         💬                          │
│                                     │
│   No conversations yet              │
│                                     │
│   When you start a swap, you'll     │
│   be able to chat with your         │
│   partner here.                     │
│                                     │
│   [Find Someone to Swap With]       │
│                                     │
└─────────────────────────────────────┘
```

### Error State
```
- Error message
- Retry button
- Pull to refresh also works
```

---

## Real-time Updates

### New Message
```
When new message arrives:
  1. Chat moves to top of list
  2. Preview updates
  3. Unread badge appears/increments
  4. Subtle highlight animation
```

### Read Status
```
When chat is opened:
  - Unread badge disappears
  - Background returns to white
```

---

## Sorting

### Default Order
```
1. Most recent message first
2. Unread conversations prioritized (optional)
3. Active swaps before completed
```

---

## Animations

### Entry
```
- List items stagger in
- 30ms delay between each
- Fade + slide from right
```

### New Message
```
- Item animates to top
- Duration: 250ms
- Other items slide down
```

### Tap
```
- Ripple effect
- Navigate to chat detail
```

### Swipe Actions
```
- Smooth reveal
- Snap back if not completed
- Confirm animation if completed
```

---

## Navigation

### On Item Tap
```
Navigate to Chat Detail Screen:
  - Pass chat ID
  - Pass swap context
  - Mark as read
```

---

## Badge in Tab Bar
```
Bottom nav "Chat" icon:
  - Shows total unread count
  - Red badge with number
  - Updates in real-time
```

---

## Accessibility
- List items have complete accessible labels
- Unread count announced
- Timestamps announced
- Swipe actions have alternative (long press menu)
