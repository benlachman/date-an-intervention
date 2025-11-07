# Date An Intervention 🌍💚

> **A Tinder-style iOS app for learning about climate interventions through swiping and AI-powered conversations**

<div align="center">

**Status**: 🚧 Active Development

**Phase**: 5 of 10 Complete | **Next**: Enhanced Matches

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-18.0+-blue.svg)](https://www.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![SwiftData](https://img.shields.io/badge/SwiftData-✓-green.svg)](https://developer.apple.com/xcode/swiftdata/)

</div>

---

## 📱 What is this?

**Date An Intervention** gamifies climate science education by presenting **32 climate interventions** as dating profiles. Swipe through solutions (from solar geoengineering to coral restoration), "match" with interesting ones, and have AI-powered conversations to learn about their environmental implications, trade-offs, and feasibility.

**Think Tinder meets climate science!**

---

## ✨ Features

### ✅ **Currently Implemented**

#### 🎴 Swipe Interface (Phase 3 - COMPLETE!)
- Beautiful Tinder-style card stack with **3D depth effect**
- Smooth **drag gestures** with natural rotation
- **Visual feedback**: "LIKE" (green) / "NOPE" (red) indicators
- **Haptic feedback** for engaging tactile response
- **Spring animations** for smooth card movements
- **Empty state** with deck reset functionality

#### 🗂️ 50 Climate Interventions (Phase 2 - COMPLETE!)
**Categories:**
- **Stratospheric/SRM** (13): SAI, Marine Cloud Brightening, Cirrus Thinning, Ocean Surface Albedo, Ice Crystal Seeding, Crop Albedo, Desert Reflectivity, Non-Sulfate Particles, Tethered Balloons, Cloud Management, and more
- **Ice Preservation** (5): Ice Sheet Stabilization, Arctic Restoration, Glacier Protection, Permafrost Protection, Ice-Albedo Enhancement
- **Ocean-Based** (11): Iron Fertilization, Alkalinity Enhancement, Coral Nano-Bubbles, Artificial Upwelling, Kelp Farming, Hydrogen from Algae, Coastal Upwelling, Basalt Beaches, Biomass Sinking, Electrochemical Removal, Regenerative Farming
- **Land-Based** (6): Enhanced Weathering, Biochar, Afforestation, Soil Carbon, Peatland Restoration, Engineered Crops
- **Localized** (7): Urban Albedo, Mangroves, Wetlands, Green Roofs, Urban Forestry, Cloud Seeding, Desert Greening, Fog Harvesting
- **Advanced/Emerging** (8): Direct Air Capture, BECCS, Mineralization, Space Reflectors, Lunar Dust, Methane Removal, Artificial Photosynthesis, Microbial Mineralization

**Each intervention includes:**
- Unique personality and bio
- Pros/cons list
- SF Symbol icon with gradient background
- Stats (research level, tech readiness, public support)
- Chat personality and system prompt
- Opening line for matches

#### 👤 Profile Details (Phase 4 - COMPLETE!)
- Full-screen intervention profiles with scrolling content
- Beautiful image carousel with SF Symbol icons
- Stats grid visualization (research, tech, support scores)
- Expandable pros/cons lists
- Gradient message button with glass-like background
- Smooth navigation and transitions

#### 💬 AI Chat (Phase 5 - COMPLETE!)
- Real-time conversations with matched interventions
- **Multi-provider support**: OpenAI (ChatGPT-4o) or Anthropic (Claude)
- Secure API key management (never committed to git)
- Each intervention uses unique personality prompts
- Chat history persistence with SwiftData
- Message bubbles with intervention-themed gradients
- Haptic feedback for messages
- Error handling with user-friendly messages

#### 💾 Data & Architecture (Phase 1-2 - COMPLETE!)
- **SwiftData** integration for persistence
- **JSON-based** intervention data (easy maintenance)
- First-launch auto-seeding
- Filters already-swiped cards
- MVVM architecture with @Observable ViewModels
- XcodeGen for project generation

---

### 🚧 **Coming Next**

#### 📊 Enhanced Matches (Phase 6)
- Stats on your swiping patterns
- Category preferences analysis
- Compare interventions
- Intervention "chemistry" scores

---

## 🏗️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Platform** | iOS 18.0+ |
| **Language** | Swift 5.9 |
| **UI** | SwiftUI |
| **Data** | SwiftData |
| **Project Gen** | XcodeGen |
| **AI** | OpenAI GPT-4o / Anthropic Claude 3.5 |
| **Architecture** | MVVM with @Observable |

---

## 🚀 Getting Started

### Prerequisites
- **macOS** with Xcode 15+
- **iOS 18+** device or simulator
- **XcodeGen** ([install via Homebrew](https://github.com/yonaskolb/XcodeGen))
- **API key** from OpenAI or Anthropic (required for chat feature)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/date-an-intervention.git
   cd date-an-intervention
   ```

2. **Install XcodeGen** (if not already installed)
   ```bash
   brew install xcodegen
   ```

3. **Generate Xcode project**
   ```bash
   xcodegen generate
   ```

   See [README.xcodegen.md](README.xcodegen.md) for detailed instructions.

4. **Configure API keys** (required for chat feature)
   ```bash
   cp Config.plist.example DateAnIntervention/Config.plist
   # Edit Config.plist with your OpenAI or Anthropic API key
   ```

   See **[API_SETUP.md](API_SETUP.md)** for detailed setup instructions.

5. **Open in Xcode**
   ```bash
   open DateAnIntervention.xcodeproj
   ```

6. **Build and run**
   - Select your target device/simulator (iOS 18.0+)
   - Press `Cmd+R` to build and run
   - **50 interventions seed automatically** on first launch!

---

## 📁 Project Structure

```
DateAnIntervention/
├── App/                          # App entry point
│   ├── DateAnInterventionApp.swift
│   └── ContentView.swift
├── Models/                       # SwiftData models
│   ├── Intervention.swift
│   ├── InterventionCategory.swift
│   ├── SwipeDecision.swift
│   └── ChatMessage.swift
├── Data/                         # Data loading
│   ├── InterventionsData.swift   # JSON loader
│   └── SeedDataService.swift     # First-launch seeding
├── Resources/                    # Data files
│   └── interventions.json        # 50 interventions data
├── Views/
│   ├── Swipe/                    # Swipe interface
│   │   ├── SwipeView.swift
│   │   ├── CardStackView.swift
│   │   └── InterventionCardView.swift
│   ├── Profile/                  # Profile details
│   │   ├── ProfileDetailView.swift
│   │   ├── ImageCarouselView.swift
│   │   └── StatsGridView.swift
│   ├── Chat/                     # Chat interface
│   │   └── ChatView.swift
│   ├── Matches/                  # Matches screen
│   │   └── MatchesView.swift
│   └── Components/               # Shared UI
│       ├── MessageBubbleView.swift
│       └── SettingsView.swift
├── ViewModels/                   # Business logic
│   ├── SwipeViewModel.swift
│   └── ChatViewModel.swift
├── Services/                     # Utilities
│   ├── Config.swift              # API key configuration
│   ├── LLMService.swift          # Multi-provider AI integration
│   └── HapticService.swift
├── Utilities/                    # Extensions
│   └── ColorExtensions.swift
└── Assets.xcassets/              # Images & colors
```

---

## 📚 Documentation

- **[API_SETUP.md](API_SETUP.md)** - **Required**: API key configuration for chat feature
- **[TASKS.md](TASKS.md)** - Complete implementation roadmap with progress tracking
- **[INTERVENTIONS.md](INTERVENTIONS.md)** - Full catalog of 50 climate interventions with personalities
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System design and technical architecture
- **[STYLE_GUIDES.md](STYLE_GUIDES.md)** - UI/UX design principles and dating app aesthetic
- **[README.xcodegen.md](README.xcodegen.md)** - XcodeGen setup and usage
- **[DEVELOPMENT_TEAM.md](DEVELOPMENT_TEAM.md)** - Setting up development team ID

---

## 🎯 Project Phases

| Phase | Status | Description |
|-------|--------|-------------|
| **Phase 1** | ✅ Complete | Project Setup & Foundation |
| **Phase 2** | ✅ Complete | Data Models & SwiftData |
| **Phase 3** | ✅ Complete | Swipe Interface |
| **Phase 4** | ✅ Complete | Profile Details |
| **Phase 5** | ✅ Complete | Chat Interface (OpenAI & Claude) |
| **Phase 6** | ⏸️ Planned | Matches Screen Enhancement |
| **Phase 7** | ⏸️ Planned | Settings & Preferences |
| **Phase 8** | ⏸️ Planned | Polish & Animations |
| **Phase 9** | ⏸️ Planned | Testing & Bug Fixes |
| **Phase 10** | ⏸️ Planned | Deployment & Distribution |

**Progress**: 5/10 phases complete (50%)

See [TASKS.md](TASKS.md) for detailed task breakdown and progress.

---

## 🤝 Contributing

This is currently a solo educational project, but feedback and suggestions are welcome! Please open an issue if you find bugs or have ideas for improvements.

---

## 📖 Learning Resources

Want to learn more about climate interventions?

- [IPCC Reports](https://www.ipcc.ch/) - Authoritative climate science
- [Carbon Brief](https://www.carbonbrief.org/) - Climate science explainers
- [Climate Intervention Research](https://www.climateinterventionresearch.org/) - Academic research hub

---

## 📝 License

[Add your license here]

---

## 🙏 Acknowledgments

- Climate intervention data synthesized from academic research and IPCC reports
- Inspired by dating apps' engagement patterns applied to education
- Built with SwiftUI and SwiftData on iOS 18

---

<div align="center">

**Made with 💚 for climate education**

*Swipe right on solutions. Learn. Take action.*

</div>
