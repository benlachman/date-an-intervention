# Date An Intervention 🌍💚

A playful Tinder-style iOS app that helps you explore and learn about climate interventions through an engaging dating app interface. Swipe through various climate solutions—from stratospheric aerosol injection to coral nano-bubbles—and "match" with the interventions you'd be comfortable supporting.

## Concept

Climate interventions can be complex and intimidating. This app makes them approachable by presenting each intervention as a "date" with a personality, interests, and quirks. Swipe right on solutions you like, swipe left on those you don't, and chat with your matches to learn more about their impacts, risks, and implementation challenges—all through dating app style conversations.

## Features

### 🎴 Swipe Interface
- Smooth card-based swiping with spring animations
- Drag gestures with rotation and haptic feedback
- Visual indicators for like (right) and dislike (left)
- Stack of 30+ intervention "profiles"

### 👤 Intervention Profiles
- Dating app style profiles with "bio" and personality traits
- Pros presented as "Interests" and cons as "Dealbreakers"
- Stats showing research level, tech readiness, and support
- Multiple images (climate photos + SF Symbols with gradients)
- Categories: SRM, Ocean-based, Ice Preservation, Localized, Open Systems

### 💬 Chat with Interventions
- AI-powered conversations (OpenAI/Anthropic)
- Each intervention has a unique personality and conversation style
- Dating app aesthetic with climate-focused double entendres
- Learn about impacts, risks, current research, and implementation
- Conversations persist during your session

### 📊 Matches Screen
- View all interventions you've liked
- Stats on your swiping patterns
- Resume profiles and chats with your matches

### 💾 Data Persistence
- SwiftData integration saves all your swipes
- Review your choices across sessions
- Chat history stored locally

## Tech Stack

- **iOS 18+** with SwiftUI
- **SwiftData** for local persistence
- **Swift Package Manager** for dependencies
- **LLM Integration** (OpenAI or Anthropic API)
- **SF Symbols** + custom gradients for visuals
- **Combine** for reactive patterns

## Interventions Catalog

The app includes 30+ climate interventions across categories:

- **Stratospheric/SRM**: SO₂ aerosol injection, marine cloud brightening, cirrus cloud thinning
- **Ice Stabilization**: Ice sheet anchoring, Arctic ice restoration, glacier protection
- **Ocean-Based**: Iron fertilization, ocean alkalinity enhancement, coral nano-bubbles
- **Land-Based**: Enhanced weathering, afforestation, biochar
- **Localized**: Urban cooling, wetland restoration, mangrove planting

See [INTERVENTIONS.md](INTERVENTIONS.md) for the complete list with personality profiles.

## Getting Started

### Prerequisites
- macOS with Xcode 15+
- iOS 18+ device or simulator
- API key from OpenAI or Anthropic (for chat feature)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/date-an-intervention.git
   cd date-an-intervention
   ```

2. **Generate Xcode project** (requires [XcodeGen](https://github.com/yonaskolb/XcodeGen))
   ```bash
   brew install xcodegen  # If not already installed
   xcodegen generate
   ```

   See [README.xcodegen.md](README.xcodegen.md) for detailed instructions.

3. **Configure API keys**
   ```bash
   cp .env.example .env
   # Edit .env and add your API key
   ```

4. **Open in Xcode**
   ```bash
   open DateAnIntervention.xcodeproj
   ```

5. **Build and run**
   - Select your target device/simulator (iOS 18.0+)
   - Press Cmd+R to build and run
   - Intervention data will seed automatically on first launch

### API Configuration

The chat feature requires an LLM API key:

1. Get an API key from [OpenAI](https://platform.openai.com) or [Anthropic](https://console.anthropic.com)
2. Add it to your `.env` file (never commit this file!)
3. The app will use it to power intervention conversations

See [docs/API_INTEGRATION.md](docs/API_INTEGRATION.md) for detailed setup.

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

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed system design.

## Development

### Task Breakdown
See [TASKS.md](TASKS.md) for a complete list of implementation tasks organized by phase.

### AI-Assisted Development
This project includes `.claude/` instructions for AI coding assistants. Use:
- `/review-task` - Get the next task to work on
- `/continue` - Resume previous work

### Style Guide
Follow the dating app aesthetic guidelines in [docs/DATING_APP_STYLE_GUIDE.md](docs/DATING_APP_STYLE_GUIDE.md).

## Documentation

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System design and technical decisions
- **[TASKS.md](TASKS.md)** - Detailed implementation task list
- **[INTERVENTIONS.md](INTERVENTIONS.md)** - Complete intervention profiles
- **[docs/](docs/)** - Detailed specifications for components

## Contributing

This is an educational/experimental project exploring playful approaches to climate communication. Contributions welcome!

1. Check [TASKS.md](TASKS.md) for open work
2. Create a feature branch
3. Submit a PR with clear description

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

- Climate intervention data based on various research sources
- Inspired by the need to make complex climate topics more accessible
- Built with SwiftUI and modern iOS development practices

---

**Note**: This app is for educational purposes. Climate interventions are complex topics with real-world implications. The "dating" framing is meant to make learning engaging, not to trivialize the science or policy considerations.
