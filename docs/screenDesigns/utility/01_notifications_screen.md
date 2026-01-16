# Notifications Screen

## Overview
Displays all app notifications in chronological order. Shows swap requests, messages, session reminders, and system notifications.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [←]       Notifications    [Clear]  │
├─────────────────────────────────────┤
│                                     │
│  Today                              │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                    NEW │  │
│  │ │ 🔔 │ New swap request       │  │
│  │ │    │ Sarah wants to learn   │  │
│  │ └────┘ Python from you        │  │
│  │        2 hours ago            │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                        │  │
│  │ │ 💬 │ New message from John  │  │
│  │ │    │ "Sounds great! See you │  │
│  │ └────┘ tomorrow"              │  │
│  │        4 hours ago            │  │
│  └───────────────────────────────┘  │
│                                     │
│  Yesterday                          │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                        │  │
│  │ │ ⏰ │ Session reminder        │  │
│  │ │    │ Guitar session with    │  │
│  │ └────┘ Sarah in 1 hour        │  │
│  │        5:00 PM                │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                        │  │
│  │ │ ✓  │ Swap completed         │  │
│  │ │    │ You completed a swap   │  │
│  │ └────┘ with Mike. +1 credit   │  │
│  │        3:30 PM                │  │
│  └───────────────────────────────┘  │
│                                     │
│  This Week                          │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                        │  │
│  │ │ ⭐ │ New review received     │  │
│  │ │    │ John left you a 5-star │  │
│  │ └────┘ review                 │  │
│  │        Jan 12                 │  │
│  └───────────────────────────────┘  │
│                                     │
│              Load More              │
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
  - Text: "Notifications"
  - Style: H4, Gray 900
  - Center

Clear All:
  - Text: "Clear"
  - Style: Text Button, Gray 500
  - Position: Right
  - Tap: Confirmation → Clear all
  - Hidden if no notifications
```

### Date Group Header
```
Text:           "Today", "Yesterday", "This Week", or date
Style:          Body S, SemiBold, Gray 500
Margin:         20px horizontal, 16px top, 8px bottom
```

### Notification Item
```
Container:
  - Height: Auto (~80px)
  - Padding: 16px 20px
  - Background: White
  - Border Bottom: 1px Gray 100

  Unread State:
    - Background: Primary Surface (very subtle)
    - Left border: 3px Primary Blue

Layout:
┌───────────────────────────────────────┐
│ [Icon]  Title                    NEW  │
│         Description/Preview           │
│         Timestamp                     │
└───────────────────────────────────────┘

Icon Container:
  - Size: 40px circle
  - Background: Varies by type
  - Icon: 20px, centered

  Types:
    - Swap Request: 🔄 Primary Blue bg
    - Message: 💬 Secondary Teal bg
    - Reminder: ⏰ Warning bg
    - Completed: ✓ Success bg
    - Review: ⭐ Warning bg
    - System: ℹ️ Gray bg

Title:
  - Style: Body M, SemiBold, Gray 900
  - Max 1 line

Description:
  - Style: Body S, Gray 600
  - Max 2 lines, truncate
  - Preview of content

Timestamp:
  - Style: Caption, Gray 400
  - Relative: "2 hours ago", "5:00 PM", "Jan 12"

NEW Badge:
  - Only for unread
  - Background: Primary Blue
  - Text: "NEW" (White, Caption, Bold)
  - Position: Top right

Tap Action:
  - Navigate to relevant screen
  - Mark as read
```

---

## Notification Types

### Swap Request Received
```
Icon:       🔄 (swap arrows)
Title:      "New swap request"
Desc:       "[Name] wants to learn [Skill] from you"
Action:     Navigate to Matches (Pending)
```

### Swap Request Accepted
```
Icon:       ✓ (checkmark)
Title:      "Request accepted!"
Desc:       "[Name] accepted your swap request"
Action:     Navigate to Chat with user
```

### Swap Request Declined
```
Icon:       ✗ (x mark)
Title:      "Request declined"
Desc:       "[Name] declined your swap request"
Action:     Navigate to Matches (Pending)
```

### New Message
```
Icon:       💬 (message bubble)
Title:      "New message from [Name]"
Desc:       "[Message preview...]"
Action:     Navigate to Chat
```

### Session Scheduled
```
Icon:       📅 (calendar)
Title:      "Session scheduled"
Desc:       "[Skill] session with [Name] on [Date]"
Action:     Navigate to Matches (Active)
```

### Session Reminder
```
Icon:       ⏰ (alarm)
Title:      "Session reminder"
Desc:       "[Skill] session with [Name] in [Time]"
Action:     Navigate to Active Session
```

### Session Started
```
Icon:       ▶️ (play)
Title:      "Session starting"
Desc:       "[Name] is ready to start your session"
Action:     Navigate to Active Session
```

### Swap Completed
```
Icon:       🎉 (celebration)
Title:      "Swap completed!"
Desc:       "You completed a swap with [Name]. [+/-X] credits"
Action:     Navigate to completed swap
```

### New Review Received
```
Icon:       ⭐ (star)
Title:      "New review received"
Desc:       "[Name] left you a [X]-star review"
Action:     Navigate to Profile (Reviews)
```

### Rating Reminder
```
Icon:       📝 (edit)
Title:      "Don't forget to rate"
Desc:       "Rate your session with [Name]"
Action:     Navigate to Rating Screen
```

### System Notification
```
Icon:       ℹ️ (info)
Title:      Varies
Desc:       System message
Action:     Varies or none
```

---

## States

### Loading
```
- Shimmer placeholders
- 5-6 items
```

### Empty State
```
┌─────────────────────────────────────┐
│                                     │
│         🔔                          │
│                                     │
│   No notifications yet              │
│                                     │
│   When you get swap requests,       │
│   messages, or updates, they'll     │
│   appear here.                      │
│                                     │
└─────────────────────────────────────┘
```

### All Read
```
- No "NEW" badges
- No highlighted backgrounds
- Clear button hidden or disabled
```

---

## Actions

### Mark as Read
```
On tap:
  - Navigate to target
  - Mark notification as read
  - Remove NEW badge
  - Remove highlight

On screen enter:
  - Mark visible as read after 2 seconds
  - Or mark all as read
```

### Clear All
```
Confirmation:
┌─────────────────────────────────────┐
│                                     │
│   Clear all notifications?          │
│                                     │
│   This will remove all your         │
│   notification history.             │
│                                     │
│   [Cancel]            [Clear All]   │
│                                     │
└─────────────────────────────────────┘

On confirm:
  - Delete all notifications
  - Show empty state
```

### Swipe to Delete (Optional)
```
Swipe left:
  - Reveal delete button
  - Red background
  - Trash icon

Confirm:
  - Delete single notification
  - Animate out
```

---

## Pull to Refresh
```
- Standard refresh pattern
- Reloads notifications
```

---

## Infinite Scroll
```
- Load 20 notifications initially
- "Load More" button at bottom
- Or auto-load on scroll
```

---

## Badge Updates
```
When notifications change:
  - App icon badge updates
  - Tab bar badge updates
  - Real-time via listeners
```

---

## Animations

### Entry
```
- Items stagger in
- 30ms delay between each
```

### Mark as Read
```
- Background fades to white
- Badge fades out
- Border fades out
```

### Delete
```
- Swipe reveals red
- On confirm: slide out left
- Other items slide up
```

---

## Accessibility
- Each notification has complete label
- Type announced (message, request, etc.)
- Unread status announced
- Timestamps announced
- Actions clearly labeled
