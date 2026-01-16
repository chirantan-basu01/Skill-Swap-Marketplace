# Rating Screen

## Overview
Post-session rating interface. Both users must rate before credits transfer. Collects star rating, tags, and optional review.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│ [✕]      Rate Your Session          │
├─────────────────────────────────────┤
│                                     │
│           ┌─────────┐               │
│           │  Sarah  │               │
│           │  Avatar │               │
│           │   64px  │               │
│           └─────────┘               │
│                                     │
│      How was your session with      │
│            Sarah?                   │
│                                     │
│      🎸 Guitar lesson • 1 hour      │
│                                     │
│                                     │
│        ☆   ☆   ☆   ☆   ☆           │
│                                     │
│        Tap to rate                  │
│                                     │
│                                     │
│  What went well? (Select all)       │
│  ┌────────┐ ┌────────┐ ┌────────┐   │
│  │ Great  │ │Patient │ │Knowled-│   │
│  │Teacher │ │        │ │geable  │   │
│  └────────┘ └────────┘ └────────┘   │
│  ┌────────┐ ┌────────┐ ┌────────┐   │
│  │  Good  │ │Punctual│ │  Well  │   │
│  │Communi-│ │        │ │Prepared│   │
│  │ cator  │ │        │ │        │   │
│  └────────┘ └────────┘ └────────┘   │
│                                     │
│  Write a review (optional)          │
│  ┌─────────────────────────────┐    │
│  │ Share your experience...    │    │
│  │                             │    │
│  └─────────────────────────────┘    │
│                              20/300 │
│                                     │
│  ┌─────────────────────────────┐    │
│  │      Submit Rating          │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### Header
```
Close Button:
  - Icon: × (24px)
  - Position: Top left
  - Tap: Confirm abandon (rating required)

Title:
  - Text: "Rate Your Session"
  - Style: H4, Gray 900
  - Center
```

### Session Summary
```
Avatar:
  - Size: 64px
  - Centered
  - Partner's photo

Question:
  - Text: "How was your session with [Name]?"
  - Style: H3, Gray 900
  - Center, 16px below avatar

Session Info:
  - "🎸 Guitar lesson • 1 hour"
  - Style: Body M, Gray 500
  - Center, 8px below question
```

### Star Rating
```
Layout:
  - 5 stars in a row
  - Centered
  - Margin: 32px vertical

Star:
  - Size: 44px × 44px (touch target)
  - Icon: 32px

  Empty:
    - Outline star
    - Color: Gray 300

  Filled:
    - Solid star
    - Color: Warning Yellow (#F59E0B)

Interaction:
  - Tap star to set rating
  - Drag across stars for quick selection
  - Haptic feedback on each star

Label:
  - Below stars
  - Changes based on rating:
    - No selection: "Tap to rate"
    - 1 star: "Poor"
    - 2 stars: "Fair"
    - 3 stars: "Good"
    - 4 stars: "Very Good"
    - 5 stars: "Excellent!"
  - Style: Body M, Gray 500 (or matching color)
```

### Rating Tags
```
Label:
  - Text: "What went well? (Select all that apply)"
  - Style: Body M, SemiBold, Gray 700
  - Margin: 24px top

Tags Grid:
  - 3 columns
  - Gap: 8px
  - Wrap

Tag Chip:
  - Height: 44px
  - Background: Gray 100
  - Border Radius: 8px
  - Text: Body S, Gray 700
  - Centered text

  Selected:
    - Background: Primary Surface
    - Border: 1.5px Primary Blue
    - Text: Primary Blue
    - Check icon (optional)

Available Tags:
  1. Great Teacher
  2. Patient
  3. Knowledgeable
  4. Good Communicator
  5. Punctual
  6. Well Prepared
```

### Review Input
```
Label:
  - Text: "Write a review (optional)"
  - Style: Body M, SemiBold, Gray 700
  - Margin: 24px top

TextArea:
  - Height: 100px
  - Placeholder: "Share your experience with other learners..."
  - Border: 1.5px Gray 300
  - Border Radius: 12px

Character Counter:
  - Position: Bottom right
  - Text: "0/300"
  - Style: Body S, Gray 400
  - Changes to Warning at 280, Error at 300

Minimum:
  - If writing review: 20 characters minimum
  - Show hint: "Reviews must be at least 20 characters"
```

### Submit Button
```
Text:           "Submit Rating"
Style:          Primary Button, full width
Position:       Bottom

Disabled:       Until star rating selected
```

---

## Validation

### Required
```
- Star rating (1-5): Required
- Tags: Optional (but encouraged)
- Review: Optional
```

### Review Validation
```
If review started:
  - Minimum 20 characters
  - Maximum 300 characters
  - No profanity (basic filter)
```

---

## States

### Initial
```
- Stars empty
- No tags selected
- Review empty
- Submit disabled
```

### Rating Selected
```
- Stars filled to selection
- Label updates
- Tags become more visible/suggested
- Submit enabled
```

### Submitting
```
- Button: Spinner + "Submitting..."
- All inputs disabled
```

### Waiting for Partner
```
After submitting, if partner hasn't rated:

┌─────────────────────────────────────┐
│                                     │
│         ✓                           │
│                                     │
│   Thanks for your rating!           │
│                                     │
│   Waiting for Sarah to rate...      │
│                                     │
│   ┌───────────────────────────┐     │
│   │       ⏳                  │     │
│   │                           │     │
│   │  Credits will transfer    │     │
│   │  once both ratings are in │     │
│   │                           │     │
│   │  Or automatically in 47h  │     │
│   └───────────────────────────┘     │
│                                     │
│   ┌─────────────────────────────┐   │
│   │      Back to Home           │   │
│   └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘

Timer:
  - Counts down from 48 hours
  - After 48h: Auto-complete with submitted ratings
```

### Both Rated (Complete)
```
┌─────────────────────────────────────┐
│                                     │
│         🎉                          │
│                                     │
│   Swap Complete!                    │
│                                     │
│   ┌───────────────────────────┐     │
│   │                           │     │
│   │    +1.0 credits earned    │     │
│   │    (or -1.0 spent)        │     │
│   │                           │     │
│   │    New balance: 2.5       │     │
│   │                           │     │
│   └───────────────────────────┘     │
│                                     │
│   Sarah's review will be visible    │
│   on your profile now.              │
│                                     │
│   ┌─────────────────────────────┐   │
│   │    View Your Profile        │   │
│   └─────────────────────────────┘   │
│                                     │
│         Back to Home                │
│                                     │
└─────────────────────────────────────┘

Credit Display:
  - If taught: "+X credits earned" (Success Green)
  - If learned: "-X credits spent" (Gray)
  - Animation: Number counting up/down
```

---

## Skip/Abandon Handling

### Trying to Close
```
Rating is required, so:

Dialog:
┌─────────────────────────────────────┐
│                                     │
│   Rating Required                   │
│                                     │
│   Please rate your session before   │
│   leaving. This helps maintain      │
│   community trust.                  │
│                                     │
│   [Submit Rating]                   │
│                                     │
└─────────────────────────────────────┘

No option to skip - must rate
```

### 48-Hour Auto-Complete
```
If one user doesn't rate within 48 hours:
  - Credits transfer anyway
  - No rating from that user
  - Marked as "No rating submitted"
```

---

## Animations

### Star Selection
```
On tap:
  - Star scales up: 1 → 1.3 → 1
  - Fill animates from center outward
  - Sparkle effect on 5-star
  - Haptic: light impact

Sequential fill:
  - If tapping star 4, stars 1-4 fill in sequence
  - 50ms delay between each
```

### Tag Selection
```
Toggle:
  - Background color transition (150ms)
  - Check icon: scale 0 → 1 (100ms)
  - Border appears
```

### Submit Success
```
1. Button shows checkmark
2. Confetti burst (for 5-star ratings)
3. Screen transitions to waiting/complete state
```

### Credit Animation
```
Number counter:
  - Counts up from 0 to final amount
  - Duration: 500ms
  - Easing: ease-out
```

---

## Review Guidelines

### Hint Text (On Focus)
```
"Tips for a helpful review:
 • Be specific about what you learned
 • Mention teaching style
 • Keep it respectful"

Style: Body S, Gray 500
Position: Above text area
```

### Moderation
```
Basic profanity filter:
  - Block submission if detected
  - "Please revise your review"

Reviews visible to both parties after both submit
```

---

## Accessibility
- Stars are radio button group (1-5 scale)
- Selection announced: "4 out of 5 stars, Very Good"
- Tags are toggle buttons
- Character count announced at milestones
- Success/completion announced
