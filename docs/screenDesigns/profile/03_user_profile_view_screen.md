# User Profile View Screen

## Overview
View another user's profile. Shows their skills, ratings, reviews, and provides actions to request swap or message.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [←]                           [⋮]  │
├─────────────────────────────────────┤
│                                     │
│           ┌─────────┐               │
│           │         │               │
│           │  Sarah  │               │
│           │  Photo  │               │
│           │   80px  │               │
│           └─────────┘               │
│                                     │
│         Sarah Martinez              │
│           ● Active now              │
│                                     │
│   ┌─────────┐ ┌─────────┐ ┌──────┐  │
│   │   12    │ │  15hrs  │ │ 4.9  │  │
│   │ swaps   │ │exchanged│ │★★★★★ │  │
│   └─────────┘ └─────────┘ └──────┘  │
│                                     │
│  ┌─────────────────────────────┐    │
│  │       Request Swap          │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │       Send Message          │    │
│  └─────────────────────────────┘    │
│                                     │
│  ─────────────────────────────────  │
│                                     │
│  ⚡ 85% Match                       │
│  They teach what you want!          │
│  You teach what they want!          │
│                                     │
│  About                              │
│  Music teacher with 10 years of     │
│  experience. Love helping beginners │
│  discover their passion for music.  │
│                                     │
│  Skills They Teach (2)              │
│  ┌──────────────────────────────┐   │
│  │ 🎸 Guitar              Expert│   │
│  │ "I teach acoustic and        │   │
│  │  electric guitar basics..."  │   │
│  └──────────────────────────────┘   │
│  ┌──────────────────────────────┐   │
│  │ 🎹 Piano         Intermediate│   │
│  │ "Classical and pop piano..." │   │
│  └──────────────────────────────┘   │
│                                     │
│  Skills They Want (2)               │
│  ┌──────────┐ ┌──────────┐          │
│  │💻 Python │ │🇪🇸Spanish │          │
│  └──────────┘ └──────────┘          │
│                                     │
│  Availability                       │
│  🌅 Morning • ☀️ Afternoon          │
│  🌍 EST (3 hours behind you)        │
│                                     │
│  Reviews (8)                See All │
│  ┌───────────────────────────────┐  │
│  │ ★★★★★                         │  │
│  │ "Sarah is an amazing teacher! │  │
│  │  Very patient and explains    │  │
│  │  everything clearly."         │  │
│  │                               │  │
│  │ John D. • Jan 10              │  │
│  └───────────────────────────────┘  │
│                                     │
│  Rating Tags                        │
│  ┌────────┐ ┌────────┐ ┌────────┐   │
│  │ Great  │ │Patient │ │Punctual│   │
│  │Teacher8│ │   6    │ │   5    │   │
│  └────────┘ └────────┘ └────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### App Bar
```
Background:     Transparent → White on scroll
Height:         56px

Back Button:
  - Icon: arrow-left
  - Position: Left
  - Tap: Go back

Menu Button:
  - Icon: more-vertical (⋮)
  - Position: Right
  - Tap: Opens action menu

Action Menu:
  ┌─────────────────────┐
  │ Share Profile       │
  │ Report User         │
  │ Block User          │
  └─────────────────────┘
```

### Profile Header
```
Avatar:
  - Size: 80px
  - Border: 3px White
  - Shadow: shadow-md
  - Centered

Name:
  - Style: H2, Gray 900
  - Centered

Online Status:
  - If active: "● Active now" (green dot + text)
  - If recent: "Last seen 2 hours ago"
  - If inactive: "Last seen Jan 10"
  - Style: Body S, Gray 500 (or Success for active)
```

### Stats Row
```
3 columns, equal width:

1. Swaps Completed
   - Value: Number
   - Label: "swaps"

2. Hours Exchanged
   - Value: Number + "hrs"
   - Label: "exchanged"

3. Rating
   - Value: Number (4.9)
   - Stars visualization
   - Style: Star icons filled
```

### Action Buttons
```
Primary: "Request Swap"
  - Style: Primary Button, full width
  - Tap: Navigate to Swap Request Screen

Secondary: "Send Message"
  - Style: Secondary Button, full width
  - Margin: 12px top
  - Tap: Open/create chat

If already in a swap:
  - Primary changes to "View Swap"
  - Secondary: "Message"
```

### Match Indicator
```
Container:
  - Background: Primary Surface (if good match) or Gray 50
  - Border Radius: 12px
  - Padding: 16px
  - Margin: 16px horizontal

For Perfect Match:
  ┌───────────────────────────────────┐
  │ ⚡ 85% Match                      │
  │                                   │
  │ ✓ They teach what you want!       │
  │ ✓ You teach what they want!       │
  │                                   │
  │ This is a perfect swap match!     │
  └───────────────────────────────────┘

  - Badge: "⚡ XX% Match" (H4, Primary Blue)
  - Check items: Body S, Gray 700
  - Highlighted when bidirectional match

For Partial Match:
  - Shows which direction matches
  - Less prominent styling
```

### About Section
```
Header: "About" (H4, Gray 900)
Content:
  - User's bio
  - Style: Body M, Gray 600
  - Full text (expandable if very long)
```

### Skills They Teach
```
Header: "Skills They Teach (X)"

Skill Card (Detailed):
  - Full width
  - Background: White
  - Border: 1px Gray 200
  - Border Radius: 12px
  - Padding: 16px
  - Margin: 8px vertical

  Layout:
  ┌───────────────────────────────────┐
  │ 🎸 Guitar                   Expert│
  │                                   │
  │ "I teach acoustic and electric    │
  │  guitar for all skill levels..."  │
  │                                   │
  │         [Request This Skill]      │
  └───────────────────────────────────┘

  Header Row:
    - Emoji + Name (Body L, SemiBold)
    - Level badge (right aligned)

  Description:
    - Style: Body S, Gray 600
    - Quoted appearance
    - Max 3 lines

  Quick Action (Optional):
    - "Request This Skill"
    - Text button
    - Pre-fills swap request

  Highlight:
    - If this skill matches your wants
    - Border: Primary Blue
    - Label: "You want this!"
```

### Skills They Want
```
Header: "Skills They Want (X)"

Skill Chip Grid:
  - Simpler display (chips)
  - 2-3 per row

  Chip:
    - Emoji + Name
    - Highlight if you teach it
    - "You teach this!" indicator
```

### Availability Section
```
Time Preferences:
  - Emoji + name for each
  - "🌅 Morning • ☀️ Afternoon"

Timezone:
  - "🌍 [Timezone]"
  - Relative to viewer: "(3 hours behind you)"
  - Helpful for scheduling
```

### Reviews Section
```
Header:
  - "Reviews (X)"
  - "See All" link

Review Card:
  - Background: Gray 50
  - Border Radius: 12px
  - Padding: 16px

  Content:
    - Stars (5 filled/empty)
    - Review text (full or truncated)
    - Reviewer name + date
```

### Rating Tags
```
Header: "Rating Tags"

Tag Chips:
  - Show tags with count
  - "Great Teacher (8)"
  - Sorted by frequency
  - Top 6 shown

Style:
  - Background: Primary Surface
  - Text: Primary Blue
  - Count in badge
```

---

## States

### Loading
```
- Avatar shimmer
- Content shimmer
- Action buttons disabled
```

### Own Profile
```
If viewing own profile:
  - Hide action buttons
  - Show "Edit Profile" instead
  - Or redirect to Profile screen
```

### Blocked User
```
If user is blocked:
  - Minimal info shown
  - "You have blocked this user"
  - "Unblock" option
```

### No Mutual Skills
```
If no match at all:
  - Match indicator shows low %
  - Or "No skill overlap" message
  - Still allow messaging
```

---

## Animations

### Entry
```
- Slide from right
- Header fades in
- Stats count up
- Sections stagger in
```

### Match Indicator
```
If perfect match:
  - Celebratory animation
  - Sparkle effect on badge
```

### Action Buttons
```
- Scale on tap
- Loading state for actions
```

---

## Scroll Behavior

### Parallax Header (Optional)
```
- Avatar shrinks on scroll
- Moves to app bar
- Name becomes title
```

---

## Accessibility
- Profile information announced completely
- Action buttons clearly labeled
- Match status explained
- Reviews navigable
- Skills have full context
