# Generating the Xcode Project

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate the Xcode project file from `project.yml`.

## Prerequisites

Install XcodeGen on your Mac:

```bash
brew install xcodegen
```

Or download from [releases](https://github.com/yonaskolb/XcodeGen/releases).

## Generate the Project

From the repository root, run:

```bash
xcodegen generate
```

This will create `DateAnIntervention.xcodeproj` based on the `project.yml` specification.

## Open in Xcode

After generation:

```bash
open DateAnIntervention.xcodeproj
```

Or double-click the `.xcodeproj` file in Finder.

## Project Structure

```
DateAnIntervention/
├── App/                    # App entry point and main views
│   ├── DateAnInterventionApp.swift
│   └── ContentView.swift
├── Models/                 # SwiftData models
│   ├── Intervention.swift
│   ├── InterventionCategory.swift
│   ├── SwipeDecision.swift
│   └── ChatMessage.swift
├── Data/                   # Intervention dataset and seed service
│   ├── InterventionsData.swift
│   └── SeedDataService.swift
├── Views/                  # UI components
│   ├── Swipe/
│   ├── Profile/
│   ├── Chat/
│   ├── Matches/
│   └── Components/
├── ViewModels/            # Business logic (to be added)
├── Services/              # API integration (to be added)
├── Utilities/             # Helpers (to be added)
├── Assets.xcassets/       # Images and colors
└── Info.plist            # App configuration
```

## First Build

1. Open the project in Xcode
2. Select a simulator or device target
3. Press Cmd+R to build and run
4. The app will seed intervention data on first launch

## Next Steps

See [TASKS.md](TASKS.md) for the implementation roadmap.

## Troubleshooting

### "Cannot find 'Intervention' in scope"
Run `xcodegen generate` to ensure all files are included in the project.

### Build errors about SwiftData
Ensure you're targeting iOS 18.0+ in both:
- Project settings (Deployment Target)
- Simulator/device selection

### Missing dependencies
The project uses only system frameworks (SwiftUI, SwiftData). No external dependencies needed yet.
