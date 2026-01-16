# Active Session Screen

## Overview
Full-screen interface during an active swap session. Shows timer, video link access, and session controls.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│           Session in Progress       │
│ [End Session]                       │
├─────────────────────────────────────┤
│                                     │
│                                     │
│           ┌─────────┐               │
│           │         │               │
│           │  Sarah  │               │
│           │  Avatar │               │
│           │  80px   │               │
│           └─────────┘               │
│                                     │
│        Session with Sarah           │
│                                     │
│        🎸 Learning Guitar           │
│                                     │
│                                     │
│           ┌─────────┐               │
│           │  23:45  │               │
│           │ elapsed │               │
│           └─────────┘               │
│                                     │
│        ━━━━━━━━━━━░░░░░░░           │
│        23:45 / 60:00                │
│                                     │
│                                     │
│   ┌─────────────────────────────┐   │
│   │     📹 Join Video Call      │   │
│   └─────────────────────────────┘   │
│                                     │
│   ┌─────────────────────────────┐   │
│   │     💬 Open Chat            │   │
│   └─────────────────────────────┘   │
│                                     │
│                                     │
│         ⚠️ Report an Issue          │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### Header
```
Background:     Primary Blue (gradient)
Height:         Auto (content based)
Padding:        20px

Title:
  - Text: "Session in Progress"
  - Style: Body L, White
  - Centered

End Session Button:
  - Position: Top left
  - Style: Text button
  - Text: "End Session"
  - Color: White with opacity

Subtle pulse animation on header to indicate active session
```

### Session Partner Section
```
Avatar:
  - Size: 80px (XL)
  - Border: 4px White
  - Shadow: shadow-lg
  - Centered
  - Online indicator: Green dot (larger, 12px)

Partner Name:
  - Text: "Session with [Name]"
  - Style: H3, Gray 900
  - Margin: 16px below avatar

Skill Being Learned:
  - Emoji + "Learning [Skill]"
  - Style: Body L, Gray 600
  - Margin: 8px below name
```

### Timer Display
```
Primary Timer:
  - Container: Circular or rounded rectangle
  - Background: Gray 50
  - Border: 2px Primary Blue (animated dash)
  - Size: 160px × 160px
  - Border Radius: full

  Time Display:
    - Format: "MM:SS" or "H:MM:SS" (if > 1hr)
    - Style: Display (48px), Gray 900, Bold
    - Label below: "elapsed"
    - Style: Body S, Gray 500

Progress Bar:
  - Below timer circle
  - Width: Full (- 40px margin)
  - Height: 8px
  - Background: Gray 200
  - Fill: Primary Blue
  - Border Radius: 4px
  - Animation: Smooth fill as time progresses

Time Labels:
  - Left: Current elapsed
  - Right: Total session time
  - Style: Body S, Gray 500
  - Format: "23:45 / 60:00"
```

### Video Call Button
```
Text:           "📹 Join Video Call"
Style:          Primary Button, full width
Size:           Large (56px height)
Margin:         40px top, 20px horizontal

Action:
  - Opens video link (Google Meet/Zoom)
  - Uses url_launcher
  - Opens in external browser/app
```

### Chat Button
```
Text:           "💬 Open Chat"
Style:          Secondary Button, full width
Size:           Large (56px height)
Margin:         12px top

Action:
  - Navigate to chat
  - Session stays active in background
```

### Report Issue Link
```
Text:           "⚠️ Report an Issue"
Style:          Text button, Error Red (muted)
Position:       Bottom, centered
Margin:         24px top

Action:
  - Opens report flow
  - For no-shows, inappropriate behavior, etc.
```

---

## Session States

### Waiting for Partner
```
Before both users tap "Start Session":

┌─────────────────────────────────────┐
│                                     │
│           ┌─────────┐               │
│           │  Sarah  │               │
│           │  Avatar │               │
│           └─────────┘               │
│                                     │
│        Waiting for Sarah...         │
│                                     │
│           ⏳                        │
│                                     │
│        You're ready! Waiting for    │
│        Sarah to start the session.  │
│                                     │
│        ━━━━━━░░░░░░░░░░░░           │
│        Grace period: 12:34          │
│                                     │
│   ┌─────────────────────────────┐   │
│   │     📹 Join Video Call      │   │
│   └─────────────────────────────┘   │
│                                     │
│         Cancel Session              │
│                                     │
└─────────────────────────────────────┘

Grace Period:
  - 15 minutes countdown
  - After grace period expires: "Mark as No-Show"
```

### Both Started (Active)
```
- Timer running
- Full controls visible
- Header pulsing/animated
```

### Session Ending Soon
```
When 5 minutes remaining:

Banner:
┌─────────────────────────────────────┐
│ ⏰ Session ends in 5 minutes        │
└─────────────────────────────────────┘

Position: Below header
Background: Warning Light
Text: Warning Dark
Dismissible
```

### Session Time Complete
```
When scheduled time reached:

Modal:
┌─────────────────────────────────────┐
│                                     │
│         ⏰                          │
│                                     │
│   Time's Up!                        │
│                                     │
│   Your 1 hour session has ended.    │
│   Ready to wrap up?                 │
│                                     │
│   ┌─────────────────────────────┐   │
│   │    End & Rate Session       │   │
│   └─────────────────────────────┘   │
│                                     │
│       Continue a bit longer         │
│                                     │
└─────────────────────────────────────┘

Options:
  - End session: Go to rating
  - Continue: Dismiss modal, timer keeps going
```

---

## End Session Flow

### Confirmation
```
When tapping "End Session":

Dialog:
┌─────────────────────────────────────┐
│                                     │
│   End this session?                 │
│                                     │
│   Session duration: 23:45           │
│                                     │
│   You'll both be asked to rate      │
│   the session afterward.            │
│                                     │
│   [Keep Going]      [End Session]   │
│                                     │
└─────────────────────────────────────┘
```

### Session Ended
```
1. Both users see "Session Ended" screen
2. Navigate to Rating Screen
3. Credits held until both rate (or 48h timeout)
```

---

## No-Show Handling

### Grace Period Expired
```
If partner hasn't started after 15 minutes:

┌─────────────────────────────────────┐
│                                     │
│         😕                          │
│                                     │
│   Sarah hasn't joined               │
│                                     │
│   They may have a connection issue. │
│   You can wait, or mark as no-show. │
│                                     │
│   ┌─────────────────────────────┐   │
│   │    Mark as No-Show          │   │
│   └─────────────────────────────┘   │
│                                     │
│       Wait a bit longer             │
│                                     │
└─────────────────────────────────────┘

Mark as No-Show:
  - Logs the no-show
  - No credits exchanged
  - Partner notified
  - Affects their reliability score
```

---

## Timer Logic

### Start Time
```
Timer starts when:
  - Both users have tapped "Start Session"
  - Recorded as actualStartTime
```

### Display
```
Shows elapsed time since both started
Updates every second
Persists if app backgrounded
```

### Background Handling
```
When app goes to background:
  - Timer continues in backend
  - Local notification: "Your session is active"
  - On return: Timer shows correct time
```

---

## Animations

### Timer
```
- Seconds tick: subtle pulse
- Progress bar: smooth continuous fill
- Circle border: animated dashes rotating
```

### Waiting State
```
- Pulsing avatar
- Animated dots: "Waiting..."
- Subtle bounce on status text
```

### Session Active
```
- Header has subtle gradient animation
- Green "live" dot pulses
```

---

## Sound & Haptics

### Notifications
```
- Session start: Subtle chime
- 5 min warning: Gentle alert
- Session end: Completion sound
- No-show alert: Warning sound
```

### Haptics
```
- Timer reaching milestones: Light haptic
- Session end: Success haptic
- Button taps: Standard haptic
```

---

## Accessibility
- Timer announced periodically (every 5 min)
- Status changes announced
- Buttons have clear labels
- Progress bar has accessible value
- Emergency actions clearly accessible
