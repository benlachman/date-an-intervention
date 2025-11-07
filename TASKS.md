# Implementation Tasks

This document breaks down the complete implementation into actionable tasks organized by phase. Each task includes acceptance criteria and complexity estimates.

**Complexity Legend:**
- 🟢 **Easy** (< 1 hour)
- 🟡 **Medium** (1-3 hours)
- 🔴 **Complex** (3+ hours)

**Status Legend:**
- ✅ **Completed**
- 🚧 **In Progress**
- ⏸️ **Not Started**

---

## 🎯 Current Status

**Last Updated:** 2025-11-07 (Phase 4 Complete)

### Completed Phases:
- ✅ **Phase 1:** Project Setup & Foundation (100%)
- ✅ **Phase 2:** Data Models & SwiftData (100%)
- ✅ **Phase 3:** Swipe Interface (100%)
- ✅ **Phase 4:** Profile Details (100%)

### Next Up:
- **Phase 5:** Chat Interface
- **Phase 6:** Matches Screen

### Recent Accomplishments:
- ✅ Created comprehensive profile detail view
- ✅ Built image carousel with SF Symbol gradients
- ✅ Implemented stats grid for intervention metrics
- ✅ Added tap-to-view navigation from swipe cards
- ✅ Added action buttons for like/dislike/info
- ✅ Integrated Message button for future chat feature

---

## Phase 1: Project Setup & Foundation

### 1.1 Create Xcode Project 🟢 ✅
**Description**: Initialize the Xcode project with proper configuration

**Status**: COMPLETED

**What was done**:
- ✅ Created XcodeGen configuration (project.yml)
- ✅ Set bundle identifier to `com.nicemohawk.interventiontinder`
- ✅ Set deployment target to iOS 18.0
- ✅ Configured SwiftUI interface and Swift language
- ✅ Set up SwiftData integration
- ✅ Configured development team (GYV9U8338K)

**Notes**:
- Using XcodeGen for project generation
- Run `xcodegen generate` to create .xcodeproj
- Team ID configured in project.yml to avoid reselection

---

### 1.2 Configure Build Settings 🟢 ✅
**Description**: Set up build configuration and environment

**Status**: COMPLETED

**What was done**:
- ✅ Created `.env.example` template with API key placeholders
- ✅ Updated `.gitignore` to exclude `.env`
- ✅ Configured Info.plist for API access (App Transport Security)
- ✅ Set up proper code signing with automatic style

**Acceptance Criteria**:
- ✅ `.env.example` exists with placeholder values
- ✅ `.env` is gitignored
- ✅ Security settings configured for OpenAI and Anthropic APIs

---

### 1.3 Create Directory Structure 🟢 ✅
**Description**: Set up file organization matching ARCHITECTURE.md

**Status**: COMPLETED

**What was done**:
- ✅ Created folder structure: App, Models, Data, Views, ViewModels, Services, Utilities
- ✅ Created subfolders: Views/Swipe, Views/Profile, Views/Chat, Views/Matches, Views/Components
- ✅ Organized project navigator with proper groups
- ✅ Added Resources folder for JSON data

**Structure**:
```
DateAnIntervention/
├── App/
├── Models/
├── Data/
├── Views/
│   ├── Swipe/
│   ├── Profile/
│   ├── Chat/
│   ├── Matches/
│   └── Components/
├── ViewModels/
├── Services/
├── Utilities/
├── Resources/
└── Assets.xcassets/
```

---

## Phase 2: Data Models & SwiftData

### 2.1 Define Core Models 🟡 ✅
**Description**: Create SwiftData models for all entities

**Status**: COMPLETED

**What was done**:
- ✅ Created `InterventionCategory` enum with 6 categories
- ✅ Created `Intervention` model with all properties
- ✅ Created `SwipeDecision` model for tracking likes/dislikes
- ✅ Created `ChatMessage` model for conversations
- ✅ Added proper relationships and attributes
- ✅ Created `ColorExtensions.swift` for hex color support

**Acceptance Criteria**:
- ✅ All models compile without errors
- ✅ SwiftData attributes properly configured (@Model, @Attribute, etc.)
- ✅ Relationships defined where needed

---

### 2.2 Set Up SwiftData Container 🟡 ✅
**Description**: Configure ModelContainer and context

**Status**: COMPLETED

**What was done**:
- ✅ Created ModelContainer in DateAnInterventionApp.swift
- ✅ Configured schema with all models
- ✅ Injected ModelContext into environment
- ✅ Added error handling for container initialization
- ✅ Integrated seed service on first launch

**Acceptance Criteria**:
- ✅ App launches without database errors
- ✅ ModelContext available to all views
- ✅ Database file created in app container

---

### 2.3 Create Seed Data Service 🔴 ✅
**Description**: Implement intervention seeding on first launch

**Status**: COMPLETED

**What was done**:
- ✅ Created `interventions.json` with all 32 interventions
- ✅ Implemented JSON loading in `InterventionsData.swift`
- ✅ Created `SeedDataService.swift` with first-launch detection
- ✅ Seeds 32 interventions on first launch
- ✅ Added proper error handling and logging

**Interventions by Category**:
- ✅ Stratospheric/SRM: 3 interventions
- ✅ Ice Preservation: 4 interventions
- ✅ Ocean-Based: 6 interventions
- ✅ Land-Based: 7 interventions
- ✅ Localized: 8 interventions
- ✅ Advanced/Emerging: 4 interventions

**Acceptance Criteria**:
- ✅ Database seeds automatically on first launch
- ✅ All 32 interventions are inserted
- ✅ Subsequent launches don't re-seed
- ✅ Each intervention has complete data (bio, pros, cons, symbols, gradients, personality)

**Notes**:
- Data moved from hardcoded Swift to JSON for easier maintenance
- JSON file located at `DateAnIntervention/Resources/interventions.json`

---

## Phase 3: Swipe Interface

### 3.1 Create Basic Card View 🟡 ✅
**Description**: Build individual intervention card component

**Status**: COMPLETED

**What was done**:
- ✅ Created `InterventionCardView.swift`
- ✅ Designed card layout with image, name, category badge
- ✅ Added SF Symbol with gradient background
- ✅ Styled with rounded corners and shadow
- ✅ Made card responsive (~90% screen width)
- ✅ Added bottom info overlay with gradient

**Acceptance Criteria**:
- ✅ Card displays intervention data beautifully
- ✅ Gradient background with SF Symbol renders correctly
- ✅ Card is visually appealing and matches dating app aesthetic
- ✅ Bio preview shows first 3 lines

**File**: `DateAnIntervention/Views/Swipe/InterventionCardView.swift`

---

### 3.2 Implement Card Stack 🔴 ✅
**Description**: Create stack view with multiple cards and depth effect

**Status**: COMPLETED

**What was done**:
- ✅ Created `CardStackView.swift`
- ✅ Renders top 3 cards with z-index ordering
- ✅ Applied scale and offset for 3D depth effect
- ✅ Manages card array and current index
- ✅ Handles card removal and next card appearance
- ✅ Added empty state with reset functionality

**Acceptance Criteria**:
- ✅ Multiple cards visible with depth perception
- ✅ Cards properly stacked with correct z-order
- ✅ Removing top card reveals next one smoothly
- ✅ Empty state shows when deck is complete

**File**: `DateAnIntervention/Views/Swipe/CardStackView.swift`

---

### 3.3 Add Swipe Gestures 🔴 ✅
**Description**: Implement drag gesture with swipe detection

**Status**: COMPLETED

**What was done**:
- ✅ Added DragGesture to top card
- ✅ Calculates rotation based on horizontal offset
- ✅ Detects swipe threshold (100 points)
- ✅ Auto-complete swipe animation on release
- ✅ Added spring animation for card return or removal
- ✅ Smooth natural card rotation while dragging

**Acceptance Criteria**:
- ✅ Card rotates naturally while dragging
- ✅ Card snaps back if not past threshold
- ✅ Card animates off-screen if past threshold
- ✅ Gesture feels smooth and responsive

**Technical Details**:
- Spring animation with 0.5 response, 0.7 damping
- Rotation multiplier: 0.15 degrees per point
- Swipe threshold: 100 points

---

### 3.4 Add Like/Dislike Indicators 🟡 ✅
**Description**: Show visual feedback during swipe

**Status**: COMPLETED

**What was done**:
- ✅ Created overlay views for "LIKE" (green) and "NOPE" (red)
- ✅ Show/hide based on drag direction
- ✅ Fade in based on drag distance
- ✅ Positioned indicators on card corners
- ✅ Added rotation to indicators for style

**Acceptance Criteria**:
- ✅ Indicators appear while dragging
- ✅ Opacity increases with drag distance
- ✅ Correct indicator shows for direction
- ✅ Indicators disappear when card is released

**Visual Design**:
- "LIKE" - Green text, stroked border, +15° rotation
- "NOPE" - Red text, stroked border, -15° rotation
- Opacity: 0 → 1.0 based on distance/threshold

---

### 3.5 Add Haptic Feedback 🟢 ✅
**Description**: Provide tactile feedback for interactions

**Status**: COMPLETED

**What was done**:
- ✅ Created `HapticService.swift`
- ✅ Triggers light impact when reaching swipe threshold
- ✅ Triggers success haptic on like/match
- ✅ Triggers medium impact on dislike
- ✅ Added selection and error haptics for future use

**Acceptance Criteria**:
- ✅ Haptics fire at appropriate times
- ✅ Feedback intensity is appropriate
- ✅ Haptics work on physical devices

**File**: `DateAnIntervention/Services/HapticService.swift`

**Available Haptics**:
- `lightImpact()` - Threshold reached
- `mediumImpact()` - Dislike
- `success()` - Like
- `selection()` - Taps
- `error()` - Errors

---

### 3.6 Create Swipe ViewModel 🟡 ✅
**Description**: Implement business logic for swipe interactions

**Status**: COMPLETED

**What was done**:
- ✅ Created `SwipeViewModel.swift` with @Observable
- ✅ Fetches interventions from SwiftData
- ✅ Implements `swipeRight()` and `swipeLeft()` methods
- ✅ Saves SwipeDecision to database
- ✅ Tracks current card index
- ✅ Detects when deck is empty
- ✅ Filters out already-swiped interventions
- ✅ Provides reset functionality

**Acceptance Criteria**:
- ✅ ViewModel properly manages state
- ✅ Swipe decisions persist to database
- ✅ View updates reactively to model changes
- ✅ Empty state handled gracefully

**File**: `DateAnIntervention/ViewModels/SwipeViewModel.swift`

**Features**:
- Reactive state with @Observable
- Efficient filtering using Set for swiped IDs
- Automatic deck reload on reset

---

## Phase 4: Profile Details

### 4.1 Create Profile Detail View 🟡 ✅
**Description**: Build full-screen intervention profile

**Status**: COMPLETED

**What was done**:
- ✅ Created `ProfileDetailView.swift`
- ✅ Added ScrollView with all profile sections
- ✅ Display intervention name and category
- ✅ Show full bio text
- ✅ List Strengths (pros) with checkmark icons
- ✅ List Challenges (cons) with warning icons
- ✅ Integrated stats grid display
- ✅ Added Message button at bottom with gradient styling

**Acceptance Criteria**:
- ✅ Profile displays all intervention data
- ✅ Layout is clean and readable
- ✅ Scrolling works smoothly
- ✅ Matches dating app aesthetic

**File**: `DateAnIntervention/Views/Profile/ProfileDetailView.swift`

---

### 4.2 Create Image Carousel 🟡 ✅
**Description**: Build image viewer for intervention photos

**Status**: COMPLETED

**What was done**:
- ✅ Created `ImageCarouselView.swift`
- ✅ Built TabView with 3 gradient variations
- ✅ Support SF Symbols with different gradient angles
- ✅ Added custom page indicators
- ✅ Vary symbol size, opacity, and rotation for visual interest
- ✅ Apply intervention-specific gradient backgrounds

**Acceptance Criteria**:
- ✅ Can swipe between multiple images (3 variations)
- ✅ SF Symbols render with gradients
- ✅ Page indicators show current position
- ✅ Images fill available space properly

**File**: `DateAnIntervention/Views/Profile/ImageCarouselView.swift`

**Notes**:
- Currently shows 3 artistic variations of the SF Symbol
- Can be easily extended to support actual photos in the future

---

### 4.3 Add Stats Grid Component 🟢 ✅
**Description**: Create reusable stats display

**Status**: COMPLETED

**What was done**:
- ✅ Created `StatsGridView.swift` and `StatItemView`
- ✅ Display 3 key metrics: Research Level, Tech Readiness, Public Support
- ✅ Styled with icons in colored circles
- ✅ Added progress bars showing metric values
- ✅ Made responsive with flexible layout
- ✅ Used color coding (blue, purple, green)

**Acceptance Criteria**:
- ✅ Stats display clearly
- ✅ Grid layout adapts to content
- ✅ Visually consistent with app design

**File**: `DateAnIntervention/Views/Components/StatsGridView.swift`

---

### 4.4 Add Message Button & Navigation 🟢 ✅
**Description**: Connect profile to chat

**Status**: COMPLETED

**What was done**:
- ✅ Added large "Message" button at bottom of profile
- ✅ Styled with intervention gradient colors
- ✅ Button positioned over blurred background
- ✅ Added tap-to-view navigation from swipe cards
- ✅ Profile opens in full-screen sheet
- ✅ Added dismiss button in navigation bar
- ✅ Created action buttons (like/dislike/info) in SwipeView
- ✅ Sheet navigation ready for ChatView integration

**Acceptance Criteria**:
- ✅ Button is prominent and accessible
- ✅ Tapping card opens profile in sheet
- ✅ Can dismiss profile and return to swipe deck
- ✅ Navigation feels smooth
- ✅ Message button ready for chat integration

**Files Modified**:
- `DateAnIntervention/Views/Swipe/CardStackView.swift` (added tap gesture and sheet)
- `DateAnIntervention/Views/Swipe/SwipeView.swift` (added action buttons)

**Notes**:
- Message button currently shows placeholder sheet
- Will be connected to ChatView in Phase 5

---

## Phase 5: Chat Interface

### 5.1 Create Chat View Layout 🟡
**Description**: Build messaging interface

**Tasks**:
- [ ] Create `ChatView.swift`
- [ ] Add ScrollView for messages
- [ ] Create text input field with send button
- [ ] Position input at bottom with keyboard avoidance
- [ ] Add navigation bar with intervention name

**Acceptance Criteria**:
- Messages scrollable
- Input stays above keyboard
- Send button accessible
- Layout works on different screen sizes

---

### 5.2 Create Message Bubbles 🟡
**Description**: Build chat message components

**Tasks**:
- [ ] Create `MessageBubbleView.swift`
- [ ] Style user messages (right-aligned, blue)
- [ ] Style AI messages (left-aligned, gray)
- [ ] Add timestamp display
- [ ] Add message tails/corners

**Acceptance Criteria**:
- Messages clearly differentiated
- Alignment correct for sender
- Bubbles resize based on content
- Matches dating app chat aesthetic

---

### 5.3 Create Chat ViewModel 🟡
**Description**: Implement chat business logic

**Tasks**:
- [ ] Create `ChatViewModel.swift` with @Observable
- [ ] Manage messages array
- [ ] Implement `sendMessage()` method
- [ ] Load chat history from SwiftData
- [ ] Save messages to SwiftData
- [ ] Handle loading states

**Acceptance Criteria**:
- Messages persist across sessions
- New messages save to database
- Loading state displays during API calls
- Error states handled gracefully

---

### 5.4 Implement LLM Service 🔴
**Description**: Create service for AI chat integration

**Tasks**:
- [ ] Create `LLMService.swift`
- [ ] Implement OpenAI API client
- [ ] Create system prompt generator using intervention data
- [ ] Send conversation history with each request
- [ ] Parse API responses
- [ ] Add error handling (network, API errors, rate limits)
- [ ] Support both OpenAI and Anthropic (configurable)

**Acceptance Criteria**:
- Service successfully calls LLM API
- System prompt includes intervention personality and facts
- Responses are contextually appropriate
- Errors handled with user-friendly messages
- API key loaded from config securely

---

### 5.5 Add Chat Features 🟢
**Description**: Polish chat experience

**Tasks**:
- [ ] Auto-scroll to bottom on new messages
- [ ] Show typing indicator during API call
- [ ] Disable send button while loading
- [ ] Add empty state for new conversations

**Acceptance Criteria**:
- Chat auto-scrolls appropriately
- Loading states are clear
- User can't send multiple messages simultaneously
- Empty state is informative

---

## Phase 6: Matches Screen

### 6.1 Create Matches View 🟡
**Description**: Build screen showing all liked interventions

**Tasks**:
- [ ] Create `MatchesView.swift`
- [ ] Query SwiftData for liked interventions
- [ ] Display in grid layout (2 columns)
- [ ] Show thumbnail cards with images
- [ ] Add navigation to profile/chat

**Acceptance Criteria**:
- All matches display correctly
- Grid is responsive
- Tapping a match navigates to its profile
- Empty state shown when no matches

---

### 6.2 Add Match Statistics 🟢
**Description**: Show summary stats on matches screen

**Tasks**:
- [ ] Calculate total swipes (liked + disliked)
- [ ] Calculate like percentage
- [ ] Find most-liked category
- [ ] Display in header section

**Acceptance Criteria**:
- Stats calculate correctly
- Display is clear and concise
- Updates in real-time as user swipes

---

### 6.3 Create Navigation System 🟡
**Description**: Set up app-wide navigation

**Tasks**:
- [ ] Create tab bar or navigation in ContentView
- [ ] Add Swipe, Matches, and Settings tabs
- [ ] Configure navigation between screens
- [ ] Handle deep linking to profiles/chats

**Acceptance Criteria**:
- Can navigate between all main screens
- Navigation state persists appropriately
- Back navigation works correctly
- Tab selection is clear

---

## Phase 7: Configuration & Services

### 7.1 Implement Config Service 🟡
**Description**: Handle app configuration and secrets

**Tasks**:
- [ ] Create `ConfigService.swift`
- [ ] Load API key from .env file or environment
- [ ] Validate configuration on startup
- [ ] Provide config to services that need it

**Acceptance Criteria**:
- API key loads correctly
- Missing config shows helpful error
- Config is not committed to git

---

### 7.2 Add Error Handling 🟡
**Description**: Implement consistent error handling

**Tasks**:
- [ ] Create custom error types
- [ ] Add error alerts throughout app
- [ ] Handle network errors gracefully
- [ ] Add retry logic where appropriate

**Acceptance Criteria**:
- Errors show user-friendly messages
- Network issues handled gracefully
- User can recover from errors
- App doesn't crash on failures

---

### 7.3 Add Loading States 🟢
**Description**: Implement loading indicators

**Tasks**:
- [ ] Add ProgressView during data loads
- [ ] Show skeleton screens where appropriate
- [ ] Disable UI during async operations

**Acceptance Criteria**:
- Loading states are clear
- User knows when app is working
- UI is disabled during critical operations

---

## Phase 8: Polish & UX

### 8.1 Design App Icon 🟡
**Description**: Create app icon

**Tasks**:
- [ ] Design icon concept (Earth + heart or swipe gesture)
- [ ] Create icon assets for all sizes
- [ ] Add to Assets.xcassets

**Acceptance Criteria**:
- Icon displays on home screen
- All sizes provided
- Icon matches app concept

---

### 8.2 Create Launch Screen 🟢
**Description**: Add launch screen

**Tasks**:
- [ ] Design simple launch screen
- [ ] Match app branding
- [ ] Configure in project settings

**Acceptance Criteria**:
- Launch screen shows on app start
- Smooth transition to main UI

---

### 8.3 Add Onboarding 🟡
**Description**: Create first-launch experience

**Tasks**:
- [ ] Design 2-3 onboarding screens
- [ ] Explain app concept and controls
- [ ] Show only on first launch
- [ ] Add skip button

**Acceptance Criteria**:
- Onboarding is clear and concise
- Shows only once
- User can skip if desired

---

### 8.4 Polish Animations 🟡
**Description**: Refine all transitions and animations

**Tasks**:
- [ ] Tune spring animation parameters
- [ ] Add micro-interactions (button press, etc.)
- [ ] Ensure consistent animation timing
- [ ] Add animated transitions between screens

**Acceptance Criteria**:
- Animations feel smooth and natural
- Timing is consistent throughout app
- No janky or stuttering animations

---

### 8.5 Implement Accessibility 🟡
**Description**: Add accessibility support

**Tasks**:
- [ ] Add accessibility labels to all controls
- [ ] Support Dynamic Type
- [ ] Test with VoiceOver
- [ ] Ensure sufficient color contrast

**Acceptance Criteria**:
- VoiceOver reads all content correctly
- Text scales with user preferences
- App is usable with accessibility features

---

### 8.6 Add Empty States 🟢
**Description**: Design empty and end states

**Tasks**:
- [ ] Create "no more cards" end state for swipe deck
- [ ] Create "no matches yet" state
- [ ] Create "no messages" state for new chats
- [ ] Make states friendly and encouraging

**Acceptance Criteria**:
- All empty states are informative
- User knows what to do next
- States match app aesthetic

---

## Phase 9: Testing & QA

### 9.1 Write Unit Tests 🟡
**Description**: Test core business logic

**Tasks**:
- [ ] Test SwipeViewModel logic
- [ ] Test ChatViewModel logic
- [ ] Test LLMService (mocked)
- [ ] Test data model validation

**Acceptance Criteria**:
- All critical logic has tests
- Tests pass consistently
- Code coverage > 60%

---

### 9.2 Write UI Tests 🔴
**Description**: Test user flows

**Tasks**:
- [ ] Test swipe gestures
- [ ] Test navigation flows
- [ ] Test chat interaction
- [ ] Test matches screen

**Acceptance Criteria**:
- Core flows covered by UI tests
- Tests run reliably
- Failures are clear and actionable

---

### 9.3 Manual QA Pass 🟡
**Description**: Thorough manual testing

**Tasks**:
- [ ] Test on multiple device sizes (SE, standard, Plus/Max)
- [ ] Test on iPad if desired
- [ ] Test all edge cases (no internet, API errors, etc.)
- [ ] Test data persistence across app restarts
- [ ] Verify memory usage is reasonable

**Acceptance Criteria**:
- App works on all target devices
- No crashes or major bugs
- Performance is acceptable
- Data persists correctly

---

## Phase 10: Deployment Prep

### 10.1 Configure App Store Metadata 🟢
**Description**: Prepare for distribution

**Tasks**:
- [ ] Write app description
- [ ] Create screenshots for App Store
- [ ] Set privacy policy (if needed)
- [ ] Configure version and build numbers

**Acceptance Criteria**:
- All metadata ready
- Screenshots show key features
- Version set correctly

---

### 10.2 Create Build for TestFlight 🟡
**Description**: Prepare beta build

**Tasks**:
- [ ] Archive app build
- [ ] Upload to App Store Connect
- [ ] Configure TestFlight testing
- [ ] Invite beta testers

**Acceptance Criteria**:
- Build uploads successfully
- Beta testers can install
- No critical bugs in beta

---

### 10.3 Final Documentation 🟢
**Description**: Complete project documentation

**Tasks**:
- [ ] Update README with final info
- [ ] Document any deployment steps
- [ ] Add screenshots to README
- [ ] Create user guide if needed

**Acceptance Criteria**:
- Documentation is complete and accurate
- Instructions are clear
- Screenshots are current

---

## Summary

**Total Tasks**: ~65
- 🟢 Easy: ~20 tasks
- 🟡 Medium: ~30 tasks
- 🔴 Complex: ~15 tasks

**Estimated Total Time**: 60-80 hours

**Recommended Order**:
1. Complete all Phase 1-2 tasks (foundation)
2. Build Phase 3 (swipe interface) - core feature
3. Add Phase 4 (profiles) - enhances swipe feature
4. Implement Phase 5 (chat) - key differentiator
5. Create Phase 6 (matches) - completes core loop
6. Add Phase 7 (config) - necessary infrastructure
7. Polish in Phase 8 - makes it great
8. Test in Phase 9 - ensures quality
9. Deploy in Phase 10 - ship it!

**Dependencies**:
- Phases 1-2 must be completed first
- Phase 3 can start after Phase 2
- Phases 4-6 can be done in parallel after Phase 3
- Phases 7-8 should be done after core features
- Phase 9 should be ongoing
- Phase 10 is final

Good luck! Check off tasks as you complete them and commit frequently.
