# Setup: Basic Info Screen

## Overview
First step of the profile setup wizard. Collects essential identity information: display name, profile photo, and bio.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [←]              Step 1 of 4        │
│                                     │
│ ━━━━━━━━━━░░░░░░░░░░░░░░░░░░░░░░   │
│                                     │
│        Tell Us About You            │
│    Add your name and a photo so     │
│    others can recognize you         │
│                                     │
│           ┌─────────┐               │
│           │         │               │
│           │  📷     │               │
│           │         │               │
│           └─────────┘               │
│         Add Profile Photo           │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ Display Name                │    │
│  └─────────────────────────────┘    │
│  This is how others will see you    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │                             │    │
│  │ Bio (Optional)              │    │
│  │                             │    │
│  └─────────────────────────────┘    │
│  Brief intro about yourself  0/500  │
│                                     │
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
Back Button:
  - Position: Top left
  - Action: Show "Discard changes?" dialog

Step Indicator:
  - Text: "Step 1 of 4"
  - Style: Body S, Gray 500
  - Position: Top right

Progress Bar:
  - Height: 4px
  - Background: Gray 200
  - Fill: Primary Blue
  - Progress: 25% (1/4)
  - Border Radius: 2px
  - Margin: 16px top
```

### Title Section
```
Title:
  - Text: "Tell Us About You"
  - Style: H2, Gray 900
  - Margin: 32px top

Subtitle:
  - Text: "Add your name and a photo so others can recognize you"
  - Style: Body L, Gray 500
  - Max Width: 280px
  - Margin: 8px top
```

### Profile Photo Picker
```
Container:
  - Size: 120px × 120px
  - Shape: Circle
  - Background: Gray 100
  - Border: 2px dashed Gray 300
  - Margin: 32px top

Empty State:
  - Icon: camera (32px, Gray 400)
  - Centered in container

With Photo:
  - Image fills container
  - Object Fit: cover
  - Border: 3px solid White
  - Shadow: shadow-md

Label:
  - Text: "Add Profile Photo"
  - Style: Body M, Primary Blue
  - Margin: 12px below container
  - Tappable (same action as container)

Edit Overlay (when photo exists):
  - Small camera icon badge
  - Position: bottom-right of photo
  - Size: 32px circle
  - Background: Primary Blue
  - Icon: camera (16px, White)
```

### Photo Selection
```
On Tap → Bottom Sheet:

  ┌─────────────────────────────────┐
  │                                 │
  │  ━━━━━  (handle)                │
  │                                 │
  │  Choose Photo                   │
  │                                 │
  │  ┌─────────┐  ┌─────────┐       │
  │  │ 📷      │  │ 🖼      │       │
  │  │ Camera  │  │ Gallery │       │
  │  └─────────┘  └─────────┘       │
  │                                 │
  │  [Remove Photo] (if exists)     │
  │                                 │
  │  [Cancel]                       │
  │                                 │
  └─────────────────────────────────┘
```

### Display Name Input
```
Label:          "Display Name"
Placeholder:    "Enter your name"
Keyboard:       text
Autocapitalize: words
Max Length:     50 characters
Required:       Yes

Helper Text:
  - Text: "This is how others will see you"
  - Style: Body S, Gray 500
  - Margin: 4px below input

Validation:
  - Min 2 characters
  - No special characters except spaces
  - Error: "Name must be at least 2 characters"
```

### Bio Input
```
Type:           TextArea (multiline)
Label:          "Bio"
Placeholder:    "Tell others a bit about yourself, your interests, and what you're passionate about..."
Max Length:     500 characters
Required:       No
Height:         120px (expandable)

Character Counter:
  - Text: "0/500"
  - Position: Bottom right of field
  - Style: Body S, Gray 400
  - Color: Warning when > 450, Error when = 500
```

### Continue Button
```
Text:           "Continue"
Style:          Primary Button, full width
Position:       Bottom, 32px from safe area
Disabled:       Until display name is valid

Fixed Position:
  - Sticky to bottom
  - Background fade above button (white → transparent)
```

---

## States

### Empty State
- Photo placeholder shown
- Name field empty
- Bio field empty
- Continue button disabled

### Photo Selected
- Circular photo preview
- Edit badge appears
- Option to remove

### Valid State
- Name has 2+ characters
- Continue button enabled

### Loading (Photo Upload)
```
Photo Container:
  - Show upload progress ring around photo
  - Percentage in center
  - Or shimmer effect
```

---

## Animations

### Page Entry
```
Elements stagger in:
1. Progress bar fills (300ms)
2. Title fades in (200ms)
3. Photo picker scales up (250ms, spring)
4. Form fields slide up (200ms each, 50ms stagger)
```

### Photo Selection
```
When photo selected:
  - Scale from 0.8 → 1.0
  - Opacity 0 → 1
  - Duration: 250ms
  - Slight bounce (spring easing)
```

### Progress Bar
```
On entry:
  - Width animates from 0% → 25%
  - Duration: 400ms
  - Easing: ease-out
```

---

## Image Handling

### Photo Requirements
```
Minimum Size:   200 × 200px
Maximum Size:   2MB
Formats:        JPEG, PNG
Crop:           Square, center crop
```

### Crop Flow (Optional)
```
After selection → Crop Screen:
  - Square crop overlay
  - Pinch to zoom
  - Drag to position
  - Confirm/Cancel buttons
```

---

## Validation & Errors

### Name Validation
```
Empty:          "Please enter your name"
Too Short:      "Name must be at least 2 characters"
Invalid Chars:  "Name can only contain letters and spaces"
```

### Photo Errors
```
Too Large:      "Image must be under 2MB"
Invalid Format: "Please select a JPEG or PNG image"
Upload Failed:  "Failed to upload photo. Please try again."
```

---

## Skip Option
```
Not shown - photo is optional but encouraged
Name is required to continue
```

---

## Accessibility
- Photo picker has clear accessible label
- Form fields properly labeled
- Character counter announced at thresholds
- Error messages linked to inputs
- Progress indicator has accessible description
