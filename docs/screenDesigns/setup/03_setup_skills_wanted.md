# Setup: Skills You Want Screen

## Overview
Third step of the profile setup wizard. Users select skills they want to learn. Similar to Step 2 but simpler (no description required).

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [←]              Step 3 of 4        │
│                                     │
│ ━━━━━━━━━━━━━━━━━━━━━━░░░░░░░░░░   │
│                                     │
│      What Do You Want to Learn?     │
│   Select skills you're interested   │
│          in learning (min. 1)       │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ 🔍 Search skills...         │    │
│  └─────────────────────────────┘    │
│                                     │
│  Skills You Want (1)                │
│  ┌─────────────────────────────┐    │
│  │ 🇪🇸 Spanish     Intermediate[×]│    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐    │
│  │     + Add Another Skill    │    │
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘    │
│                                     │
│  Popular Skills                     │
│  ┌────────┐ ┌────────┐ ┌────────┐   │
│  │Programming│ Guitar │ Spanish │   │
│  └────────┘ └────────┘ └────────┘   │
│  ┌────────┐ ┌────────┐ ┌────────┐   │
│  │  Piano │  Design │  Python │   │
│  └────────┘ └────────┘ └────────┘   │
│                                     │
│  Browse by Category                 │
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
Same structure as previous steps:
  - Progress: 75% (3/4)
  - Back: Returns to Step 2
```

### Title Section
```
Title:
  - Text: "What Do You Want to Learn?"
  - Style: H2, Gray 900

Subtitle:
  - Text: "Select skills you're interested in learning (min. 1)"
  - Style: Body L, Gray 500
```

### Search Input
```
Same as Step 2
```

### Wanted Skills List
```
Header:
  - Text: "Skills You Want (X)"
  - Style: H4, Gray 900
```

### Wanted Skill Card (Simplified)
```
Container:
  - Background: White
  - Border: 1px Gray 200
  - Border Radius: 12px
  - Padding: 12px 16px
  - Height: ~52px (single line)

Layout:
┌─────────────────────────────────────┐
│ [Icon] Skill Name    Desired Level [×]│
└─────────────────────────────────────┘

No description needed (simpler than offered skills)
```

### Popular Skills Section
```
Header:
  - Text: "Popular Skills"
  - Style: Body M, SemiBold, Gray 700
  - Margin: 24px top

Chips:
  - Wrap layout (flow)
  - Gap: 8px

Skill Chip:
  - Height: 36px
  - Background: Gray 100
  - Border Radius: full
  - Padding: 8px 16px
  - Text: Body M, Gray 700

  Tap: Opens skill detail sheet

  Already Added:
    - Background: Primary Surface
    - Text: Primary Blue
    - Check icon prefix
    - Tap: Remove from list
```

### Category Grid
```
Same as Step 2
```

---

## Add Skill Flow

### Skill Selection Sheet (Simplified)
```
┌─────────────────────────────────────┐
│                                     │
│  ━━━━━  (handle)                    │
│                                     │
│  🇪🇸 Spanish                        │
│  Languages                          │
│                                     │
│  What level do you want to reach?   │
│                                     │
│  ┌─────────┬─────────┬─────────┐    │
│  │Beginner │Intermed.│ Expert  │    │
│  └─────────┴─────────┴─────────┘    │
│                                     │
│  💡 Tip: Choosing the right level   │
│     helps us match you with the     │
│     best teachers                   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │     Add to Learning List    │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

#### Level Explanation
```
Beginner:    "I'm just starting out"
Intermediate: "I know the basics, want to improve"
Expert:       "I want to master this skill"
```

---

## States

### Empty State
```
┌─────────────────────────────────────┐
│                                     │
│      Skills You Want                │
│                                     │
│         🎯                          │
│                                     │
│   What would you like to learn?     │
│   Add at least one skill to find    │
│   teachers who can help you         │
│                                     │
│   Browse popular skills below       │
│                                     │
└─────────────────────────────────────┘

Continue Button: Disabled
```

### Has Skills
- Skills displayed in compact cards
- Continue button enabled

### Duplicate Prevention
```
If user tries to add skill already in their "Offered" list:
  - Show toast: "You already teach this skill!"
  - Don't add to wanted list
```

---

## Perfect Match Hint
```
When user adds a skill that complements their offered skills:

Toast/Banner:
  ┌─────────────────────────────────┐
  │ ✨ Nice! Users who teach Python │
  │    often want to learn Guitar   │
  │    - you might find a match!    │
  └─────────────────────────────────┘

Brief (3 seconds), dismissible
```

---

## Animations

### Quick Add from Popular
```
Chip Transform:
  - Gray → Primary (color transition)
  - Plus icon morphs to check
  - Brief scale pulse (1 → 1.05 → 1)
  - Duration: 200ms

Card appears in list:
  - Same animation as Step 2
```

### Remove from Quick Add
```
Chip Transform:
  - Primary → Gray
  - Check morphs to plus
  - Card removes from list
```

---

## Validation

### Requirements
```
- Minimum 1 skill
- Each skill needs:
  - Skill name (from selection)
  - Desired level (required)
```

### Maximum Skills
```
- Max 10 skills
- When reached, hide add button
- Popular chips remain visible but disabled
```

---

## Accessibility
- Popular skills announced with "Add [skill] to learning list"
- Already added skills announced as "Remove [skill]"
- Level descriptions read out
- Clear distinction between offered and wanted sections
