# Data Models

Complete SwiftData model definitions for Date An Intervention.

## Overview

The app uses SwiftData for local persistence with four main models:
1. **Intervention** - Climate intervention data
2. **SwipeDecision** - User's swipe choices
3. **ChatMessage** - Conversation history
4. **InterventionCategory** - Enum for intervention types

All models use the `@Model` macro and are managed by a single ModelContainer.

---

## Models

### 1. Intervention

The core model representing a climate intervention with all its attributes.

```swift
import SwiftData
import Foundation

@Model
final class Intervention {
    // Identification
    @Attribute(.unique) var id: UUID
    var name: String                    // Display name (e.g., "Strat")
    var fullName: String               // Full name (e.g., "Stratospheric Aerosol Injection")

    // Categorization
    var category: InterventionCategory
    var impactScale: ImpactScale       // Local, Regional, Global
    var researchLevel: ResearchLevel   // Early, Active, Established
    var techReadiness: TechReadiness   // Conceptual, Pilot, Deployable
    var supportLevel: SupportLevel     // Controversial, Mixed, Supported

    // Profile Content
    var bio: String                    // Dating-style bio paragraph
    var ageLabel: String              // Age-style label (e.g., "28")
    var distanceLabel: String         // Distance-style label for impact

    // Pros and Cons (as dating attributes)
    var interests: [String]           // Pros presented as interests
    var dealbreakers: [String]        // Cons presented as dealbreakers

    // Personality
    var personalityTraits: [String]   // List of personality descriptors
    var conversationStyle: String     // How this intervention "talks"

    // Visuals
    var symbolName: String            // SF Symbol name
    var gradientColors: [String]      // Array of hex color strings
    var imageName: String?            // Optional actual image filename

    // Chat Context
    var chatContext: String           // Background information for LLM system prompt

    // Metadata
    var createdAt: Date
    var order: Int                    // For custom ordering in deck

    // Computed
    var displayAge: String {
        "\(name), \(ageLabel)"
    }

    var categoryBadge: String {
        category.rawValue
    }

    // Initializer
    init(
        id: UUID = UUID(),
        name: String,
        fullName: String,
        category: InterventionCategory,
        impactScale: ImpactScale,
        researchLevel: ResearchLevel,
        techReadiness: TechReadiness,
        supportLevel: SupportLevel,
        bio: String,
        ageLabel: String,
        distanceLabel: String,
        interests: [String],
        dealbreakers: [String],
        personalityTraits: [String],
        conversationStyle: String,
        symbolName: String,
        gradientColors: [String],
        imageName: String? = nil,
        chatContext: String,
        order: Int = 0
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.category = category
        self.impactScale = impactScale
        self.researchLevel = researchLevel
        self.techReadiness = techReadiness
        self.supportLevel = supportLevel
        self.bio = bio
        self.ageLabel = ageLabel
        self.distanceLabel = distanceLabel
        self.interests = interests
        self.dealbreakers = dealbreakers
        self.personalityTraits = personalityTraits
        self.conversationStyle = conversationStyle
        self.symbolName = symbolName
        self.gradientColors = gradientColors
        self.imageName = imageName
        self.chatContext = chatContext
        self.createdAt = Date()
        self.order = order
    }
}
```

**Relationships**: None direct (SwipeDecision and ChatMessage reference by ID)

**Indexes**: Consider indexing `category` and `order` for query performance

---

### 2. SwipeDecision

Records user's swipe choices (like or pass).

```swift
import SwiftData
import Foundation

@Model
final class SwipeDecision {
    @Attribute(.unique) var id: UUID
    var interventionId: UUID          // Reference to Intervention
    var interventionName: String      // Denormalized for quick access
    var liked: Bool                   // true = right swipe, false = left swipe
    var timestamp: Date

    // Computed
    var isMatch: Bool {
        liked
    }

    // Initializer
    init(
        id: UUID = UUID(),
        interventionId: UUID,
        interventionName: String,
        liked: Bool,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.interventionId = interventionId
        self.interventionName = interventionName
        self.liked = liked
        self.timestamp = timestamp
    }
}
```

**Usage**:
- Created whenever user swipes a card
- Query liked decisions to show matches
- Can track swipe history and patterns

**Queries**:
```swift
// Get all matches
@Query(filter: #Predicate<SwipeDecision> { $0.liked == true })
var matches: [SwipeDecision]

// Get recent swipes
@Query(sort: \SwipeDecision.timestamp, order: .reverse)
var recentSwipes: [SwipeDecision]
```

---

### 3. ChatMessage

Stores conversation history with each intervention.

```swift
import SwiftData
import Foundation

@Model
final class ChatMessage {
    @Attribute(.unique) var id: UUID
    var interventionId: UUID          // Which intervention this chat is with
    var content: String               // Message text
    var isFromUser: Bool             // true = user, false = AI
    var timestamp: Date

    // Optional: Message status
    var status: MessageStatus        // sending, sent, failed

    // Initializer
    init(
        id: UUID = UUID(),
        interventionId: UUID,
        content: String,
        isFromUser: Bool,
        timestamp: Date = Date(),
        status: MessageStatus = .sent
    ) {
        self.id = id
        self.interventionId = interventionId
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = timestamp
        self.status = status
    }
}
```

**Usage**:
- Save all messages for persistence
- Load chat history when opening conversation
- Provide context to LLM API

**Queries**:
```swift
// Get messages for specific intervention
@Query(filter: #Predicate<ChatMessage> { message in
    message.interventionId == selectedInterventionId
}, sort: \ChatMessage.timestamp)
var messages: [ChatMessage]
```

---

## Enums

### InterventionCategory

```swift
enum InterventionCategory: String, Codable, CaseIterable {
    case srm = "Stratospheric/SRM"
    case ocean = "Ocean-Based"
    case ice = "Ice Preservation"
    case land = "Land-Based"
    case localized = "Localized"
    case advanced = "Advanced"

    var emoji: String {
        switch self {
        case .srm: return "☁️"
        case .ocean: return "🌊"
        case .ice: return "🧊"
        case .land: return "🌱"
        case .localized: return "🏙️"
        case .advanced: return "🔬"
        }
    }

    var color: String {
        switch self {
        case .srm: return "#C77DFF"
        case .ocean: return "#00B4D8"
        case .ice: return "#90E0EF"
        case .land: return "#06D6A0"
        case .localized: return "#FFA07A"
        case .advanced: return "#FF6B9D"
        }
    }
}
```

### ImpactScale

```swift
enum ImpactScale: String, Codable {
    case localized = "Localized"
    case regional = "Regional"
    case global = "Global"

    var emoji: String {
        switch self {
        case .localized: return "📍"
        case .regional: return "🗺️"
        case .global: return "🌍"
        }
    }
}
```

### ResearchLevel

```swift
enum ResearchLevel: String, Codable {
    case early = "Early"
    case active = "Active"
    case established = "Established"

    var description: String {
        switch self {
        case .early: return "Early research stage"
        case .active: return "Active research ongoing"
        case .established: return "Well-established research"
        }
    }

    var emoji: String {
        switch self {
        case .early: return "🔬"
        case .active: return "📊"
        case .established: return "📚"
        }
    }
}
```

### TechReadiness

```swift
enum TechReadiness: String, Codable {
    case conceptual = "Conceptual"
    case pilot = "Pilot-phase"
    case deployable = "Deployable"

    var description: String {
        switch self {
        case .conceptual: return "Theoretical concept"
        case .pilot: return "Pilot testing underway"
        case .deployable: return "Ready to deploy"
        }
    }

    var emoji: String {
        switch self {
        case .conceptual: return "💡"
        case .pilot: return "🧪"
        case .deployable: return "🚀"
        }
    }
}
```

### SupportLevel

```swift
enum SupportLevel: String, Codable {
    case controversial = "Controversial"
    case mixed = "Mixed"
    case supported = "Supported"
    case stronglySupported = "Strongly Supported"

    var description: String {
        switch self {
        case .controversial: return "Highly debated"
        case .mixed: return "Mixed opinions"
        case .supported: return "Generally supported"
        case .stronglySupported: return "Widely supported"
        }
    }

    var emoji: String {
        switch self {
        case .controversial: return "⚠️"
        case .mixed: return "🤔"
        case .supported: return "👍"
        case .stronglySupported: return "💚"
        }
    }
}
```

### MessageStatus

```swift
enum MessageStatus: String, Codable {
    case sending = "sending"
    case sent = "sent"
    case failed = "failed"
}
```

---

## ModelContainer Configuration

### Setup

```swift
import SwiftData

// In App entry point
@main
struct DateAnInterventionApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(
                for: Intervention.self,
                     SwipeDecision.self,
                     ChatMessage.self
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
```

### Seeding Data

```swift
extension ModelContainer {
    @MainActor
    func seedInterventionsIfNeeded() async throws {
        let context = mainContext
        let descriptor = FetchDescriptor<Intervention>()

        let existingCount = try context.fetchCount(descriptor)

        if existingCount == 0 {
            // Seed interventions from InterventionsData
            let interventions = InterventionsData.all
            for intervention in interventions {
                context.insert(intervention)
            }

            try context.save()
            print("Seeded \(interventions.count) interventions")
        }
    }
}
```

---

## Common Queries

### Fetch Interventions

```swift
// All interventions ordered
@Query(sort: \Intervention.order)
var interventions: [Intervention]

// By category
@Query(filter: #Predicate<Intervention> { intervention in
    intervention.category == .srm
})
var srmInterventions: [Intervention]

// Not yet swiped
func unswipedInterventions(context: ModelContext) throws -> [Intervention] {
    let swipedIds = try context.fetch(
        FetchDescriptor<SwipeDecision>()
    ).map { $0.interventionId }

    let descriptor = FetchDescriptor<Intervention>(
        predicate: #Predicate { intervention in
            !swipedIds.contains(intervention.id)
        },
        sortBy: [SortDescriptor(\Intervention.order)]
    )

    return try context.fetch(descriptor)
}
```

### Fetch Matches

```swift
// All matches
@Query(filter: #Predicate<SwipeDecision> { $0.liked == true })
var matches: [SwipeDecision]

// Match interventions (join query)
func matchedInterventions(context: ModelContext) throws -> [Intervention] {
    let matchedIds = try context.fetch(
        FetchDescriptor<SwipeDecision>(
            predicate: #Predicate { $0.liked == true }
        )
    ).map { $0.interventionId }

    let descriptor = FetchDescriptor<Intervention>(
        predicate: #Predicate { intervention in
            matchedIds.contains(intervention.id)
        }
    )

    return try context.fetch(descriptor)
}
```

### Fetch Chat Messages

```swift
// Messages for specific intervention
func messages(for interventionId: UUID, context: ModelContext) throws -> [ChatMessage] {
    let descriptor = FetchDescriptor<ChatMessage>(
        predicate: #Predicate { message in
            message.interventionId == interventionId
        },
        sortBy: [SortDescriptor(\ChatMessage.timestamp)]
    )

    return try context.fetch(descriptor)
}
```

### Stats Queries

```swift
// Total swipes
func totalSwipes(context: ModelContext) throws -> Int {
    try context.fetchCount(FetchDescriptor<SwipeDecision>())
}

// Like percentage
func likePercentage(context: ModelContext) throws -> Double {
    let total = try totalSwipes(context: context)
    guard total > 0 else { return 0 }

    let likes = try context.fetchCount(
        FetchDescriptor<SwipeDecision>(
            predicate: #Predicate { $0.liked == true }
        )
    )

    return Double(likes) / Double(total) * 100
}

// Favorite category
func favoriteCategory(context: ModelContext) throws -> InterventionCategory? {
    let matches = try context.fetch(FetchDescriptor<SwipeDecision>(
        predicate: #Predicate { $0.liked == true }
    ))

    guard !matches.isEmpty else { return nil }

    // Would need to join with Intervention to get category
    // This is simplified - actual implementation needs intervention lookup
    let allInterventions = try context.fetch(FetchDescriptor<Intervention>())
    let interventionMap = Dictionary(
        uniqueKeysWithValues: allInterventions.map { ($0.id, $0) }
    )

    let categoryCounts = matches
        .compactMap { interventionMap[$0.interventionId]?.category }
        .reduce(into: [:]) { counts, category in
            counts[category, default: 0] += 1
        }

    return categoryCounts.max(by: { $0.value < $1.value })?.key
}
```

---

## Data Migrations

Currently no migrations needed (v1.0). For future schema changes:

```swift
// Example migration for v2
let schema = Schema([
    Intervention.self,
    SwipeDecision.self,
    ChatMessage.self
])

let modelConfiguration = ModelConfiguration(
    schema: schema,
    isStoredInMemoryOnly: false
)

let container = try ModelContainer(
    for: schema,
    migrationPlan: MyMigrationPlan.self,
    configurations: [modelConfiguration]
)
```

---

## Performance Considerations

### Indexing

Consider adding indexes for frequently queried fields:
```swift
@Attribute(.indexed) var category: InterventionCategory
@Attribute(.indexed) var timestamp: Date
```

### Batch Operations

For large data sets, use batch operations:
```swift
// Batch insert
context.insert(contentsOf: interventions)

// Batch delete
let descriptor = FetchDescriptor<ChatMessage>(
    predicate: #Predicate { $0.timestamp < oldDate }
)
try context.delete(model: ChatMessage.self, where: descriptor.predicate)
```

### Memory Management

- Use `@Query` with filters to avoid loading all data
- Limit chat history (e.g., last 100 messages per intervention)
- Consider pruning old swipe decisions if needed

---

## Testing

### Mock Data

```swift
extension Intervention {
    static var preview: Intervention {
        Intervention(
            name: "Strat",
            fullName: "Stratospheric Aerosol Injection",
            category: .srm,
            impactScale: .global,
            researchLevel: .active,
            techReadiness: .pilot,
            supportLevel: .controversial,
            bio: "High-altitude dreamer looking to cool things down.",
            ageLabel: "28",
            distanceLabel: "Global Impact",
            interests: ["Fast acting", "Relatively low cost"],
            dealbreakers: ["Doesn't address ocean acidification"],
            personalityTraits: ["Bold", "Controversial"],
            conversationStyle: "Confident and assertive",
            symbolName: "cloud.sun.fill",
            gradientColors: ["#FFA07A", "#C77DFF"],
            chatContext: "SAI involves injecting sulfate aerosols..."
        )
    }

    static var previews: [Intervention] {
        [preview, /* more previews */]
    }
}
```

### In-Memory Container

```swift
let config = ModelConfiguration(isStoredInMemoryOnly: true)
let container = try ModelContainer(
    for: Intervention.self, SwipeDecision.self, ChatMessage.self,
    configurations: config
)
```

---

This data model design provides a solid foundation for all app functionality while remaining simple and maintainable.
