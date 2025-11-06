# Project Structure

This document outlines the complete file structure for Date An Intervention. This structure will be created during Phase 1 implementation.

## Current Structure (Documentation Phase)

```
date-an-intervention/
├── .git/                           # Git repository
├── .gitignore                      # Git ignore rules
├── .env.example                    # API key template
│
├── .claude/                        # AI assistant configuration
│   ├── instructions.md             # Project context for AI
│   └── commands/                   # Custom slash commands
│       ├── review-task.md
│       └── continue.md
│
├── docs/                           # Detailed specifications
│   ├── UI_SPECS.md                 # UI component specifications
│   ├── DATA_MODELS.md              # Data model definitions
│   ├── API_INTEGRATION.md          # LLM API integration guide
│   └── DATING_APP_STYLE_GUIDE.md   # Writing and design guidelines
│
├── README.md                       # Project overview
├── ARCHITECTURE.md                 # System architecture
├── TASKS.md                        # Implementation task list
├── INTERVENTIONS.md                # Complete intervention catalog
├── STRUCTURE.md                    # This file
└── LICENSE                         # MIT License
```

## Target Structure (After Implementation)

```
date-an-intervention/
│
├── .git/
├── .gitignore
├── .env.example
├── .env                            # Local config (gitignored)
│
├── .claude/
│   ├── instructions.md
│   └── commands/
│       ├── review-task.md
│       └── continue.md
│
├── docs/
│   ├── UI_SPECS.md
│   ├── DATA_MODELS.md
│   ├── API_INTEGRATION.md
│   └── DATING_APP_STYLE_GUIDE.md
│
├── README.md
├── ARCHITECTURE.md
├── TASKS.md
├── INTERVENTIONS.md
├── STRUCTURE.md
├── LICENSE
│
├── DateAnIntervention.xcodeproj/  # Xcode project
│   ├── project.pbxproj
│   └── xcshareddata/
│
├── DateAnIntervention/             # Main app target
│   │
│   ├── DateAnInterventionApp.swift # App entry point
│   │   └── Contains: @main, ModelContainer setup, scene definition
│   │
│   ├── App/
│   │   └── ContentView.swift       # Root view with navigation
│   │
│   ├── Models/                     # SwiftData models
│   │   ├── Intervention.swift
│   │   ├── SwipeDecision.swift
│   │   ├── ChatMessage.swift
│   │   ├── InterventionCategory.swift
│   │   ├── ImpactScale.swift
│   │   ├── ResearchLevel.swift
│   │   ├── TechReadiness.swift
│   │   ├── SupportLevel.swift
│   │   └── MessageStatus.swift
│   │
│   ├── Data/
│   │   ├── InterventionsData.swift # Seed data (from INTERVENTIONS.md)
│   │   └── ModelContainer+Extensions.swift
│   │
│   ├── Views/
│   │   ├── Swipe/
│   │   │   ├── CardStackView.swift
│   │   │   ├── InterventionCardView.swift
│   │   │   └── SwipeOverlayView.swift
│   │   │
│   │   ├── Profile/
│   │   │   ├── ProfileDetailView.swift
│   │   │   ├── ImageCarouselView.swift
│   │   │   ├── StatsGridView.swift
│   │   │   └── InterestsListView.swift
│   │   │
│   │   ├── Chat/
│   │   │   ├── ChatView.swift
│   │   │   ├── MessageBubbleView.swift
│   │   │   ├── ChatInputView.swift
│   │   │   └── TypingIndicatorView.swift
│   │   │
│   │   ├── Matches/
│   │   │   ├── MatchesView.swift
│   │   │   ├── MatchCardView.swift
│   │   │   └── MatchesStatsView.swift
│   │   │
│   │   └── Shared/
│   │       ├── LoadingView.swift
│   │       ├── ErrorView.swift
│   │       └── EmptyStateView.swift
│   │
│   ├── ViewModels/
│   │   ├── SwipeViewModel.swift
│   │   └── ChatViewModel.swift
│   │
│   ├── Services/
│   │   ├── LLMService.swift        # LLM API integration
│   │   ├── ConfigService.swift     # Configuration management
│   │   └── HapticService.swift     # Haptic feedback
│   │
│   ├── Utilities/
│   │   ├── Extensions/
│   │   │   ├── Color+Extensions.swift
│   │   │   ├── View+Extensions.swift
│   │   │   └── String+Extensions.swift
│   │   │
│   │   ├── Constants.swift
│   │   └── Errors.swift
│   │
│   ├── Resources/
│   │   ├── Info.plist
│   │   └── Config.xcconfig
│   │
│   └── Assets.xcassets/
│       ├── AppIcon.appiconset/
│       ├── AccentColor.colorset/
│       ├── Colors/
│       │   ├── AccentPink.colorset/
│       │   ├── AccentOrange.colorset/
│       │   ├── AccentPurple.colorset/
│       │   ├── AccentTeal.colorset/
│       │   ├── LikeGreen.colorset/
│       │   └── NopeRed.colorset/
│       │
│       └── Images/                  # Optional climate photos
│           └── .gitkeep
│
├── DateAnInterventionTests/        # Unit tests
│   ├── ModelTests/
│   │   ├── InterventionTests.swift
│   │   └── SwipeDecisionTests.swift
│   │
│   ├── ViewModelTests/
│   │   ├── SwipeViewModelTests.swift
│   │   └── ChatViewModelTests.swift
│   │
│   └── ServiceTests/
│       └── LLMServiceTests.swift
│
├── DateAnInterventionUITests/      # UI tests
│   ├── SwipeFlowTests.swift
│   ├── ProfileViewTests.swift
│   └── ChatFlowTests.swift
│
└── Preview Content/
    └── PreviewData.swift            # Mock data for SwiftUI previews
```

## Key Directories

### Documentation (Current)

**Purpose**: Complete project documentation and planning

**Contents**:
- Architecture and design docs
- Task breakdown
- Intervention data
- Style guides
- API integration guides

### Source Code (Future)

**DateAnIntervention/**:
- Main app source code
- Organized by feature and layer (MVVM)
- SwiftUI views, ViewModels, Models, Services

**Models/**:
- SwiftData models
- Enums for categorization
- All data structures

**Views/**:
- SwiftUI view components
- Organized by feature area
- Reusable components in Shared/

**ViewModels/**:
- Business logic
- State management
- Data fetching and mutations

**Services/**:
- External integrations (LLM API)
- Configuration
- Platform services (Haptics)

### Tests

**DateAnInterventionTests/**:
- Unit tests for models, viewmodels, services
- Mock services for testing

**DateAnInterventionUITests/**:
- End-to-end UI tests
- User flow testing

## File Naming Conventions

### Swift Files

- **Views**: `[Feature][Component]View.swift`
  - Example: `CardStackView.swift`, `ProfileDetailView.swift`

- **ViewModels**: `[Feature]ViewModel.swift`
  - Example: `SwipeViewModel.swift`, `ChatViewModel.swift`

- **Models**: `[ModelName].swift`
  - Example: `Intervention.swift`, `SwipeDecision.swift`

- **Services**: `[ServiceName]Service.swift`
  - Example: `LLMService.swift`, `ConfigService.swift`

- **Extensions**: `[Type]+[Purpose].swift`
  - Example: `Color+Extensions.swift`, `View+Extensions.swift`

### Asset Files

- **Color Sets**: `[Name].colorset/`
  - Example: `AccentPink.colorset/`

- **Images**: Descriptive names, lowercase with hyphens
  - Example: `glacier-sunset.jpg`, `ocean-waves.jpg`

## Git Ignore Rules

Current `.gitignore` includes:

```gitignore
# Environment configuration
.env

# Xcode
*.xcodeproj/*
!*.xcodeproj/project.pbxproj
!*.xcodeproj/xcshareddata/
*.xcworkspace/*
!*.xcworkspace/contents.xcworkspacedata
DerivedData/
*.hmap
*.ipa
*.dSYM.zip
*.dSYM

# Swift Package Manager
.build/
Packages/
*.swiftpm

# CocoaPods (if used)
Pods/
*.podspec

# Fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots
fastlane/test_output

# OS files
.DS_Store
```

## Adding Files Checklist

When adding new files:

1. ✅ Place in correct directory by layer/feature
2. ✅ Follow naming conventions
3. ✅ Add header comments with purpose
4. ✅ Import only necessary modules
5. ✅ Add to appropriate git tracking
6. ✅ Update this STRUCTURE.md if adding new directories

## Migration from Current to Target

The transition from documentation to implementation will happen in Phase 1:

1. Create Xcode project
2. Set up directory structure
3. Create placeholder files with comments
4. Configure build settings
5. Set up SwiftData container
6. Create initial models

This structure is designed to scale from current documentation-only state to a full iOS application while maintaining clarity and organization.
