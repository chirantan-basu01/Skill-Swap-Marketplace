# Profile Screen (Own Profile)

## Overview
User's own profile view showing their complete information, skills, ratings, and settings access. Serves as the account hub.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [⚙️]         Profile                │
├─────────────────────────────────────┤
│                                     │
│           ┌─────────┐               │
│           │         │               │
│           │  Your   │               │
│           │  Photo  │               │
│           │  80px   │               │
│           └─────────┘               │
│                                     │
│           John Doe                  │
│       john.doe@email.com            │
│                                     │
│   ┌─────────┐ ┌─────────┐ ┌──────┐  │
│   │  2.5    │ │   12    │ │ 4.9  │  │
│   │credits  │ │ swaps   │ │rating│  │
│   └─────────┘ └─────────┘ └──────┘  │
│                                     │
│   ┌─────────────────────────────┐   │
│   │       Edit Profile          │   │
│   └─────────────────────────────┘   │
│                                     │
│  ─────────────────────────────────  │
│                                     │
│  About                              │
│  Passionate about music and code.   │
│  Always learning, always teaching!  │
│                                     │
│  Skills I Teach (3)            [+]  │
│  ┌──────────┐ ┌──────────┐          │
│  │🎸 Guitar │ │🎹 Piano  │          │
│  │ Expert   │ │Intermed. │          │
│  └──────────┘ └──────────┘          │
│                                     │
│  Skills I Want (2)             [+]  │
│  ┌──────────┐ ┌──────────┐          │
│  │💻 Python │ │🇪🇸Spanish │          │
│  └──────────┘ └──────────┘          │
│                                     │
│  Availability                       │
│  🌅 Morning • ☀️ Afternoon          │
│  🌍 America/New_York (EST)          │
│                                     │
│  Reviews (8)                See All │
│  ┌───────────────────────────────┐  │
│  │ ★★★★★ "Great teacher!"       │  │
│  │ Sarah M. • Jan 15            │  │
│  └───────────────────────────────┘  │
│                                     │
├─────────────────────────────────────┤
│  [🏠]   [🔄]   [💬]   [💰]   [👤]  │
└─────────────────────────────────────┘
```

---

## Components

### App Bar
```
Background:     Transparent (overlay on profile header)
Height:         56px

Settings Button:
  - Icon: settings (⚙️)
  - Position: Top left
  - Tap: Navigate to Settings

Title:
  - Text: "Profile"
  - Style: H4, Gray 900
  - Center

Preview Button (Optional):
  - Icon: eye
  - Position: Top right
  - Tap: View profile as others see it
```

### Profile Header
```
Avatar:
  - Size: 80px (XL)
  - Border: 3px White
  - Shadow: shadow-md
  - Centered
  - Tap: View full size / change photo

Edit Badge (Optional):
  - Camera icon
  - Position: Bottom right of avatar
  - 24px circle, Primary Blue bg

Name:
  - Style: H2, Gray 900
  - Margin: 16px top
  - Centered

Email:
  - Style: Body M, Gray 500
  - Centered

Verification Badge:
  - If verified: ✓ checkmark next to email
  - If not: "Verify email" link
```

### Stats Row
```
Layout:
  - 3 equal columns
  - Margin: 24px horizontal, 20px top

Stat Card:
  - Background: Gray 50
  - Border Radius: 12px
  - Padding: 12px
  - Centered content

  Value:
    - Style: H3, Gray 900

  Label:
    - Style: Caption, Gray 500

Stats:
  1. Credits balance
  2. Swaps completed
  3. Average rating (with star)
```

### Edit Profile Button
```
Text:           "Edit Profile"
Style:          Secondary Button, full width
Margin:         20px horizontal, 16px top
```

### Divider
```
Style:          1px Gray 200
Margin:         24px vertical
```

### About Section
```
Header:
  - Text: "About"
  - Style: H4, Gray 900

Content:
  - User's bio
  - Style: Body M, Gray 600
  - Max lines: 4 (expand to see more)
  - Margin: 8px top

If empty:
  - "Add a bio to tell others about yourself"
  - Style: Body M, Gray 400, italic
  - Tap: Edit profile
```

### Skills I Teach Section
```
Header:
  - Text: "Skills I Teach (X)"
  - Style: H4, Gray 900
  - Plus button: Add more skills

Skills Grid:
  - 2 columns
  - Gap: 12px
  - Margin: 12px top

Skill Card:
  - Background: White
  - Border: 1px Gray 200
  - Border Radius: 12px
  - Padding: 12px

  Content:
    - Emoji + Name (Body M, SemiBold)
    - Level badge below (Caption)

  Tap: View skill detail / Edit
```

### Skills I Want Section
```
Same pattern as "Skills I Teach"
Different header and content
```

### Availability Section
```
Header:
  - Text: "Availability"
  - Style: H4, Gray 900

Content:
  - Time preferences: "🌅 Morning • ☀️ Afternoon"
  - Timezone: "🌍 America/New_York (EST)"
  - Style: Body M, Gray 600
```

### Reviews Section
```
Header:
  - Text: "Reviews (X)"
  - Style: H4, Gray 900
  - "See All" link: Primary Blue

Preview Card (Latest Review):
  - Background: Gray 50
  - Border Radius: 12px
  - Padding: 16px

  Content:
    - Stars (filled)
    - Quote: Review text (truncated)
    - Reviewer: Name + date
    - Style: Body S, Gray 600

If no reviews:
  - "Complete swaps to receive reviews"
  - Style: Body M, Gray 400
```

---

## States

### Loading
```
- Avatar: Circle shimmer
- Name/email: Text shimmer
- Stats: Shimmer boxes
- Sections: Shimmer placeholders
```

### Incomplete Profile
```
Show prompts for missing info:

┌─────────────────────────────────────┐
│ ⚠️ Complete your profile            │
│                                     │
│ • Add a profile photo               │
│ • Write a bio                       │
│ • Add skills you want to learn      │
│                                     │
│ [Complete Now]                      │
└─────────────────────────────────────┘

Position: Below stats, above sections
Style: Warning Light background
```

### Email Not Verified
```
Banner:
┌─────────────────────────────────────┐
│ ✉️ Verify your email to start       │
│    swapping with others             │
│                      [Resend Email] │
└─────────────────────────────────────┘
```

---

## Scroll Behavior

### Header Collapse (Optional)
```
On scroll up:
  - Avatar shrinks to 48px
  - Moves to app bar
  - Name moves to app bar title
  - Stats remain visible

Creates more space for content
```

---

## Animations

### Entry
```
- Profile header fades in
- Stats count up
- Sections stagger in
```

### Section Expand
```
- Height animates
- Content fades in
```

---

## Accessibility
- Avatar has edit action announced
- Stats have complete labels
- Skills are buttons with full context
- Reviews section navigable
- Verification prompts are actionable
