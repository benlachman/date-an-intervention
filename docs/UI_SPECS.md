# UI Specifications

Detailed specifications for all UI components in Date An Intervention.

## Design System

### Colors

```swift
// Primary Colors
let accentPink = Color(hex: "#FF6B9D")
let accentOrange = Color(hex: "#FFA07A")
let accentPurple = Color(hex: "#C77DFF")
let accentTeal = Color(hex: "#00B4D8")

// Backgrounds
let backgroundLight = Color(hex: "#FFFFFF")
let backgroundCard = Color(hex: "#F8F9FA")
let backgroundDark = Color(hex: "#1A1A1A")

// Text
let textPrimary = Color(hex: "#2D3142")
let textSecondary = Color(hex: "#6C757D")
let textLight = Color(hex: "#FFFFFF")

// Feedback
let likeGreen = Color(hex: "#06D6A0")
let nopeRed = Color(hex: "#EF476F")
```

### Typography

```swift
// Headers
.font(.system(size: 32, weight: .bold, design: .rounded))  // Large Title
.font(.system(size: 24, weight: .bold, design: .rounded))  // Title
.font(.system(size: 20, weight: .semibold))                // Subtitle

// Body
.font(.system(size: 17, weight: .regular))                 // Body
.font(.system(size: 15, weight: .regular))                 // Caption
.font(.system(size: 13, weight: .medium))                  // Small Label

// Special
.font(.system(size: 18, weight: .semibold, design: .rounded)) // Button Text
```

### Spacing

```swift
let spacing = (
    xs: 4.0,
    sm: 8.0,
    md: 16.0,
    lg: 24.0,
    xl: 32.0,
    xxl: 48.0
)
```

### Corner Radius

```swift
let cornerRadius = (
    sm: 8.0,
    md: 12.0,
    lg: 20.0,
    xl: 28.0,
    card: 16.0
)
```

### Shadows

```swift
// Card Shadow
.shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

// Button Shadow
.shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)

// Modal Shadow
.shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
```

---

## Component Specifications

### 1. InterventionCardView

**Purpose**: Individual swipeable card showing intervention preview

**Layout**:
```
┌─────────────────────────────────┐
│                                 │
│         [Image/Symbol]          │ 40% of card height
│      with gradient bg           │
│                                 │
├─────────────────────────────────┤
│  Name, Age-style               │ 8%
│  "Strat, 28"                   │
├─────────────────────────────────┤
│  Category Badge                │ 8%
│  "Stratospheric/SRM"           │
├─────────────────────────────────┤
│  Impact Scale                  │ 8%
│  "🌍 Global Impact"            │
├─────────────────────────────────┤
│  Bio Preview                   │ 36%
│  "High-altitude dreamer..."    │
│  (2-3 lines, truncated)        │
└─────────────────────────────────┘
```

**Dimensions**:
- Width: 90% of screen width (max 400pt)
- Height: 65% of screen height (min 500pt)
- Corner Radius: 16pt
- Shadow: elevation medium

**States**:
- **Default**: Subtle shadow, white background
- **Dragging**: Increased shadow, slight scale (1.02x)
- **Threshold**: Overlay appears (LIKE or NOPE)

**Interactions**:
- Drag gesture with rotation (angle = offset.width / 20)
- Tap to expand to profile detail

**Accessibility**:
- Label: "{name}, {category}, {impactScale}"
- Hint: "Swipe right to like, left to pass, or tap to view profile"

---

### 2. CardStackView

**Purpose**: Stack of intervention cards with depth effect

**Layout**:
```
     ┌──────┐
    ┌┼──────┼┐
   ┌┼┼──────┼┼┐
   │││ Top  │││  ← Interactive
   │││ Card │││
   └┴┴──────┴┴┘
```

**Stack Configuration**:
- Show top 3-5 cards
- Card 0 (top): scale(1.0), offset(0, 0)
- Card 1: scale(0.95), offset(0, -20)
- Card 2: scale(0.90), offset(0, -40)
- Card 3+: hidden

**Z-Index**:
- Card 0: zIndex(100)
- Card 1: zIndex(99)
- Card 2: zIndex(98)

**Animations**:
- Card removal: spring(response: 0.5, dampingFraction: 0.7)
- Card reveal: spring(response: 0.4, dampingFraction: 0.75)
- Stack shift: linear(duration: 0.3)

---

### 3. ProfileDetailView

**Purpose**: Full-screen intervention profile

**Layout** (ScrollView):
```
┌─────────────────────────────────┐
│  [X Dismiss]                    │ Header (44pt)
├─────────────────────────────────┤
│                                 │
│     Image Carousel              │ 50% screen height
│     ○ ○ ● ○ ○                  │ Page indicators
│                                 │
├─────────────────────────────────┤
│  Name & Category                │ 60pt
│  "Strat"  "Stratospheric/SRM"  │
├─────────────────────────────────┤
│  Stats Grid                     │ 80pt
│  ┌──────┬──────┬──────┐        │
│  │Resch │ Tech │Supprt│        │
│  └──────┴──────┴──────┘        │
├─────────────────────────────────┤
│  About Section                  │ Variable
│  Bio paragraph(s)               │
├─────────────────────────────────┤
│  Interests Section              │ Variable
│  • Interest 1                   │
│  • Interest 2                   │
├─────────────────────────────────┤
│  Dealbreakers Section           │ Variable
│  • Dealbreaker 1                │
│  • Dealbreaker 2                │
├─────────────────────────────────┤
│                                 │ Bottom padding
│  [      Message Button      ]  │ 60pt
│                                 │
└─────────────────────────────────┘
```

**Specifications**:
- **Dismiss**: X button top-left or swipe-down gesture
- **Carousel**: Horizontal paging with page indicators below
- **Stats Grid**: 3 columns, icons + labels
- **Sections**: 24pt padding, 16pt spacing
- **Message Button**: Full width - 32pt margin, 52pt height, rounded

**Animations**:
- Modal presentation: slide up with spring
- Scroll bounce: enabled
- Image parallax: subtle (0.3x scroll speed)

---

### 4. ChatView

**Purpose**: Messaging interface with intervention persona

**Layout**:
```
┌─────────────────────────────────┐
│ < Back  [Avatar] Name          │ Nav bar (44pt)
├─────────────────────────────────┤
│                                 │
│  ┌─────────────┐               │ AI message
│  │ Hey there!  │               │ (left-aligned)
│  └─────────────┘               │
│                                 │
│               ┌─────────────┐  │ User message
│               │Hi! Tell me  │  │ (right-aligned)
│               │more...      │  │
│               └─────────────┘  │
│                                 │
│  ┌─────────────┐               │
│  │ I'd love to │               │
│  │ ...         │               │
│  └─────────────┘               │
│                                 │
├─────────────────────────────────┤
│ ┌─────────────────┐  [Send]   │ Input (60pt)
│ │ Type message... │            │
│ └─────────────────┘            │
└─────────────────────────────────┘
```

**Message Bubbles**:
- **User**: Blue (#007AFF), right-aligned, tail on right
- **AI**: Light gray (#E9ECEF), left-aligned, tail on left
- Max width: 75% of screen width
- Padding: 12pt vertical, 16pt horizontal
- Corner radius: 18pt (with tail cutout)

**Input Field**:
- Background: Light gray (#F2F2F7)
- Height: 36pt (grows to max 100pt)
- Corner radius: 18pt
- Send button: 44x44pt tap target

**Keyboard**:
- Avoid keyboard using `.keyboardAdaptive()` modifier
- Input moves up with keyboard
- Scroll view adjusts content inset

---

### 5. MatchesView

**Purpose**: Grid of all liked interventions

**Layout**:
```
┌─────────────────────────────────┐
│  Your Matches                   │ Title
├─────────────────────────────────┤
│  Stats Summary                  │
│  12 matches • 67% like rate     │ 60pt
│  Favorite: SRM                  │
├─────────────────────────────────┤
│  ┌───────┐  ┌───────┐          │
│  │ Card  │  │ Card  │          │ Grid
│  │   1   │  │   2   │          │ (2 cols)
│  └───────┘  └───────┘          │
│  ┌───────┐  ┌───────┐          │
│  │ Card  │  │ Card  │          │
│  │   3   │  │   4   │          │
│  └───────┘  └───────┘          │
│                                 │
└─────────────────────────────────┘
```

**Grid Specifications**:
- Columns: 2 (iPhone), 3+ (iPad)
- Spacing: 16pt
- Card aspect ratio: 3:4
- Card content: Image, name, category

**Empty State**:
```
┌─────────────────────────────────┐
│                                 │
│         [Heart Icon]            │
│                                 │
│    No matches yet!              │
│    Start swiping to find        │
│    interventions you like.      │
│                                 │
│    [Go to Swipe Deck]          │
│                                 │
└─────────────────────────────────┘
```

---

## Animation Specifications

### Swipe Animations

**Drag Animation**:
```swift
.rotationEffect(.degrees(dragAmount.width / 20))
.offset(x: dragAmount.width, y: dragAmount.height)
```

**Auto-Complete Swipe**:
```swift
withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
    offset = direction == .right ?
        CGPoint(x: 500, y: 0) :
        CGPoint(x: -500, y: 0)
}
```

**Card Removal**:
```swift
withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
    cards.removeFirst()
}
```

### Modal Transitions

**Present Profile**:
```swift
.transition(.move(edge: .bottom))
.animation(.spring(response: 0.4, dampingFraction: 0.8))
```

**Dismiss Profile**:
```swift
.gesture(
    DragGesture()
        .onEnded { value in
            if value.translation.height > 100 {
                dismiss()
            }
        }
)
```

### Button Animations

**Press Animation**:
```swift
.scaleEffect(isPressed ? 0.95 : 1.0)
.animation(.spring(response: 0.3), value: isPressed)
```

---

## Accessibility

### VoiceOver Labels

- **Cards**: "{name}, {category}, {impact scale}. Swipe right to like, left to pass, or double-tap to view full profile."
- **Like Button**: "Like {intervention name}"
- **Pass Button**: "Pass on {intervention name}"
- **Message Button**: "Send message to {intervention name}"
- **Stats**: "{stat name}: {stat value}"

### Dynamic Type

All text should support Dynamic Type scaling. Use:
```swift
.font(.body)  // Not .font(.system(size: 17))
```

### Color Contrast

- Text on light background: Minimum 4.5:1 ratio
- Text on dark background: Minimum 4.5:1 ratio
- Interactive elements: Minimum 3:1 ratio

### Haptic Feedback

- Light impact: Swipe threshold reached
- Medium impact: Card swiped
- Success: Match made
- Selection: Button tap

---

## Responsive Design

### iPhone SE (Small)
- Card width: 90% screen width
- Reduce vertical spacing by 20%
- Font sizes: Use Dynamic Type

### iPhone Standard (13, 14, 15)
- Card width: 90% screen width
- Standard spacing
- Standard font sizes

### iPhone Pro Max (Large)
- Card width: 85% screen width (max 400pt)
- Standard spacing
- Standard font sizes

### iPad
- Card width: 500pt max
- Matches grid: 3-4 columns
- Consider split view for profile + chat
- Larger hit targets (60x60pt minimum)

---

## Loading States

### Card Stack Loading
```
┌─────────────────────────────────┐
│                                 │
│       ProgressView()            │
│    Loading interventions...     │
│                                 │
└─────────────────────────────────┘
```

### Chat Message Sending
- Typing indicator (three dots animation)
- Disable input field
- Show activity indicator in send button

### Image Loading
- Placeholder with gradient
- Smooth fade-in when loaded
- Fallback to SF Symbol if load fails

---

## Error States

### No Internet
```
┌─────────────────────────────────┐
│      [Cloud.slash icon]         │
│                                 │
│   No internet connection        │
│   Chat requires internet        │
│                                 │
│      [Try Again]                │
└─────────────────────────────────┘
```

### API Error
```
┌─────────────────────────────────┐
│      [Exclamationmark]          │
│                                 │
│   Couldn't send message         │
│   Please try again              │
│                                 │
│      [Retry]                    │
└─────────────────────────────────┘
```

### Empty Data
```
┌─────────────────────────────────┐
│      [Tray icon]                │
│                                 │
│   No interventions found        │
│   Something went wrong          │
│                                 │
│      [Reload]                   │
└─────────────────────────────────┘
```

---

## Platform Considerations

### iOS 18 Specific Features
- Use latest SwiftUI features
- Leverage improved animations
- Support dark mode automatically
- Use new SF Symbols

### Safe Area
- Always respect safe area insets
- Bottom buttons: 16pt above safe area
- Content: Within safe area or explicit ignoring

### Orientation
- Primary: Portrait only for iPhone
- iPad: Support all orientations
- Lock rotation for swipe deck (portrait only)

---

This specification should be referenced when implementing all UI components to ensure consistency and quality.
