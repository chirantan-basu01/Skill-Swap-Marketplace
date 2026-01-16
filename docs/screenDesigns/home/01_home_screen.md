# Home Screen

## Overview
The main discovery hub where users find skill partners. Features personalized recommendations, perfect matches, and category browsing.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ ┌──────┐                      [🔔]  │
│ │Avatar│  Hi, John!                 │
│ └──────┘  Ready to swap?            │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐    │
│  │ 🔍 Search skills or people  │    │
│  └─────────────────────────────┘    │
│                                     │
│  ⚡ Perfect Matches            See All│
│  ┌─────┐ ┌─────┐ ┌─────┐           │
│  │     │ │     │ │     │           │
│  │User │ │User │ │User │  →        │
│  │Card │ │Card │ │Card │           │
│  │     │ │     │ │     │           │
│  └─────┘ └─────┘ └─────┘           │
│                                     │
│  🎯 Recommended for You       See All│
│  ┌───────────────────────────────┐  │
│  │  User Card (Full Width)       │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │  User Card (Full Width)       │  │
│  └───────────────────────────────┘  │
│                                     │
│  📚 Browse by Category              │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐       │
│  │💻  │ │🎨  │ │🎵  │ │🌍  │       │
│  │Tech│ │Crea│ │Musi│ │Lang│       │
│  └────┘ └────┘ └────┘ └────┘       │
│                                     │
│  🕐 Recently Active           See All│
│  ┌───────────────────────────────┐  │
│  │  User Card                    │  │
│  └───────────────────────────────┘  │
│                                     │
├─────────────────────────────────────┤
│  [🏠]   [🔄]   [💬]   [💰]   [👤]  │
│  Home  Matches  Chat  Wallet Profile │
└─────────────────────────────────────┘
```

---

## Components

### Header Section
```
Layout:
  - Height: 80px (excluding status bar)
  - Background: White
  - Padding: 20px horizontal

Avatar:
  - Size: 48px (MD)
  - Position: Left
  - Tap: Navigate to Profile

Greeting:
  - Primary: "Hi, [First Name]!"
    - Style: H3, Gray 900
  - Secondary: "Ready to swap?"
    - Style: Body M, Gray 500

Notification Bell:
  - Position: Top right
  - Size: 44px touch target
  - Icon: bell (24px)
  - Badge: Red dot if unread (8px, top-right)
  - Tap: Navigate to Notifications
```

### Search Bar
```
Style:          Search Input (pill)
Placeholder:    "Search skills or people..."
Height:         48px
Margin:         16px horizontal, 12px top
Background:     Gray 100

Behavior:
  - Tap: Navigate to Search Screen
  - Not an actual input on home (just a button)
```

### Section Header
```
Layout:
  - Flex row, space-between
  - Margin: 24px top, 20px horizontal

Left Side:
  - Icon: Emoji (20px)
  - Title: H4, Gray 900
  - 8px gap between icon and title

Right Side:
  - Text: "See All"
  - Style: Body M, Primary Blue
  - Tap: Navigate to full list
```

---

## Perfect Matches Section

### Concept
Users who teach what you want to learn AND want what you teach.

### Horizontal Scroll Cards
```
Container:
  - Horizontal scroll
  - Padding: 20px left, 20px right
  - Gap: 16px between cards
  - Snap: card edges

Match Card (Compact):
  - Width: 160px
  - Height: 200px
  - Background: White
  - Border Radius: 16px
  - Shadow: shadow-sm
  - Padding: 16px

  Layout:
  ┌─────────────────┐
  │   ┌─────────┐   │
  │   │ Avatar  │   │
  │   │  56px   │   │
  │   └─────────┘   │
  │   ⚡ Perfect    │
  │                 │
  │   Sarah M.      │
  │   ★ 4.8 (23)    │
  │                 │
  │ ┌─────┐ ┌─────┐ │
  │ │Teach│ │Wants│ │
  │ │Skill│ │Skill│ │
  │ └─────┘ └─────┘ │
  └─────────────────┘

  Perfect Match Badge:
    - Text: "⚡ Perfect"
    - Background: Linear gradient (Primary → Secondary)
    - Text: White, Caption, Bold
    - Border Radius: full
    - Position: Below avatar, centered

  Name:
    - Style: Body M, SemiBold, Gray 900
    - Truncate with ellipsis

  Rating:
    - Star icon (filled, Warning) + "4.8" + "(23)"
    - Style: Body S, Gray 600

  Skill Pills:
    - Two pills side by side
    - Teach: Primary Surface bg, truncated skill name
    - Wants: Secondary Light bg, truncated skill name
    - Font: Caption

Tap: Navigate to User Profile View
```

### Empty State (No Perfect Matches)
```
┌─────────────────────────────────────┐
│  ⚡ Perfect Matches                  │
│  ┌───────────────────────────────┐  │
│  │     😔                        │  │
│  │     No perfect matches yet    │  │
│  │     Try adding more skills    │  │
│  │     [Update Your Skills]      │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘

Card:
  - Width: 280px
  - Single card in scroll area
  - Centered content
```

---

## Recommended For You Section

### Concept
Users calculated by matching algorithm (partial matches, high ratings, recent activity).

### Full Width Cards
```
User Card (Full):
  - Width: Full (- 40px margin)
  - Height: Auto (~120px)
  - Background: White
  - Border: 1px Gray 200
  - Border Radius: 16px
  - Shadow: shadow-xs
  - Padding: 16px
  - Margin: 12px vertical

Layout:
┌───────────────────────────────────────┐
│ ┌────┐                                │
│ │Ava │  John Doe           ★ 4.9 (45)│
│ │tar │  Teaches: Guitar, Piano        │
│ │48px│  Wants: Python, JavaScript     │
│ └────┘                                │
│                                       │
│ ┌──────┐ ┌──────┐ ┌──────┐           │
│ │Guitar│ │Piano │ │+2    │   [Match] │
│ └──────┘ └──────┘ └──────┘    85%    │
└───────────────────────────────────────┘

Avatar:
  - Size: 48px
  - Online indicator if active

Info Section:
  - Name: Body L, SemiBold, Gray 900
  - Rating: inline, star + number

  - "Teaches:" Body S, Gray 500
  - Skill names: Body S, Gray 700

  - "Wants:" Body S, Gray 500
  - Skill names: Body S, Gray 700

Skill Chips (Bottom):
  - Their skills that match your wants
  - Highlighted in Primary
  - "+X" chip if more than 3

Match Percentage:
  - Position: Right side
  - Circle badge: Primary Blue bg
  - Text: "85%" (H4, White)
  - Label below: "Match" (Caption, Gray 500)
```

---

## Browse by Category

### Category Grid
```
Layout:
  - Horizontal scroll
  - 4+ visible, scroll for more
  - Gap: 12px
  - Padding: 20px horizontal

Category Tile:
  - Size: 72px × 84px
  - Background: Gray 50
  - Border Radius: 12px
  - Padding: 12px

  Icon:
    - Emoji, 28px
    - Centered

  Label:
    - Style: Caption, Gray 700
    - Below icon, 8px margin
    - Centered, truncate if needed

  Tap: Navigate to Category Screen

Categories:
  1. 💻 Technology
  2. 🎨 Creative
  3. 🎵 Music
  4. 🌍 Languages
  5. 💼 Business
  6. 🧘 Lifestyle
  7. 📚 Academic
```

---

## Recently Active Section

### Concept
Users who were active in the last 24-48 hours, sorted by match relevance.

### Cards
```
Same as "Recommended" cards but with:
  - Green online dot on avatar
  - "Active now" or "Active 2h ago" label
  - No match percentage (or lower emphasis)
```

---

## States

### Loading State
```
- Header: Visible immediately
- Search bar: Visible
- Sections: Shimmer placeholders

Shimmer Cards:
  - Same dimensions as real cards
  - Animated gradient shimmer
  - 3 cards per horizontal section
  - 2 cards for vertical sections
```

### Empty State (New User, No Data)
```
┌─────────────────────────────────────┐
│                                     │
│         🌟                          │
│                                     │
│   Welcome to Skill Swap!            │
│                                     │
│   We're finding the best matches    │
│   for you. Check back soon!         │
│                                     │
│   In the meantime, explore          │
│   categories below.                 │
│                                     │
└─────────────────────────────────────┘

Show categories even when no users match
```

### Error State
```
┌─────────────────────────────────────┐
│                                     │
│         😕                          │
│                                     │
│   Unable to load recommendations    │
│                                     │
│   [Try Again]                       │
│                                     │
└─────────────────────────────────────┘
```

---

## Pull to Refresh
```
Behavior:
  - Pull down from top
  - Show refresh indicator
  - Reload all sections

Indicator:
  - Primary Blue spinner
  - Position: Below header
```

---

## Bottom Navigation

### Layout
```
Height:         64px + safe area
Background:     White
Border Top:     1px Gray 200
Shadow:         shadow-lg (inverted, subtle)

Items: 5 tabs
  1. Home (house icon)
  2. Matches (repeat/swap icon)
  3. Chat (message-circle icon)
  4. Wallet (wallet icon)
  5. Profile (user icon)

Item Style:
  - Icon: 24px
  - Label: Caption (11px)
  - Gap: 4px between icon and label

  Active:
    - Color: Primary Blue
    - Icon might be filled variant

  Inactive:
    - Color: Gray 400

Badge:
  - Chat tab: Unread count (red circle, white number)
  - Matches tab: Pending count (if any)
```

---

## Animations

### Page Load
```
Sections stagger in:
  - Header: Immediate
  - Search: 50ms delay
  - Each section: 100ms stagger
  - Cards within sections: 50ms stagger
```

### Card Interactions
```
Tap:
  - Scale to 0.98
  - Duration: 100ms
  - Spring back

Horizontal Scroll:
  - Smooth momentum scrolling
  - Snap to card edges
```

### Refresh
```
Pull indicator:
  - Elastic spring effect
  - Spinner appears at threshold
  - Content bounces back
```

---

## Accessibility
- All sections have proper headings
- Cards are tappable with clear labels
- "See All" links have expanded hit areas
- Horizontal scrolls can be navigated with switches
- Screen reader announces section names and card count
