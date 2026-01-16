# Edit Profile Screen

## Overview
Allows users to update their profile information, skills, and preferences. Provides section-by-section editing.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [Cancel]   Edit Profile     [Save]  │
├─────────────────────────────────────┤
│                                     │
│           ┌─────────┐               │
│           │  Your   │               │
│           │  Photo  │   [Change]    │
│           │   80px  │               │
│           └─────────┘               │
│                                     │
│  Basic Information                  │
│  ┌─────────────────────────────┐    │
│  │ Display Name                │    │
│  │ John Doe                    │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ Bio                         │    │
│  │ Passionate about music...   │    │
│  │                             │    │
│  └─────────────────────────────┘    │
│                            0/500    │
│                                     │
│  Skills I Teach                     │
│  ┌──────────┐ ┌──────────┐   [+]    │
│  │🎸 Guitar │ │🎹 Piano  │          │
│  │  [Edit]  │ │  [Edit]  │          │
│  └──────────┘ └──────────┘          │
│                                     │
│  Skills I Want                      │
│  ┌──────────┐ ┌──────────┐   [+]    │
│  │💻 Python │ │🇪🇸Spanish │          │
│  │  [Edit]  │ │  [Edit]  │          │
│  └──────────┘ └──────────┘          │
│                                     │
│  Availability                       │
│  ┌─────────────────────────────┐    │
│  │ Timezone                    │    │
│  │ America/New_York        [▼] │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────┐ ┌─────────┐            │
│  │🌅Morning│ │☀️Aftern.│            │
│  │   [✓]   │ │   [✓]   │            │
│  └─────────┘ └─────────┘            │
│  ┌─────────┐ ┌─────────┐            │
│  │🌙Evening│ │🔄Flexible│            │
│  │   [ ]   │ │   [ ]   │            │
│  └─────────┘ └─────────┘            │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### App Bar
```
Height:         56px
Background:     White

Cancel Button:
  - Text: "Cancel"
  - Style: Text Button, Gray 600
  - Position: Left
  - Tap: Confirm discard if changes made

Title:
  - Text: "Edit Profile"
  - Style: H4, Gray 900
  - Center

Save Button:
  - Text: "Save"
  - Style: Text Button, Primary Blue
  - Position: Right
  - Disabled if no changes or invalid
  - Tap: Save all changes
```

### Profile Photo Section
```
Avatar:
  - Size: 80px
  - Current photo or placeholder
  - Centered

Change Button:
  - Text: "Change Photo"
  - Style: Text Button, Primary Blue
  - Below avatar
  - Tap: Opens photo picker (same as setup)

Remove Option:
  - If photo exists: "Remove" text below change
  - Style: Text Button, Error Red (muted)
```

### Basic Information Section
```
Section Header:
  - Text: "Basic Information"
  - Style: Body M, SemiBold, Gray 500
  - All caps or small caps
  - Margin: 24px top

Display Name Input:
  - Label: "Display Name"
  - Current value pre-filled
  - Standard text input
  - Validation: Min 2 characters

Bio Input:
  - Label: "Bio"
  - Type: TextArea
  - Current value pre-filled
  - Placeholder: "Tell others about yourself..."
  - Height: 100px (expandable)
  - Character counter: "X/500"
```

### Skills I Teach Section
```
Section Header:
  - Text: "Skills I Teach"
  - Add button: [+] icon, Primary Blue

Skills List:
  - Current skills displayed as cards
  - 2 column grid

Skill Card (Editable):
  - Emoji + Name
  - Level badge
  - Edit button (pencil icon or text)
  - Delete button (× or swipe)

  Tap Edit: Opens skill edit sheet
  Tap Delete: Confirmation dialog

Add Button:
  - Opens skill selection flow (same as setup)
```

### Skill Edit Sheet
```
┌─────────────────────────────────────┐
│                                     │
│  ━━━━━  (handle)                    │
│                                     │
│  Edit Skill                         │
│                                     │
│  🎸 Guitar                          │
│  Music                              │
│                                     │
│  Your Level                         │
│  ┌─────────┬─────────┬─────────┐    │
│  │Beginner │Intermed.│ Expert  │    │
│  └─────────┴─────────┴─────────┘    │
│                                     │
│  Description                        │
│  ┌─────────────────────────────┐    │
│  │ I've been playing for 10    │    │
│  │ years...                    │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │      Save Changes           │    │
│  └─────────────────────────────┘    │
│                                     │
│         Remove Skill                │
│                                     │
└─────────────────────────────────────┘
```

### Skills I Want Section
```
Same pattern as "Skills I Teach"
Simpler cards (no description)
```

### Availability Section
```
Section Header:
  - Text: "Availability"

Timezone Dropdown:
  - Label: "Timezone"
  - Current timezone selected
  - Tap: Opens timezone picker

Time Preference Grid:
  - 2×2 grid of options
  - Toggle cards (multi-select)
  - Morning, Afternoon, Evening, Flexible

Toggle Card:
  - Size: ~half width
  - Height: 56px
  - Background: Gray 100 (unselected), Primary Surface (selected)
  - Border: None (unselected), 2px Primary Blue (selected)
  - Icon: Emoji
  - Label: Time name
  - Checkmark when selected
```

---

## States

### No Changes
```
- Save button disabled
- Cancel exits immediately
```

### Has Changes
```
- Save button enabled
- Cancel shows confirmation
- Unsaved indicator (optional)
```

### Saving
```
- Save button: Spinner
- Form disabled
- "Saving..."
```

### Save Success
```
- Brief success message
- Navigate back to profile
- Profile updates immediately
```

### Save Error
```
- Error message
- Keep on screen
- Allow retry
```

---

## Validation

### Real-time
```
- Name: 2+ characters
- Bio: 0-500 characters
- Skills: At least 1 offered, 1 wanted
- Availability: At least 1 time selected
```

### On Save
```
Validate all fields:
- Show inline errors
- Scroll to first error
- Block save until fixed
```

---

## Delete Skill Confirmation
```
Dialog:
┌─────────────────────────────────────┐
│                                     │
│   Remove "Guitar"?                  │
│                                     │
│   This skill will be removed from   │
│   your profile.                     │
│                                     │
│   [Cancel]          [Remove]        │
│                                     │
└─────────────────────────────────────┘

If last skill:
  "You need at least one skill to teach.
   Add another skill before removing this one."
```

---

## Discard Changes Confirmation
```
Dialog:
┌─────────────────────────────────────┐
│                                     │
│   Discard changes?                  │
│                                     │
│   You have unsaved changes that     │
│   will be lost.                     │
│                                     │
│   [Keep Editing]      [Discard]     │
│                                     │
└─────────────────────────────────────┘
```

---

## Animations

### Entry
```
- Slide from right
- Content fades in
```

### Section Changes
```
- Skill card added: Slide in + scale
- Skill card removed: Slide out + fade
```

### Save
```
- Button shows checkmark
- Brief delay
- Navigate back
```

---

## Accessibility
- All form fields labeled
- Error messages associated with fields
- Skill actions clearly labeled
- Confirmation dialogs focusable
- Save state announced
