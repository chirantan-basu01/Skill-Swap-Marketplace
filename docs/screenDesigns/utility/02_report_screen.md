# Report Screen

## Overview
Allows users to report inappropriate behavior, no-shows, fraud, or other issues. Collects reason and description for review.

---

## Visual Design

### Layout (Bottom Sheet)
```
┌─────────────────────────────────────┐
│                                     │
│  ━━━━━  (handle)                    │
│                                     │
│  Report User                        │
│                                     │
│  ─────────────────────────────────  │
│                                     │
│  ┌────┐                             │
│  │Ava │ Sarah Martinez              │
│  │ 40 │                             │
│  └────┘                             │
│                                     │
│  What's the issue?                  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ○ Inappropriate content       │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │ ○ Spam or scam                │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │ ○ No-show to session          │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │ ○ Fraud or fake profile       │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │ ○ Other                       │  │
│  └───────────────────────────────┘  │
│                                     │
│  Tell us more                       │
│  ┌─────────────────────────────┐    │
│  │ Please describe what        │    │
│  │ happened...                 │    │
│  │                             │    │
│  └─────────────────────────────┘    │
│                             10/500  │
│                                     │
│  Related Swap (Optional)            │
│  ┌─────────────────────────────┐    │
│  │ Select a swap...          ▼ │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │       Submit Report         │    │
│  └─────────────────────────────┘    │
│                                     │
│  Reports are reviewed within 24h    │
│                                     │
└─────────────────────────────────────┘
```

---

## Components

### Header
```
Handle:
  - Drag indicator
  - 40px wide, 4px tall

Title:
  - Text: "Report User"
  - Style: H3, Gray 900

Divider:
  - 1px Gray 200
  - Full width
```

### User Being Reported
```
Container:
  - Background: Gray 50
  - Border Radius: 8px
  - Padding: 12px
  - Margin: 16px horizontal

Content:
  - Avatar: 40px
  - Name: Body L, SemiBold, Gray 900
  - Inline layout
```

### Reason Selection
```
Label:
  - Text: "What's the issue?"
  - Style: Body M, SemiBold, Gray 700
  - Margin: 20px top

Options:
  - Radio button list
  - One selection required

Option Item:
  - Height: 52px
  - Background: White
  - Border: 1px Gray 200
  - Border Radius: 8px
  - Padding: 16px
  - Margin: 8px vertical

  Layout:
  ┌───────────────────────────────────┐
  │ ○  Reason text                    │
  └───────────────────────────────────┘

  Radio Button:
    - Size: 20px
    - Unselected: Gray 300 border
    - Selected: Primary Blue filled

  Selected State:
    - Border: 2px Primary Blue
    - Background: Primary Surface

Report Reasons:
  1. Inappropriate content
     - "Offensive messages, images, or behavior"

  2. Spam or scam
     - "Unwanted promotions or suspicious links"

  3. No-show to session
     - "Didn't attend a scheduled session"

  4. Fraud or fake profile
     - "Misrepresented skills or identity"

  5. Other
     - "Something else not listed above"
```

### Description Input
```
Label:
  - Text: "Tell us more"
  - Style: Body M, SemiBold, Gray 700
  - Margin: 20px top

TextArea:
  - Height: 120px
  - Placeholder: "Please describe what happened so we can investigate..."
  - Border: 1.5px Gray 300
  - Border Radius: 12px
  - Max Length: 500 characters

Character Counter:
  - Position: Bottom right
  - Style: Body S, Gray 400

Required:
  - Minimum 10 characters for "Other"
  - Optional but encouraged for other reasons
```

### Related Swap Selector
```
Label:
  - Text: "Related Swap (Optional)"
  - Style: Body M, SemiBold, Gray 700
  - Margin: 16px top

Dropdown:
  - Height: 52px
  - Placeholder: "Select a swap..."
  - Shows recent swaps with this user
  - Helps provide context

Selection Sheet:
┌─────────────────────────────────────┐
│                                     │
│  Select Related Swap                │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 🎸 Guitar session             │  │
│  │ Jan 15, 2024              ○   │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │ 🎹 Piano session              │  │
│  │ Jan 10, 2024              ○   │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ None - General report         │  │
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

### Submit Button
```
Text:           "Submit Report"
Style:          Primary Button, full width
Margin:         24px top

Disabled:       Until reason selected
```

### Footer Note
```
Text:           "Reports are reviewed within 24 hours"
Style:          Body S, Gray 500
Position:       Below button, centered
Margin:         12px top
```

---

## Validation

### Required
```
- Reason: Required (select one)
- Description: Required for "Other", recommended for others
- Related swap: Optional
```

### Description Rules
```
- Minimum 10 characters if provided
- Maximum 500 characters
- No profanity (basic filter)
```

---

## States

### Default
```
- User info displayed
- No reason selected
- Description empty
- Submit disabled
```

### Reason Selected
```
- Option highlighted
- Submit enabled (unless "Other" with no description)
```

### Submitting
```
- Button: Spinner + "Submitting..."
- Inputs disabled
- Cannot dismiss
```

### Success
```
┌─────────────────────────────────────┐
│                                     │
│         ✓                           │
│                                     │
│   Report Submitted                  │
│                                     │
│   Thank you for helping keep our    │
│   community safe. We'll review      │
│   your report and take appropriate  │
│   action.                           │
│                                     │
│   ┌─────────────────────────────┐   │
│   │          Done               │   │
│   └─────────────────────────────┘   │
│                                     │
│   What happens next?                │
│   • We'll investigate within 24h    │
│   • You may be contacted for more   │
│     information                     │
│   • Action will be taken if needed  │
│                                     │
└─────────────────────────────────────┘

On "Done":
  - Dismiss sheet
  - Return to previous screen
```

### Error
```
- Error message inline
- "Failed to submit report. Please try again."
- Retry button
```

---

## Report Context

### From Chat
```
If reporting from chat:
  - Include message ID
  - Option to include specific messages
  - "This report includes recent chat history"
```

### From Session
```
If reporting no-show from session:
  - Auto-select "No-show to session"
  - Pre-fill swap context
  - Include session details
```

### From Profile
```
If reporting from profile view:
  - General report
  - No swap context required
```

---

## What Happens After

### User Feedback
```
After submission:
  - User sees confirmation
  - No immediate action visible

Report reviewed:
  - If action taken: User may be notified
  - If no action: Silent (no notification)
```

### Reported User
```
- Not notified of report
- May see account action if warranted
- Prevents retaliation
```

---

## Animations

### Entry
```
- Slide from bottom
- Backdrop fade in
```

### Reason Selection
```
- Border transition
- Background fade
- Radio fill animation
```

### Success
```
- Checkmark scale in
- Content crossfade
- Confetti not appropriate here (serious action)
```

---

## Accessibility
- Reasons are radio button group
- Selection announced
- Description has clear label
- Success message announced
- Form validation errors announced
