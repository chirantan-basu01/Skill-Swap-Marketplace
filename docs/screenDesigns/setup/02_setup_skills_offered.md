# Setup: Skills You Offer Screen

## Overview
Second step of the profile setup wizard. Users select skills they can teach others. Requires at least one skill to continue.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [←]              Step 2 of 4        │
│                                     │
│ ━━━━━━━━━━━━━━━━░░░░░░░░░░░░░░░░   │
│                                     │
│       What Can You Teach?           │
│    Share your expertise with the    │
│         community (min. 1)          │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ 🔍 Search skills...         │    │
│  └─────────────────────────────┘    │
│                                     │
│  Your Skills (2)                    │
│  ┌─────────────────────────────┐    │
│  │ 🎸 Guitar         Expert [×]│    │
│  │ Acoustic & Electric basics  │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ 💻 Python    Intermediate[×]│    │
│  │ Data analysis, automation   │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐    │
│  │     + Add Another Skill    │    │
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘    │
│                                     │
│  Browse Categories                  │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐       │
│  │💻  │ │🎨  │ │🎵  │ │🌍  │       │
│  │Tech│ │Art │ │Musi│ │Lang│       │
│  └────┘ └────┘ └────┘ └────┘       │
│                                     │
│  ┌─────────────────────────────┐    │
│  │         Continue            │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### Header
```
Same as Step 1, with:
  - Progress: 50% (2/4)
  - Back: Returns to Step 1
```

### Title Section
```
Title:
  - Text: "What Can You Teach?"
  - Style: H2, Gray 900

Subtitle:
  - Text: "Share your expertise with the community (min. 1)"
  - Style: Body L, Gray 500
```

### Search Input
```
Style:          Search Input (pill shape)
Placeholder:    "Search skills..."
Icon:           search (left)
Clear Button:   × (right, when has text)
Height:         48px

Behavior:
  - Opens search overlay/bottom sheet
  - Shows matching skills as user types
  - Allows adding custom skill if no match
```

### Skills List Header
```
Text:           "Your Skills (X)"
Style:          H4, Gray 900
Margin:         24px top

Badge:
  - Count in parentheses
  - Updates dynamically
```

### Added Skill Card
```
Container:
  - Background: White
  - Border: 1px Gray 200
  - Border Radius: 12px
  - Padding: 16px
  - Shadow: shadow-xs
  - Margin: 12px vertical

Layout:
┌─────────────────────────────────────┐
│ [Icon] Skill Name          Level [×]│
│        Short description            │
└─────────────────────────────────────┘

Skill Icon:
  - Size: 24px
  - From category

Skill Name:
  - Style: Body L, SemiBold, Gray 900

Level Badge:
  - Chip style
  - Colors by level:
    - Beginner: Teal Light bg, Teal text
    - Intermediate: Warning Light bg, Warning text
    - Expert: Primary Surface bg, Primary Blue text

Remove Button:
  - Icon: × (20px)
  - Position: Top right
  - Touch target: 44px
  - Action: Remove with confirmation if only skill

Description:
  - Style: Body S, Gray 500
  - Max 2 lines, ellipsis
  - Margin: 4px top
```

### Add Another Skill Button
```
Style:
  - Dashed border (Gray 300)
  - Background: Transparent
  - Height: 56px
  - Border Radius: 12px

Content:
  - Icon: plus (20px, Primary Blue)
  - Text: "Add Another Skill" (Body M, Primary Blue)
  - Centered

Hover/Tap:
  - Background: Primary Surface
```

### Category Grid
```
Header:
  - Text: "Browse Categories"
  - Style: Body M, SemiBold, Gray 700
  - Margin: 24px top

Grid:
  - 4 columns
  - Gap: 12px
  - Horizontal scroll if more than 8

Category Tile:
  - Size: 72px × 80px
  - Background: Gray 50
  - Border Radius: 12px
  - Centered content

  Icon:
    - Size: 32px
    - Category emoji or icon

  Label:
    - Style: Caption, Gray 700
    - Below icon, 4px margin

  Selected State:
    - Border: 2px Primary Blue
    - Background: Primary Surface

  Tap: Opens category detail with skills
```

---

## Add Skill Flow

### Search Results
```
┌─────────────────────────────────────┐
│ [×]     Search Skills               │
│ ┌─────────────────────────────┐     │
│ │ 🔍 guitar                   │     │
│ └─────────────────────────────┘     │
│                                     │
│ Suggestions                         │
│ ┌─────────────────────────────┐     │
│ │ 🎸 Guitar                   │     │
│ │    Music                    │     │
│ └─────────────────────────────┘     │
│ ┌─────────────────────────────┐     │
│ │ 🎸 Bass Guitar              │     │
│ │    Music                    │     │
│ └─────────────────────────────┘     │
│                                     │
│ Can't find your skill?              │
│ [+ Add "guitar" as custom skill]    │
│                                     │
└─────────────────────────────────────┘
```

### Skill Detail Sheet (After Selection)
```
┌─────────────────────────────────────┐
│                                     │
│  ━━━━━  (handle)                    │
│                                     │
│  🎸 Guitar                          │
│  Music                              │
│                                     │
│  Your Level                         │
│  ┌─────────┬─────────┬─────────┐    │
│  │Beginner │Intermed.│ Expert  │    │
│  └─────────┴─────────┴─────────┘    │
│                                     │
│  Describe Your Experience           │
│  ┌─────────────────────────────┐    │
│  │                             │    │
│  │ I've been playing for 5     │    │
│  │ years, teaching beginners...│    │
│  │                             │    │
│  └─────────────────────────────┘    │
│                          10/200     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │       Add This Skill        │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

#### Level Selector
```
Type:           Segmented control
Options:        Beginner | Intermediate | Expert
Default:        None selected (required)

Style:
  - Height: 44px
  - Border Radius: 8px
  - Background: Gray 100
  - Selected: Primary Blue bg, White text
  - Unselected: Transparent, Gray 600 text
```

#### Description Input
```
Type:           TextArea
Placeholder:    "Briefly describe your experience and what you can teach..."
Min Length:     10 characters
Max Length:     200 characters
Height:         100px
Required:       Yes
```

---

## States

### Empty State
```
┌─────────────────────────────────────┐
│                                     │
│      Your Skills                    │
│                                     │
│         📚                          │
│                                     │
│   No skills added yet               │
│   Add at least one skill you        │
│   can teach to continue             │
│                                     │
│   [+ Add Your First Skill]          │
│                                     │
└─────────────────────────────────────┘

Continue Button: Disabled
```

### Has Skills
- Skills displayed in cards
- Continue button enabled
- Count shown in header

### Maximum Skills (10)
```
- Hide "Add Another" button
- Show message: "Maximum 10 skills reached"
```

---

## Validation

### Required Fields
```
- At least 1 skill to continue
- Each skill must have:
  - Name (auto-filled from selection)
  - Level (required)
  - Description (10+ characters)
```

### Remove Last Skill
```
If trying to remove only skill:
  - Show confirmation dialog
  - "You need at least one skill to continue"
  - Options: "Keep Skill" | "Remove Anyway"
```

---

## Animations

### Add Skill
```
New card entry:
  - Height: 0 → auto
  - Opacity: 0 → 1
  - Scale: 0.95 → 1
  - Duration: 250ms
  - Easing: ease-out
```

### Remove Skill
```
Card exit:
  - Height: auto → 0
  - Opacity: 1 → 0
  - Duration: 200ms
  - Other cards slide up smoothly
```

### Bottom Sheet
```
Entry:
  - Slide from bottom
  - Backdrop fade in
  - Duration: 250ms
```

---

## Accessibility
- Skill cards have accessible labels
- Level selector uses radio button semantics
- Remove button has clear label "Remove [Skill Name]"
- Count updates announced
- Search results navigable by keyboard/switch
