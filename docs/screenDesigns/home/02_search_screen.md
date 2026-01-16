# Search Screen

## Overview
Full-featured search interface for finding skills and users. Supports text search, filters, and displays results with sorting options.

---

## Visual Design

### Layout - Initial State
```
┌─────────────────────────────────────┐
│ [←]  ┌───────────────────────┐  [✕] │
│      │ 🔍 Search...          │      │
│      └───────────────────────┘      │
│                                     │
│  Recent Searches                    │
│  ┌─────────────────────────────┐    │
│  │ 🕐 Guitar lessons           │ ✕  │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ 🕐 Python programming       │ ✕  │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ 🕐 Sarah                    │ ✕  │
│  └─────────────────────────────┘    │
│                                     │
│  Popular Skills                     │
│  ┌────────┐ ┌────────┐ ┌────────┐   │
│  │ Guitar │ │ Python │ │ Piano  │   │
│  └────────┘ └────────┘ └────────┘   │
│  ┌────────┐ ┌────────┐ ┌────────┐   │
│  │Spanish │ │ Design │ │ React  │   │
│  └────────┘ └────────┘ └────────┘   │
│                                     │
│  Suggested for You                  │
│  Based on your wanted skills        │
│  ┌───────────────────────────────┐  │
│  │  User Card                    │  │
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

### Layout - With Results
```
┌─────────────────────────────────────┐
│ [←]  ┌───────────────────────┐  [✕] │
│      │ 🔍 guitar             │      │
│      └───────────────────────┘      │
│                                     │
│  ┌────────┐ ┌────────┐ ┌────────┐   │
│  │Category│ │ Level  │ │  Sort  │   │
│  │   ▼    │ │   ▼    │ │   ▼    │   │
│  └────────┘ └────────┘ └────────┘   │
│                                     │
│  12 Results for "guitar"            │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                        │  │
│  │ │    │ Sarah Martinez         │  │
│  │ │    │ ★ 4.9 • 12 swaps       │  │
│  │ └────┘ 🎸 Guitar (Expert)     │  │
│  │        Teaches acoustic...    │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌────┐                        │  │
│  │ │    │ John Doe               │  │
│  │ │    │ ★ 4.7 • 8 swaps        │  │
│  │ └────┘ 🎸 Guitar (Intermed.)  │  │
│  │        Electric guitar, rock  │  │
│  └───────────────────────────────┘  │
│                                     │
│          ... more results ...       │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### Search Header
```
Layout:
  - Height: 56px
  - Background: White
  - Padding: 12px horizontal

Back Button:
  - Icon: arrow-left (24px)
  - Position: Left
  - Tap: Return to previous screen

Search Input:
  - Flex: 1 (fill available space)
  - Height: 44px
  - Background: Gray 100
  - Border Radius: full
  - Padding: 12px 16px 12px 44px
  - Auto-focus on mount

  Icon:
    - search (20px, Gray 400)
    - Position: Left inside input

  Placeholder:
    - "Search skills or people..."
    - Style: Body M, Gray 400

Clear Button:
  - Icon: × (20px, Gray 400)
  - Position: Right inside input
  - Visible: Only when input has text
  - Tap: Clear input, show initial state
```

### Recent Searches
```
Visibility: Only when input is empty

Header:
  - Text: "Recent Searches"
  - Style: Body M, SemiBold, Gray 700
  - Margin: 24px top, 20px horizontal

List Item:
  - Height: 48px
  - Padding: 12px 20px

  Layout:
  ┌─────────────────────────────────────┐
  │ 🕐  Search term                   ✕ │
  └─────────────────────────────────────┘

  Icon: clock (Gray 400)
  Text: Body M, Gray 700
  Remove: × (Gray 400), tap to remove

  Tap: Fill search input with term and execute search
```

### Popular Skills
```
Visibility: Only when input is empty

Header:
  - Text: "Popular Skills"
  - Style: Body M, SemiBold, Gray 700

Chips:
  - Wrap layout
  - Gap: 8px
  - Margin: 12px top

Chip:
  - Height: 36px
  - Background: Gray 100
  - Border Radius: full
  - Padding: 8px 16px
  - Text: Body M, Gray 700

  Tap: Fill search and execute
```

### Filter Bar
```
Visibility: When there are search results

Layout:
  - Horizontal scroll
  - Padding: 16px horizontal
  - Gap: 8px
  - Background: White
  - Border Bottom: 1px Gray 200

Filter Chip:
  - Height: 36px
  - Background: White
  - Border: 1px Gray 300
  - Border Radius: full
  - Padding: 8px 12px

  Content:
    - Label + chevron-down (16px)
    - Style: Body S, Gray 700

  Active State:
    - Background: Primary Surface
    - Border: 1px Primary Blue
    - Text: Primary Blue

Filters Available:
  1. Category (dropdown)
  2. Level (dropdown)
  3. Availability (dropdown)
  4. Sort (dropdown)
```

### Filter Dropdown (Bottom Sheet)
```
┌─────────────────────────────────────┐
│                                     │
│  ━━━━━  (handle)                    │
│                                     │
│  Category                    [Clear]│
│                                     │
│  ○ All Categories                   │
│  ○ Technology                       │
│  ● Music                       ✓    │
│  ○ Languages                        │
│  ○ Creative                         │
│  ○ Business                         │
│  ○ Lifestyle                        │
│  ○ Academic                         │
│                                     │
│  ┌─────────────────────────────┐    │
│  │      Apply Filter           │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘

Options:
  - Radio buttons for single select
  - Checkboxes for multi-select (if needed)
  - "Clear" resets to default
```

### Sort Options
```
Options:
  1. Best Match (default)
  2. Highest Rated
  3. Most Active
  4. Newest Members
```

### Results Header
```
Text:           "X Results for 'query'"
Style:          Body M, Gray 500
Margin:         16px horizontal, 12px vertical
```

### Search Result Card
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
│ │Ava │  User Name                     │
│ │ 48 │  ★ 4.9 • 12 swaps completed   │
│ └────┘                                │
│        🎸 Guitar (Expert)             │
│        "I teach acoustic and electric │
│        guitar for all levels..."      │
│                                       │
│ Match: 85%           [Request Swap]   │
└───────────────────────────────────────┘

Avatar:
  - Size: 48px
  - Online indicator if active

User Name:
  - Style: Body L, SemiBold, Gray 900

Stats:
  - Star + rating + "•" + swap count
  - Style: Body S, Gray 500

Matched Skill:
  - Icon (emoji from category)
  - Skill name + level badge
  - Style: Body M, Gray 900
  - Highlighted if matches search query

Description:
  - Skill description (truncated)
  - Style: Body S, Gray 600
  - Max 2 lines

Match Percentage:
  - "Match: 85%"
  - Style: Body S, Primary Blue

Request Button:
  - Text: "Request Swap"
  - Style: Small Primary Button
  - Position: Bottom right
```

---

## Search Behavior

### Live Search
```
Debounce:       300ms after typing stops
Min Characters: 2 to trigger search
Loading:        Inline spinner in search input

Results Update:
  - Fade out old results
  - Show loading shimmer
  - Fade in new results
```

### Search Matching
```
Searches against:
  - Skill names
  - User display names
  - Category names
  - Skill descriptions

Ranking:
  1. Exact skill name match
  2. Partial skill name match
  3. User name match
  4. Description match
```

---

## States

### Initial State (No Query)
- Recent searches visible
- Popular skills visible
- Suggested users based on wanted skills

### Typing State
```
- Show search suggestions dropdown
- Autocomplete for skill names

Suggestions:
┌─────────────────────────────────────┐
│ 🔍 guit                              │
├─────────────────────────────────────┤
│ 🎸 Guitar                           │
│ 🎸 Bass Guitar                      │
│ 👤 Guillermo (user)                 │
└─────────────────────────────────────┘
```

### Loading State
```
- Search input shows spinner
- Filter bar visible but disabled
- Shimmer cards (3-4)
```

### Results State
- Filter bar visible and active
- Results count shown
- Cards displayed

### Empty Results
```
┌─────────────────────────────────────┐
│                                     │
│         🔍                          │
│                                     │
│   No results for "xyz"              │
│                                     │
│   Try a different search term       │
│   or browse categories              │
│                                     │
│   [Browse Categories]               │
│                                     │
└─────────────────────────────────────┘
```

### Error State
```
┌─────────────────────────────────────┐
│                                     │
│         ⚠️                          │
│                                     │
│   Search failed                     │
│   Please try again                  │
│                                     │
│   [Retry]                           │
│                                     │
└─────────────────────────────────────┘
```

---

## Animations

### Page Entry
```
- Search input auto-focuses
- Keyboard appears
- Recent searches fade in
```

### Search Transition
```
Recent searches → Results:
  - Recent fades out (150ms)
  - Filter bar slides down (200ms)
  - Results fade in (200ms)
```

### Filter Selection
```
Bottom sheet:
  - Slide from bottom (250ms)
  - Backdrop fade in

Selection:
  - Radio/check animation
  - Chip updates when applied
```

---

## Keyboard Handling
- Search input focused on mount
- "Search" keyboard action executes search
- Tap outside dismisses keyboard
- Results scrollable while keyboard open

---

## Accessibility
- Search input has clear label
- Results announced with count
- Filter states announced
- Cards have complete accessible labels
- Clear button has "Clear search" label
