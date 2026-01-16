# Skill Swap - Design System

## Brand Identity

### Brand Personality
- **Friendly** - Approachable and welcoming
- **Modern** - Clean, contemporary aesthetic
- **Trustworthy** - Professional and reliable
- **Community-focused** - Collaborative spirit

### Design Principles
1. **Clarity First** - Every element serves a purpose
2. **Effortless Navigation** - Intuitive user journeys
3. **Delightful Interactions** - Subtle animations that feel natural
4. **Accessible Design** - Inclusive for all users

---

## Color Palette

### Primary Colors
```
Primary Blue:      #4F46E5 (Indigo 600)
Primary Light:     #818CF8 (Indigo 400)
Primary Dark:      #3730A3 (Indigo 800)
Primary Surface:   #EEF2FF (Indigo 50)
```

### Secondary Colors
```
Secondary Teal:    #14B8A6 (Teal 500)
Secondary Light:   #5EEAD4 (Teal 300)
Secondary Dark:    #0F766E (Teal 700)
```

### Semantic Colors
```
Success:           #10B981 (Emerald 500)
Success Light:     #D1FAE5 (Emerald 100)

Warning:           #F59E0B (Amber 500)
Warning Light:     #FEF3C7 (Amber 100)

Error:             #EF4444 (Red 500)
Error Light:       #FEE2E2 (Red 100)

Info:              #3B82F6 (Blue 500)
Info Light:        #DBEAFE (Blue 100)
```

### Neutral Colors
```
Gray 900:          #111827 (Primary text)
Gray 700:          #374151 (Secondary text)
Gray 500:          #6B7280 (Tertiary text)
Gray 400:          #9CA3AF (Placeholder)
Gray 300:          #D1D5DB (Borders)
Gray 200:          #E5E7EB (Dividers)
Gray 100:          #F3F4F6 (Backgrounds)
Gray 50:           #F9FAFB (Surface)
White:             #FFFFFF
```

### Gradient
```
Primary Gradient:  linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%)
Card Gradient:     linear-gradient(180deg, #FFFFFF 0%, #F9FAFB 100%)
```

---

## Typography

### Font Family
```
Primary:    Inter (Google Fonts)
Fallback:   SF Pro Display, -apple-system, BlinkMacSystemFont, sans-serif
```

### Type Scale
```
Display:    32px / 40px line-height / -0.5px tracking / Bold (700)
H1:         28px / 36px line-height / -0.3px tracking / Bold (700)
H2:         24px / 32px line-height / -0.2px tracking / SemiBold (600)
H3:         20px / 28px line-height / 0 tracking / SemiBold (600)
H4:         18px / 24px line-height / 0 tracking / Medium (500)
Body L:     16px / 24px line-height / 0 tracking / Regular (400)
Body M:     14px / 20px line-height / 0 tracking / Regular (400)
Body S:     12px / 16px line-height / 0.1px tracking / Regular (400)
Caption:    11px / 14px line-height / 0.2px tracking / Medium (500)
Button:     14px / 20px line-height / 0.3px tracking / SemiBold (600)
```

---

## Spacing System

### Base Unit: 4px

```
space-0:    0px
space-1:    4px
space-2:    8px
space-3:    12px
space-4:    16px
space-5:    20px
space-6:    24px
space-8:    32px
space-10:   40px
space-12:   48px
space-16:   64px
space-20:   80px
```

### Screen Padding
```
Horizontal: 20px (space-5)
Vertical:   16px (space-4)
```

---

## Border Radius

```
radius-xs:   4px   (small chips, tags)
radius-sm:   8px   (buttons, inputs)
radius-md:   12px  (cards)
radius-lg:   16px  (modals, bottom sheets)
radius-xl:   24px  (large cards)
radius-full: 9999px (avatars, pills)
```

---

## Shadows

```
shadow-xs:   0 1px 2px rgba(0, 0, 0, 0.05)
shadow-sm:   0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06)
shadow-md:   0 4px 6px rgba(0, 0, 0, 0.1), 0 2px 4px rgba(0, 0, 0, 0.06)
shadow-lg:   0 10px 15px rgba(0, 0, 0, 0.1), 0 4px 6px rgba(0, 0, 0, 0.05)
shadow-xl:   0 20px 25px rgba(0, 0, 0, 0.1), 0 10px 10px rgba(0, 0, 0, 0.04)
```

---

## Components

### Buttons

#### Primary Button
```
Background:     Primary Blue (#4F46E5)
Text:           White
Height:         52px
Padding:        16px 24px
Border Radius:  12px
Shadow:         shadow-sm

Hover:          Primary Dark (#3730A3)
Pressed:        Primary Dark + scale(0.98)
Disabled:       Gray 300 bg, Gray 500 text
Loading:        Spinner + "Loading..."
```

#### Secondary Button
```
Background:     White
Border:         1.5px Primary Blue
Text:           Primary Blue
Height:         52px
Padding:        16px 24px
Border Radius:  12px

Hover:          Primary Surface bg
Pressed:        scale(0.98)
```

#### Text Button
```
Background:     Transparent
Text:           Primary Blue
Height:         40px
Padding:        8px 16px

Hover:          Primary Surface bg
```

#### Icon Button
```
Size:           44px x 44px
Border Radius:  radius-full
Background:     Transparent

Hover:          Gray 100 bg
Active:         Gray 200 bg
```

### Input Fields

#### Text Input
```
Height:         56px
Background:     White
Border:         1.5px Gray 300
Border Radius:  12px
Padding:        16px
Text:           Body L, Gray 900
Placeholder:    Body L, Gray 400

Focus:          Border Primary Blue, shadow-sm with primary tint
Error:          Border Error Red, Error Light bg
Success:        Border Success Green
```

#### Search Input
```
Height:         48px
Background:     Gray 100
Border:         None
Border Radius:  radius-full
Padding:        12px 16px 12px 44px (icon space)
Left Icon:      Search icon, Gray 400
```

### Cards

#### User Card
```
Background:     White
Border Radius:  16px
Shadow:         shadow-sm
Padding:        16px
Border:         1px Gray 200

Hover:          shadow-md, translateY(-2px)
```

#### Stat Card
```
Background:     Primary Surface
Border Radius:  12px
Padding:        16px
```

### Chips/Tags

#### Skill Chip
```
Height:         32px
Background:     Primary Surface
Text:           Primary Blue, Body S
Border Radius:  radius-full
Padding:        6px 12px
```

#### Status Badge
```
Height:         24px
Border Radius:  radius-full
Padding:        4px 10px
Font:           Caption, SemiBold

Pending:        Warning Light bg, Warning text
Active:         Success Light bg, Success text
Completed:      Gray 200 bg, Gray 700 text
```

### Avatar

```
Sizes:
  XS:    32px
  SM:    40px
  MD:    48px
  LG:    64px
  XL:    80px
  XXL:   120px

Border:         2px White
Shadow:         shadow-sm
Default:        Primary Surface bg, Primary Blue icon
Online:         8px green dot, bottom-right
```

### Bottom Navigation

```
Height:         64px + safe area
Background:     White
Border Top:     1px Gray 200
Shadow:         shadow-lg (inverted)

Item:
  Icon Size:    24px
  Label:        Caption
  Active:       Primary Blue
  Inactive:     Gray 400

Active Indicator: 4px dot above icon
```

### Tab Bar

```
Height:         48px
Background:     Transparent

Tab:
  Padding:      12px 16px
  Text:         Button size
  Active:       Primary Blue + 2px bottom border
  Inactive:     Gray 500
```

---

## Iconography

### Style
- **Library**: Lucide Icons (consistent with modern Flutter apps)
- **Stroke Width**: 1.5px
- **Size**: 24px default, 20px small, 32px large
- **Corner Radius**: 2px on corners

### Key Icons
```
Home:           home
Search:         search
Matches:        repeat (swap icon)
Chat:           message-circle
Wallet:         wallet
Profile:        user
Settings:       settings
Notification:   bell
Add:            plus
Check:          check
Close:          x
Arrow Back:     arrow-left
Arrow Right:    chevron-right
Star:           star
Star Filled:    star (filled)
Clock:          clock
Calendar:       calendar
Video:          video
Send:           send
Camera:         camera
Image:          image
```

---

## Animations & Transitions

### Duration
```
instant:    0ms
fast:       150ms
normal:     250ms
slow:       400ms
```

### Easing
```
ease-out:       cubic-bezier(0, 0, 0.2, 1)     - Enter animations
ease-in:        cubic-bezier(0.4, 0, 1, 1)     - Exit animations
ease-in-out:    cubic-bezier(0.4, 0, 0.2, 1)   - Standard
spring:         cubic-bezier(0.34, 1.56, 0.64, 1) - Bouncy
```

### Common Animations
```
Page Transition:    Slide from right, 250ms, ease-out
Modal:              Slide from bottom + fade, 250ms
Bottom Sheet:       Slide from bottom, 250ms
Card Tap:           Scale to 0.98, 150ms
Button Tap:         Scale to 0.95, 100ms
Skeleton:           Shimmer effect, 1.5s loop
Pull to Refresh:    Custom spring animation
```

---

## Layout Patterns

### Safe Areas
```
Top:        Status bar height (variable)
Bottom:     Home indicator height (34px on notched devices)
```

### Screen Structure
```
┌─────────────────────────────┐
│      Status Bar             │
├─────────────────────────────┤
│      App Bar (56px)         │
├─────────────────────────────┤
│                             │
│                             │
│      Content Area           │
│      (scrollable)           │
│                             │
│                             │
├─────────────────────────────┤
│      Bottom Nav (64px)      │
│      + Safe Area            │
└─────────────────────────────┘
```

### Grid System
```
Columns:    4 (mobile)
Gutter:     16px
Margin:     20px
```

---

## Accessibility

### Touch Targets
- Minimum size: 44px x 44px
- Adequate spacing between interactive elements

### Color Contrast
- Text on background: minimum 4.5:1
- Large text: minimum 3:1
- UI components: minimum 3:1

### Text
- Minimum font size: 11px
- Support for system font scaling

### Focus States
- Visible focus rings for keyboard navigation
- 2px Primary Blue outline with 2px offset
