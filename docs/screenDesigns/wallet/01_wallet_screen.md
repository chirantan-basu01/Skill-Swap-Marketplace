# Wallet Screen

## Overview
Displays credit balance and transaction history. Central place for users to understand their time-banking economy.

---

## Visual Design

### Layout
```
┌─────────────────────────────────────┐
│             My Wallet               │
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │                               │  │
│  │        💰                     │  │
│  │                               │  │
│  │       2.5                     │  │
│  │      credits                  │  │
│  │                               │  │
│  │  ┌─────────┐  ┌─────────┐     │  │
│  │  │+3.0     │  │-0.5     │     │  │
│  │  │earned   │  │spent    │     │  │
│  │  └─────────┘  └─────────┘     │  │
│  │                               │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 💡 Earn more credits by       │  │
│  │    teaching your skills!      │  │
│  │              [Start Teaching] │  │
│  └───────────────────────────────┘  │
│                                     │
│  Transaction History                │
│                                     │
│  Today                              │
│  ┌───────────────────────────────┐  │
│  │ ↗ +1.0  Taught Guitar         │  │
│  │         to Sarah M.           │  │
│  │         2:30 PM               │  │
│  └───────────────────────────────┘  │
│                                     │
│  Yesterday                          │
│  ┌───────────────────────────────┐  │
│  │ ↙ -0.5  Learned Python        │  │
│  │         from John D.          │  │
│  │         4:15 PM               │  │
│  └───────────────────────────────┘  │
│                                     │
│  January 10                         │
│  ┌───────────────────────────────┐  │
│  │ 🎁 +1.0  Welcome Bonus        │  │
│  │         Account created       │  │
│  │         10:00 AM              │  │
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
Title:          "My Wallet"
Style:          H3, Gray 900, centered
Height:         56px
Background:     Transparent (blends with card)
```

### Balance Card
```
Container:
  - Background: Primary Gradient
  - Border Radius: 24px
  - Padding: 24px
  - Margin: 20px horizontal
  - Shadow: shadow-lg

Layout:
┌───────────────────────────────────────┐
│                                       │
│            💰                         │
│                                       │
│           2.5                         │
│         credits                       │
│                                       │
│   ┌──────────┐    ┌──────────┐       │
│   │  +3.0    │    │  -0.5    │       │
│   │  earned  │    │  spent   │       │
│   └──────────┘    └──────────┘       │
│                                       │
└───────────────────────────────────────┘

Wallet Icon:
  - Size: 48px
  - Color: White with opacity
  - Or animated coin/wallet graphic

Balance:
  - Number: Display (48px), White, Bold
  - Label: "credits" Body L, White (70% opacity)
  - Animation: Count up on load

Stat Boxes:
  - Background: White with 15% opacity
  - Border Radius: 12px
  - Padding: 12px 16px
  - Side by side, equal width

  Earned:
    - "+X.X" H4, White
    - "earned" Caption, White (70% opacity)
    - Green tint (optional)

  Spent:
    - "-X.X" H4, White
    - "spent" Caption, White (70% opacity)
```

### Prompt Card (When Balance Low)
```
Visibility:     When balance < 1.0 credit

Container:
  - Background: Warning Light
  - Border: 1px Warning
  - Border Radius: 12px
  - Padding: 16px
  - Margin: 16px horizontal

Layout:
┌───────────────────────────────────────┐
│ 💡 Earn more credits by teaching     │
│    your skills to others!            │
│                         [Start →]    │
└───────────────────────────────────────┘

Icon:           Lightbulb or tip icon
Text:           Body M, Gray 800
Button:         Text button, Primary Blue
Action:         Navigate to Profile → Skills section
```

### Transaction History Section
```
Header:
  - Text: "Transaction History"
  - Style: H4, Gray 900
  - Margin: 24px top, 20px horizontal
```

### Date Group Header
```
Text:           "Today", "Yesterday", or "January 10"
Style:          Body S, SemiBold, Gray 500
Margin:         16px top, 20px horizontal
```

### Transaction Item
```
Container:
  - Background: White
  - Border Bottom: 1px Gray 100
  - Padding: 16px 20px
  - Tap: View details (optional)

Layout:
┌───────────────────────────────────────┐
│ [Icon]  +1.0    Taught Guitar        │
│                 to Sarah M.          │
│                 2:30 PM              │
└───────────────────────────────────────┘

Direction Icon:
  - Earned: ↗ Arrow up-right, Success Green bg
  - Spent: ↙ Arrow down-left, Gray 400 bg
  - Bonus: 🎁 Gift icon, Primary Blue bg
  - Size: 36px circle
  - Icon: 20px

Amount:
  - Earned: "+X.X" Body L, SemiBold, Success Green
  - Spent: "-X.X" Body L, SemiBold, Gray 600
  - Position: Next to icon

Description:
  - Primary: "Taught Guitar" or "Learned Python"
  - Secondary: "to/from [Name]"
  - Style: Body M (primary), Body S Gray 500 (secondary)

Timestamp:
  - Style: Body S, Gray 400
  - Position: Below description

Transaction Types:
  1. welcome_bonus: "🎁 Welcome Bonus" | "Account created"
  2. swap_earned: "↗ Taught [Skill]" | "to [Name]"
  3. swap_spent: "↙ Learned [Skill]" | "from [Name]"
```

---

## Transaction Detail (Bottom Sheet)

### On Tap
```
┌─────────────────────────────────────┐
│                                     │
│  ━━━━━  (handle)                    │
│                                     │
│  Transaction Details                │
│                                     │
│  ┌───────────────────────────────┐  │
│  │                               │  │
│  │       +1.0 credits            │  │
│  │       Taught Guitar           │  │
│  │                               │  │
│  └───────────────────────────────┘  │
│                                     │
│  Partner                            │
│  ┌────┐                             │
│  │Ava │ Sarah Martinez              │
│  └────┘                             │
│                                     │
│  Session Details                    │
│  Duration:        1 hour            │
│  Date:            Jan 15, 2024      │
│  Time:            2:30 PM           │
│                                     │
│  Your Balance                       │
│  Before:          1.5 credits       │
│  After:           2.5 credits       │
│                                     │
│  ┌─────────────────────────────┐    │
│  │      View Swap Details       │   │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

---

## States

### Loading
```
- Balance card: Shimmer
- Transactions: Shimmer placeholders (4-5 items)
```

### Empty Transactions
```
Only welcome bonus:

┌─────────────────────────────────────┐
│                                     │
│  Transaction History                │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 🎁 +1.0  Welcome Bonus        │  │
│  └───────────────────────────────┘  │
│                                     │
│         📊                          │
│                                     │
│   Your first transaction!           │
│   Complete a swap to see more       │
│   activity here.                    │
│                                     │
│   [Find a Swap Partner]             │
│                                     │
└─────────────────────────────────────┘
```

### Error
```
- Balance card still visible (cached)
- Transactions: Error with retry
```

---

## Animations

### Balance Card Entry
```
- Slide down + fade in
- Duration: 300ms
- Balance number counts up from 0
```

### Balance Update
```
When new transaction:
  - Old number fades
  - New number counts to new value
  - Brief highlight pulse
```

### Transaction Entry
```
New transaction appears at top:
  - Slides down from top
  - Other items slide down
  - Brief highlight on new item
```

### Pull to Refresh
```
- Refresh indicator
- Reloads transactions
- Balance updates
```

---

## Statistics (Optional Enhancement)

### Stats Row
```
Below balance card:

┌─────────────────────────────────────┐
│  This Month                         │
│  ┌─────────┐ ┌─────────┐ ┌───────┐  │
│  │ 3       │ │ 4.5hrs  │ │ ★4.9  │  │
│  │ swaps   │ │exchanged│ │rating │  │
│  └─────────┘ └─────────┘ └───────┘  │
└─────────────────────────────────────┘

Small stat cards showing monthly activity
```

---

## Accessibility
- Balance announced with "2.5 credits"
- Transactions have complete descriptions
- Earned/spent clearly distinguished
- Pull to refresh announced
- Transaction details accessible
