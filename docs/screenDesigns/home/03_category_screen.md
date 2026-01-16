# Category Screen

## Overview
Displays all users who teach skills within a selected category. Includes skill filtering within the category.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [←]        Music              [🔍]  │
├─────────────────────────────────────┤
│                                     │
│  🎵 🎸 🎹 🥁 🎤 🎼                   │
│                                     │
│  Skills in Music                    │
│  ┌────────┐ ┌────────┐ ┌────────┐   │
│  │ All    │ │ Guitar │ │ Piano  │   │
│  │  ✓     │ │        │ │        │   │
│  └────────┘ └────────┘ └────────┘   │
│  ┌────────┐ ┌────────┐ ┌────────┐   │
│  │ Vocals │ │ Drums  │ │ Theory │   │
│  └────────┘ └────────┘ └────────┘   │
│                                     │
│  45 Teachers                [Sort ▼]│
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                        │  │
│  │ │    │ Sarah Martinez         │  │
│  │ │    │ ★ 4.9 • Expert         │  │
│  │ └────┘ 🎸 Guitar              │  │
│  │        15 swaps completed     │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                        │  │
│  │ │    │ Michael Chen           │  │
│  │ │    │ ★ 4.7 • Intermediate   │  │
│  │ └────┘ 🎹 Piano               │  │
│  │        8 swaps completed      │  │
│  └───────────────────────────────┘  │
│                                     │
│          ... more teachers ...      │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### App Bar
```
Background:     White
Height:         56px
Shadow:         shadow-xs

Back Button:
  - Icon: arrow-left
  - Position: Left
  - Tap: Return to Home

Title:
  - Text: Category name (e.g., "Music")
  - Style: H4, Gray 900
  - Position: Center

Search Button:
  - Icon: search
  - Position: Right
  - Tap: Open search with category pre-filtered
```

### Category Header
```
Background:     Gradient or Category-themed color
Height:         100px
Padding:        20px

Visual:
  - Large emoji cluster or illustration
  - Represents the category
  - Subtle animation (floating effect)

Example for Music:
  🎵 🎸 🎹 🥁 🎤 🎼
  Scattered, different sizes, slight overlap
```

### Skills Filter Section
```
Header:
  - Text: "Skills in [Category]"
  - Style: Body M, SemiBold, Gray 700
  - Margin: 16px horizontal

Chips:
  - Horizontal scroll or wrap
  - Gap: 8px
  - Padding: 16px horizontal

Skill Chip:
  - Height: 40px
  - Background: Gray 100
  - Border Radius: full
  - Padding: 10px 16px
  - Text: Body M, Gray 700

  "All" Chip:
    - First in list
    - Selected by default

  Selected State:
    - Background: Primary Blue
    - Text: White
    - Check icon prefix

  With Count (optional):
    - "Guitar (12)" showing teacher count
```

### Results Header
```
Layout:
  - Flex row, space-between
  - Margin: 16px horizontal, 12px vertical

Left:
  - Text: "X Teachers"
  - Style: Body M, Gray 500

Right:
  - Sort dropdown
  - Text: "Best Match ▼"
  - Style: Body M, Primary Blue
  - Tap: Open sort options
```

### Teacher Card
```
Container:
  - Width: Full (- 40px margin)
  - Background: White
  - Border: 1px Gray 200
  - Border Radius: 12px
  - Padding: 16px
  - Margin: 8px vertical

Layout:
┌───────────────────────────────────────┐
│ ┌────┐                                │
│ │Ava │  Teacher Name                  │
│ │ 48 │  ★ 4.9 • Expert                │
│ └────┘                                │
│        🎸 Guitar                      │
│        15 swaps completed             │
│                                       │
│ ┌──────────────────────────────────┐  │
│ │ "I've been teaching guitar for   │  │
│ │ 10 years, specializing in..."    │  │
│ └──────────────────────────────────┘  │
│                                       │
│              [View Profile]           │
└───────────────────────────────────────┘

Avatar:
  - Size: 48px
  - Online dot if recently active

Name:
  - Style: Body L, SemiBold, Gray 900

Rating & Level:
  - Star icon + rating + "•" + level
  - Style: Body S, Gray 600
  - Level shown as text (not chip)

Primary Skill:
  - Emoji + Skill name
  - Style: Body M, Gray 800
  - The skill from this category

Stats:
  - "X swaps completed"
  - Style: Body S, Gray 500

Description Quote:
  - Background: Gray 50
  - Border Radius: 8px
  - Padding: 12px
  - Text: Body S, Gray 600, italic
  - Max 2 lines, truncate

View Profile Button:
  - Style: Secondary Button (small)
  - Position: Bottom right
  - Or entire card tappable
```

---

## Sort Options

### Sort Bottom Sheet
```
┌─────────────────────────────────────┐
│                                     │
│  ━━━━━  (handle)                    │
│                                     │
│  Sort By                            │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ ○ Best Match           ✓    │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ ○ Highest Rated             │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ ○ Most Experienced          │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ ○ Recently Active           │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘

Options:
  1. Best Match - Based on user's wanted skills
  2. Highest Rated - By average rating
  3. Most Experienced - By swaps completed
  4. Recently Active - By last active time
```

---

## States

### Loading State
```
- App bar visible
- Category header visible
- Skill chips: shimmer placeholders
- Cards: shimmer placeholders (3-4)
```

### Empty State (No Teachers)
```
┌─────────────────────────────────────┐
│                                     │
│         🎵                          │
│                                     │
│   No teachers yet in Music          │
│                                     │
│   Be the first to offer your        │
│   music skills to the community!    │
│                                     │
│   [Add Music Skills]                │
│                                     │
└─────────────────────────────────────┘

If user has music skills → don't show button
```

### Empty Filter State
```
When filtering by specific skill returns no results:

┌─────────────────────────────────────┐
│                                     │
│   No Guitar teachers found          │
│                                     │
│   Try selecting a different skill   │
│   or view all Music teachers        │
│                                     │
│   [View All]                        │
│                                     │
└─────────────────────────────────────┘
```

### Error State
```
- Error message with retry button
- Category header still visible
```

---

## Category Themes (Optional)

Each category could have a subtle color theme:

```
Technology:   Blue tint    (#EEF2FF)
Creative:     Purple tint  (#F3E8FF)
Music:        Rose tint    (#FFF1F2)
Languages:    Green tint   (#ECFDF5)
Business:     Amber tint   (#FFFBEB)
Lifestyle:    Teal tint    (#F0FDFA)
Academic:     Slate tint   (#F8FAFC)

Applied to:
  - Category header background
  - Skill chip selected state
  - Card hover/tap state
```

---

## Animations

### Page Entry
```
- App bar slides down
- Header fades in with emoji scatter animation
- Skill chips slide in from left (stagger)
- Cards fade in (stagger)
```

### Skill Selection
```
Chip:
  - Background color transition (200ms)
  - Check icon: scale 0 → 1 (150ms)

Results:
  - Crossfade (old out, new in)
  - Duration: 200ms
```

### Sort Change
```
- Sheet dismisses
- Results fade/crossfade
```

### Card Tap
```
- Scale to 0.98 (100ms)
- Spring back
- Navigate to profile
```

---

## Infinite Scroll

### Pagination
```
- Load 20 teachers initially
- Load more when scrolled near bottom
- Show loading indicator at bottom

Loading Indicator:
  - Spinner (24px, Primary Blue)
  - Centered below last card
  - Padding: 24px vertical
```

### End of List
```
Text: "You've seen all X teachers"
Style: Body S, Gray 400
Centered, 24px padding
```

---

## Accessibility
- Category header has descriptive label
- Skill chips function as filter toggles
- Selected filter announced
- Results count announced on change
- Cards have complete accessible labels
