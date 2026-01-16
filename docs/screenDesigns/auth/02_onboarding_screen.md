# Onboarding Screen

## Overview
A welcoming carousel that introduces new users to the app's core value proposition. Three slides explain the concept before prompting sign-up.

---

## Visual Design

### Layout Structure
```
┌─────────────────────────────────────┐
│ [Skip]                              │
│                                     │
│                                     │
│         ┌───────────────┐           │
│         │               │           │
│         │  ILLUSTRATION │           │
│         │    (280px)    │           │
│         │               │           │
│         └───────────────┘           │
│                                     │
│         Headline Text               │
│                                     │
│      Supporting description         │
│       text that explains the        │
│         feature briefly             │
│                                     │
│            ● ○ ○                    │
│                                     │
│    ┌─────────────────────────┐      │
│    │     Get Started         │      │
│    └─────────────────────────┘      │
│                                     │
│      Already have an account?       │
│            Sign In                  │
│                                     │
└─────────────────────────────────────┘
```

### Header
- **Skip Button**
  - Position: Top right, 16px from edges
  - Style: Text Button
  - Text: "Skip" (Body M, Gray 500)
  - Action: Jump to last slide or auth options

---

## Slide Content

### Slide 1: Value Proposition
```
Illustration: Two people exchanging glowing skill bubbles
             (Guitar ↔ Code symbols)

Headline:     "Trade Skills, Not Money"
              H1, Gray 900, center-aligned

Description:  "Exchange your expertise with others.
              Teach what you know, learn what you love."
              Body L, Gray 600, center-aligned, max 280px width
```

### Slide 2: How It Works
```
Illustration: Clock/timer with "+1" credit floating up

Headline:     "Time is Your Currency"
              H1, Gray 900, center-aligned

Description:  "1 hour of teaching = 1 credit earned.
              Use credits to learn any skill from anyone."
              Body L, Gray 600, center-aligned
```

### Slide 3: Community
```
Illustration: Grid of diverse avatar faces with skill icons

Headline:     "Join the Community"
              H1, Gray 900, center-aligned

Description:  "Connect with passionate people ready to
              share their knowledge. Start with 1 free credit!"
              Body L, Gray 600, center-aligned
```

---

## Components

### Illustration Container
- **Size**: 280px × 280px
- **Position**: Center, 80px from top
- **Style**:
  - Flat illustration style
  - Primary and Secondary color palette
  - Subtle shadows for depth
  - No heavy gradients

### Page Indicator
- **Type**: Smooth dots
- **Active Dot**: 24px wide × 8px tall, Primary Blue, rounded
- **Inactive Dot**: 8px × 8px, Gray 300, circle
- **Spacing**: 8px between dots
- **Position**: 32px below description

### Primary CTA Button
- **Text**:
  - Slides 1-2: "Next"
  - Slide 3: "Get Started"
- **Style**: Primary Button (full width with 20px margins)
- **Position**: 32px from bottom (above sign-in text)

### Secondary Link
- **Text**: "Already have an account? **Sign In**"
- **Style**: Body M, Gray 600 with Primary Blue for "Sign In"
- **Position**: 16px below primary button
- **Only visible on**: Slide 3 (or all slides)

---

## Interactions

### Swipe Gesture
- Horizontal swipe to navigate between slides
- Velocity-based: Fast swipe advances, slow returns
- Bounce effect at boundaries

### Page Transition
```
Outgoing Slide:
  - Opacity: 1 → 0.3
  - TranslateX: 0 → -50px
  - Scale: 1 → 0.95

Incoming Slide:
  - Opacity: 0 → 1
  - TranslateX: 50px → 0
  - Scale: 0.95 → 1

Duration: 300ms
Easing: ease-out
```

### Illustration Animation
Each illustration has subtle idle animation:
- Slide 1: Skill bubbles gently float up and down
- Slide 2: Credit "+1" pulses softly
- Slide 3: Avatars have subtle breathing scale effect

### Button Transitions
```
"Next" → "Get Started" on Slide 3:
  - Crossfade text
  - Brief scale pulse (1 → 1.02 → 1)
```

---

## States

### First Visit
- Start from Slide 1
- Mark onboarding as "seen" when completed

### Return Visit (Pre-Auth)
- Skip onboarding, go directly to Login
- User can access via "Learn More" in settings

---

## Responsive Behavior

### Small Screens (< 375px width)
- Reduce illustration to 240px
- Reduce headline to H2 size
- Tighter spacing

### Large Screens (Tablets)
- Cap content width at 400px
- Center content horizontally
- Larger illustrations (360px)

---

## Accessibility
- Each slide has unique accessible label
- Swipe gesture has button alternative
- Page indicator announces "Page X of 3"
- Illustrations have descriptive alt text
- Supports VoiceOver/TalkBack navigation
