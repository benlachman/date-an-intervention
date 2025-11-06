# Claude Code Instructions for Date An Intervention

This file provides context and instructions for AI coding assistants working on this project.

## Project Overview

**Date An Intervention** is a playful iOS app that presents climate interventions as "dating profiles" in a Tinder-style swipe interface. Users swipe through 30+ interventions, view detailed profiles, and chat with AI personas representing each intervention to learn about climate solutions in an engaging way.

## Key Project Documents

Always reference these documents when working on the project:

1. **README.md** - Project overview, features, setup instructions
2. **ARCHITECTURE.md** - Technical architecture, system design, data models
3. **TASKS.md** - Detailed task breakdown organized by phase
4. **INTERVENTIONS.md** - Complete catalog of 30+ intervention profiles with personality data
5. **docs/** - Detailed specifications for UI, data models, and APIs

## Technology Stack

- **iOS 18+** with SwiftUI
- **SwiftData** for local persistence
- **Swift Package Manager** for dependencies
- **LLM API Integration** (OpenAI or Anthropic) for chat feature
- **SF Symbols** + gradients for intervention visuals
- **Combine** for reactive patterns

## Project Structure

```
DateAnIntervention/
├── App/                    # App entry point and main views
├── Models/                 # SwiftData models
├── Data/                   # Intervention dataset
├── Views/                  # UI components
│   ├── Swipe/             # Card stack and swiping
│   ├── Profile/           # Detail views
│   ├── Chat/              # Messaging interface
│   └── Matches/           # Results screen
├── ViewModels/            # Business logic
├── Services/              # API integration
└── Assets.xcassets        # Images and colors
```

## Core Features

1. **Swipe Interface** - Card-based swipe gesture with animations
2. **Intervention Profiles** - Dating-style profiles with pros/cons
3. **AI Chat** - Conversation with intervention personas using LLM
4. **Matches Screen** - View all liked interventions
5. **Data Persistence** - SwiftData saves all swipes and chats

## Development Guidelines

### Code Style

- Use SwiftUI for all UI components
- Follow MVVM architecture pattern
- Use `@Observable` for ViewModels (iOS 17+)
- Use SwiftData `@Model` for data models
- Keep views focused and composable
- Extract reusable components

### Naming Conventions

- **Views**: End with `View` (e.g., `CardStackView`)
- **ViewModels**: End with `ViewModel` (e.g., `SwipeViewModel`)
- **Models**: Descriptive nouns (e.g., `Intervention`, `SwipeDecision`)
- **Services**: End with `Service` (e.g., `LLMService`)

### SwiftData Models

All models use the `@Model` macro and follow these patterns:

```swift
@Model
class Intervention {
    @Attribute(.unique) var id: UUID
    var name: String
    // ... other properties
}
```

Relationships use standard Swift references. See ARCHITECTURE.md for complete model definitions.

### Dating App Aesthetic

- **Colors**: Warm gradients (pink, orange, purple, teal)
- **Typography**: San Francisco system font, playful weights
- **Animations**: Spring-based, bouncy feel
- **Tone**: Playful but informative, dating app style
- **Imagery**: Climate photos + SF Symbols with gradients

### Chat Implementation

When implementing chat features:

1. System prompt should be generated from intervention data (see INTERVENTIONS.md)
2. Include personality traits, conversation style, and background context
3. Maintain conversation history for context
4. Handle API errors gracefully with user-friendly messages
5. Save all messages to SwiftData for persistence

Example system prompt structure:
```
You are {intervention.name}, a climate intervention on a dating app.

Background: {intervention.chatContext}
Personality: {intervention.personalityTraits}
Conversation style: {intervention.conversationStyle}

Your interests (strengths): {intervention.interests}
Your dealbreakers (limitations): {intervention.dealbreakers}

Respond as if chatting on a dating app - playful, engaging, informative.
```

## Working with Tasks

### Task Workflow

1. Check **TASKS.md** for the next pending task
2. Read the task description and acceptance criteria
3. Implement the feature following architecture guidelines
4. Test thoroughly (manual testing, unit tests where applicable)
5. Mark task as complete in TASKS.md
6. Commit changes with clear message

### Task Dependencies

- Phases 1-2 (Project Setup & Data Models) must be completed first
- Core features (Phases 3-6) can be tackled after foundation
- Polish (Phase 8) should come after core features work
- Testing (Phase 9) should be ongoing

### Prioritization

Focus on completing entire features rather than partial implementations across multiple areas. For example:
- Complete swipe interface fully before starting chat
- Finish one view completely before starting another

## Common Patterns

### View Structure

```swift
struct ExampleView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ExampleViewModel

    var body: some View {
        // View content
    }
}
```

### ViewModel Structure

```swift
@Observable
class ExampleViewModel {
    private let modelContext: ModelContext

    // Observable properties
    var items: [Item] = []
    var isLoading: Bool = false

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func performAction() {
        // Business logic
    }
}
```

### Service Structure

```swift
class ExampleService {
    func performOperation() async throws -> Result {
        // Service logic
    }
}
```

## Data Seeding

The app should seed the intervention data on first launch:

1. Check if database is empty
2. If empty, parse INTERVENTIONS.md data into Intervention models
3. Insert all 30+ interventions into SwiftData
4. Ensure this only happens once

## API Configuration

- API keys should NEVER be committed to the repository
- Use `.env` file for local development (gitignored)
- Load configuration through `ConfigService`
- Provide clear error messages if API key is missing
- Support both OpenAI and Anthropic APIs

## Testing Considerations

- **Unit Tests**: ViewModels, services, data models
- **UI Tests**: Core flows (swipe, profile, chat, matches)
- **Manual Testing**: Different device sizes, error cases, edge cases

## Git Workflow

- Commit frequently with clear, descriptive messages
- Follow conventional commit format when possible:
  - `feat: Add swipe gesture to card view`
  - `fix: Correct chat message ordering`
  - `docs: Update README with setup instructions`
  - `refactor: Extract message bubble into component`

## Resources

- **SwiftUI Documentation**: https://developer.apple.com/documentation/swiftui
- **SwiftData Guide**: https://developer.apple.com/documentation/swiftdata
- **SF Symbols**: https://developer.apple.com/sf-symbols/
- **OpenAI API**: https://platform.openai.com/docs
- **Anthropic API**: https://docs.anthropic.com

## Questions & Clarifications

When encountering ambiguity:

1. Check ARCHITECTURE.md for technical decisions
2. Review TASKS.md for acceptance criteria
3. Look at INTERVENTIONS.md for content guidance
4. Consult docs/ folder for detailed specs
5. Ask for clarification if still unclear

## Special Considerations

### Performance

- Keep card stack limited to 3-5 visible cards
- Use lazy loading for large lists
- Cache images appropriately
- Monitor memory usage with instruments

### Accessibility

- Add accessibility labels to all controls
- Support Dynamic Type
- Ensure VoiceOver compatibility
- Maintain sufficient color contrast

### Error Handling

- Provide user-friendly error messages
- Handle network failures gracefully
- Allow retry for failed operations
- Never crash on errors

## Project Goals

Remember the core mission: Make climate interventions approachable and engaging through a playful dating app interface. Every feature should serve this goal:

- **Playful**: Use dating app conventions creatively
- **Informative**: Provide real information about interventions
- **Engaging**: Make learning fun and interactive
- **Respectful**: Don't trivialize the serious nature of climate science

## Helpful Commands

Use the slash commands in `.claude/commands/` to streamline workflow:

- `/review-task` - Get next task from TASKS.md
- `/continue` - Resume previous work context

---

**Version**: 1.0
**Last Updated**: 2025-11-06
**Project Phase**: Documentation & Planning
