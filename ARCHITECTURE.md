# Architecture

This document outlines the technical architecture and design decisions for Date An Intervention.

## Overview

Date An Intervention is a native iOS app built with SwiftUI and SwiftData, featuring a card-based swipe interface for exploring climate interventions. The architecture follows MVVM (Model-View-ViewModel) patterns with clear separation of concerns.

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         SwiftUI Views                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────────┐ │
│  │  Swipe   │  │ Profile  │  │   Chat   │  │   Matches   │ │
│  │  Stack   │  │  Detail  │  │   View   │  │    View     │ │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └──────┬──────┘ │
└───────┼────────────┼──────────────┼────────────────┼────────┘
        │            │              │                │
        ▼            ▼              ▼                ▼
┌─────────────────────────────────────────────────────────────┐
│                        ViewModels                            │
│  ┌──────────────────┐           ┌──────────────────────┐    │
│  │  SwipeViewModel  │           │   ChatViewModel      │    │
│  │  - Card stack    │           │   - Messages         │    │
│  │  - Swipe logic   │           │   - LLM integration  │    │
│  └────────┬─────────┘           └──────────┬───────────┘    │
└───────────┼────────────────────────────────┼────────────────┘
            │                                │
            ▼                                ▼
┌─────────────────────────────────────────────────────────────┐
│                      Services Layer                          │
│  ┌──────────────────────────────────┐  ┌─────────────────┐  │
│  │        SwiftData Store           │  │   LLM Service   │  │
│  │  - Interventions                 │  │  - API client   │  │
│  │  - SwipeDecisions                │  │  - Chat logic   │  │
│  │  - ChatMessages                  │  │                 │  │
│  └──────────────────────────────────┘  └─────────────────┘  │
└─────────────────────────────────────────────────────────────┘
            │                                │
            ▼                                ▼
┌─────────────────────┐          ┌───────────────────────────┐
│    Local Storage    │          │    External API           │
│  (SwiftData/SQLite) │          │  (OpenAI/Anthropic)       │
└─────────────────────┘          └───────────────────────────┘
```

## Core Components

### 1. Data Layer

#### Models (SwiftData)

**Intervention**
```swift
@Model
class Intervention {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: InterventionCategory
    var bio: String
    var interests: [String]          // Pros as interests
    var dealbreakers: [String]        // Cons as dealbreakers
    var personalityTraits: [String]
    var conversationStyle: String
    var impactScale: String          // "Local", "Regional", "Global"
    var researchLevel: String        // "Early", "Active", "Established"
    var techReadiness: String        // "Conceptual", "Pilot", "Deployable"
    var supportLevel: String         // "Controversial", "Mixed", "Supported"
    var imageName: String?           // Optional climate photo
    var symbolName: String           // SF Symbol fallback
    var gradientColors: [String]     // Hex colors for gradient
    var chatContext: String          // Background info for LLM
}
```

**InterventionCategory**
```swift
enum InterventionCategory: String, Codable {
    case srm = "Stratospheric/SRM"
    case ocean = "Ocean-Based"
    case ice = "Ice Preservation"
    case land = "Land-Based"
    case localized = "Localized"
}
```

**SwipeDecision**
```swift
@Model
class SwipeDecision {
    @Attribute(.unique) var id: UUID
    var interventionId: UUID
    var liked: Bool
    var timestamp: Date
}
```

**ChatMessage**
```swift
@Model
class ChatMessage {
    @Attribute(.unique) var id: UUID
    var interventionId: UUID
    var content: String
    var isFromUser: Bool
    var timestamp: Date
}
```

#### Data Store

- **SwiftData ModelContainer**: Manages all persistent storage
- **ModelContext**: Injected into SwiftUI environment
- **Seeding**: Pre-populate interventions on first launch
- **Queries**: @Query property wrappers for reactive data

### 2. View Layer

#### Swipe Interface

**CardStackView**
- Displays stack of intervention cards (top 3-5 visible)
- Manages z-index and scale for depth effect
- Handles card removal animations
- Tracks current card index

**InterventionCardView**
- Individual swipeable card
- Drag gesture with rotation based on offset
- Threshold detection for auto-swipe
- Haptic feedback on key events
- Like/dislike overlay indicators
- Tap gesture to show profile

#### Profile View

**ProfileDetailView**
- Full-screen modal presentation
- ScrollView with:
  - Image carousel (climate photos + SF Symbol gradients)
  - Name and category badge
  - Bio section
  - Stats grid (research, tech, support)
  - Interests list (pros)
  - Dealbreakers list (cons)
- Large "Message" button at bottom
- Dismiss gesture

#### Chat Interface

**ChatView**
- Message list with ScrollView
- User messages (right-aligned, blue)
- AI messages (left-aligned, gray)
- Text input field at bottom
- Send button
- Typing indicator during API calls
- Auto-scroll to bottom on new messages

#### Matches Screen

**MatchesView**
- Grid of liked interventions
- Thumbnail cards showing name + image
- Tap to view profile or resume chat
- Stats summary at top:
  - Total swiped
  - Like percentage
  - Favorite category

### 3. ViewModel Layer

#### SwipeViewModel

```swift
@Observable
class SwipeViewModel {
    var interventions: [Intervention]
    var currentIndex: Int
    var swipeDecisions: [SwipeDecision]

    func swipeRight(on intervention: Intervention)
    func swipeLeft(on intervention: Intervention)
    func getCurrentCard() -> Intervention?
    func hasMoreCards() -> Bool
}
```

Responsibilities:
- Manage card deck state
- Handle swipe logic
- Save decisions to SwiftData
- Provide next intervention

#### ChatViewModel

```swift
@Observable
class ChatViewModel {
    var messages: [ChatMessage]
    var isLoading: Bool
    var intervention: Intervention

    func sendMessage(_ content: String) async
    func loadHistory()
}
```

Responsibilities:
- Manage chat state for specific intervention
- Interface with LLMService
- Save/load messages from SwiftData
- Handle loading states

### 4. Services Layer

#### LLMService

```swift
class LLMService {
    private let apiKey: String
    private let endpoint: URL

    func generateResponse(
        intervention: Intervention,
        conversationHistory: [ChatMessage],
        userMessage: String
    ) async throws -> String
}
```

Features:
- Support for OpenAI and Anthropic APIs
- System prompt generation based on intervention
- Conversation history management
- Error handling for network/API failures
- Response streaming (future enhancement)

**System Prompt Template**:
```
You are {intervention.name}, a climate intervention on a dating app.

Background: {intervention.chatContext}

Personality: {intervention.personalityTraits}
Conversation style: {intervention.conversationStyle}

Your interests (strengths): {intervention.interests}
Your dealbreakers (limitations): {intervention.dealbreakers}

Respond as if you're chatting on a dating app:
- Be playful and flirty but informative
- Use climate-related double entendres
- Stay in character as this intervention
- Be honest about your limitations
- Keep responses 2-3 sentences unless asked for detail
```

## Data Flow

### Swiping Flow

1. User drags card → Gesture updates offset/rotation
2. User releases → ViewModel calculates direction
3. If threshold exceeded → `swipeRight()` or `swipeLeft()`
4. ViewModel creates `SwipeDecision` → Saves to SwiftData
5. View animates card removal
6. Next card appears

### Chat Flow

1. User types message → Taps send
2. ChatViewModel adds user message to local array
3. ChatViewModel saves message to SwiftData
4. ChatViewModel calls LLMService with context
5. LLMService builds system prompt from intervention data
6. LLMService sends API request
7. Response received → Added to messages
8. Response saved to SwiftData
9. View updates with new message

### Data Persistence Flow

1. App launches → SwiftData ModelContainer initialized
2. Check if interventions exist
3. If empty → Seed database with 30+ interventions
4. Views access data via @Query
5. ViewModels modify data → Saves automatic via context
6. All changes persisted to local SQLite

## UI/UX Design Patterns

### Dating App Aesthetic

- **Color Scheme**: Warm gradients (pink, orange, purple)
- **Typography**: San Francisco (system font), playful weights
- **Imagery**: Mix of climate photos and abstract SF Symbol compositions
- **Animations**: Spring-based, playful bounce
- **Haptics**: Light impact on swipe threshold, success on match

### Gesture Interactions

- **Swipe**: Drag to rotate/move card, release to commit
- **Tap**: Show full profile
- **Swipe down**: Dismiss profile modal
- **Pull to refresh**: Reset deck (future)

### Layout

- **Cards**: 90% screen width, rounded corners, shadow
- **Profile**: Full screen modal with safe area insets
- **Chat**: Standard messaging layout, keyboard-aware
- **Matches**: Grid with 2 columns on iPhone, 3+ on iPad

## Performance Considerations

### Optimizations

1. **Lazy Loading**: Only render visible cards in stack
2. **Image Caching**: Cache downloaded climate photos
3. **SwiftData Batching**: Fetch interventions in chunks if needed
4. **Animation Performance**: Use `.drawingGroup()` for complex card stacks
5. **API Rate Limiting**: Debounce rapid chat messages

### Memory Management

- Limit visible cards to 5 max
- Release off-screen card views
- Clear old chat messages beyond certain limit
- Use weak references in closures

## Security Considerations

### API Key Protection

- Store API key in `.env` file (gitignored)
- Never commit keys to repository
- Load from environment or config at runtime
- Consider iOS Keychain for production

### Data Privacy

- All data stored locally (SwiftData)
- No analytics or tracking
- No server-side storage
- Chat history is local-only

## Testing Strategy

### Unit Tests

- ViewModel logic (swipe decisions, card management)
- LLMService API integration (mocked)
- Data model validation

### UI Tests

- Swipe gestures
- Profile navigation
- Chat flow
- Matches screen

### Integration Tests

- SwiftData persistence
- API calls (with test doubles)
- End-to-end swipe → match → chat flow

## Future Enhancements

### Phase 2 Features

- [ ] Filter interventions by category before swiping
- [ ] Share matches via social media
- [ ] Compare two interventions side-by-side
- [ ] Educational "About" section
- [ ] Intervention compatibility quiz

### Technical Improvements

- [ ] Offline mode with cached responses
- [ ] Response streaming for chat
- [ ] Accessibility improvements (VoiceOver, Dynamic Type)
- [ ] iPad optimizations (split view)
- [ ] macOS version (via Catalyst)

## Dependencies

### Swift Package Manager

- No external dependencies planned initially
- All features use native iOS frameworks:
  - SwiftUI
  - SwiftData
  - Combine
  - Foundation

### Potential Future Dependencies

- `Kingfisher` for advanced image loading
- `MarkdownUI` for rich text in profiles
- Custom analytics (privacy-focused)

## Build Configuration

### Targets

- **DateAnIntervention**: Main app target
- **DateAnInterventionTests**: Unit tests
- **DateAnInterventionUITests**: UI tests

### Build Settings

- iOS Deployment Target: 18.0
- Swift Language Version: 6.0
- Enable strict concurrency checking
- Warnings as errors (SwiftLint)

### Configuration Files

- `.env` for API keys (gitignored)
- `Config.xcconfig` for build-time settings

## File Structure

```
DateAnIntervention/
├── DateAnInterventionApp.swift      # App entry point
├── App/
│   └── ContentView.swift            # Root navigation
├── Models/
│   ├── Intervention.swift
│   ├── SwipeDecision.swift
│   ├── ChatMessage.swift
│   └── InterventionCategory.swift
├── Data/
│   ├── InterventionsData.swift      # Seed data (30+ interventions)
│   └── ModelContainer+Extensions.swift
├── Views/
│   ├── Swipe/
│   │   ├── CardStackView.swift
│   │   ├── InterventionCardView.swift
│   │   └── SwipeGestureModifier.swift
│   ├── Profile/
│   │   ├── ProfileDetailView.swift
│   │   ├── ImageCarouselView.swift
│   │   └── StatsGridView.swift
│   ├── Chat/
│   │   ├── ChatView.swift
│   │   ├── MessageBubbleView.swift
│   │   └── ChatInputView.swift
│   └── Matches/
│       ├── MatchesView.swift
│       └── MatchCardView.swift
├── ViewModels/
│   ├── SwipeViewModel.swift
│   └── ChatViewModel.swift
├── Services/
│   ├── LLMService.swift
│   ├── ConfigService.swift          # Load .env
│   └── HapticService.swift
├── Utilities/
│   ├── Extensions/
│   │   ├── Color+Gradients.swift
│   │   └── View+Extensions.swift
│   └── Constants.swift
├── Assets.xcassets/
│   ├── Colors/
│   ├── Images/                      # Climate photos
│   └── AppIcon.appiconset/
├── Resources/
│   └── InterventionImages/          # Additional image assets
└── Preview Content/
    └── PreviewData.swift            # Mock data for SwiftUI previews
```

## Conclusion

This architecture provides a solid foundation for a maintainable, testable iOS app. The clear separation of concerns (MVVM), modern SwiftUI patterns, and local-first data approach ensure good performance and user privacy while keeping the codebase clean and extensible.
