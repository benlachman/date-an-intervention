# Implementation Tasks

This document breaks down the complete implementation into actionable tasks organized by phase. Each task includes acceptance criteria and complexity estimates.

**Complexity Legend:**
- 🟢 **Easy** (< 1 hour)
- 🟡 **Medium** (1-3 hours)
- 🔴 **Complex** (3+ hours)

---

## Phase 1: Project Setup & Foundation

### 1.1 Create Xcode Project 🟢
**Description**: Initialize the Xcode project with proper configuration

**Tasks**:
- [ ] Create new iOS App project named "DateAnIntervention"
- [ ] Set bundle identifier (e.g., `com.yourdomain.dateanintervention`)
- [ ] Set deployment target to iOS 18.0
- [ ] Enable SwiftUI interface and Swift language
- [ ] Configure project for SwiftData

**Acceptance Criteria**:
- Project builds and runs on simulator
- Empty SwiftUI app appears
- No build warnings or errors

---

### 1.2 Configure Build Settings 🟢
**Description**: Set up build configuration and environment

**Tasks**:
- [ ] Create `Config.xcconfig` file for build settings
- [ ] Add `.env.example` template
- [ ] Update `.gitignore` to exclude `.env`
- [ ] Configure Info.plist for API access (App Transport Security)

**Acceptance Criteria**:
- `.env.example` exists with placeholder values
- `.env` is gitignored
- Config file properly linked in project

---

### 1.3 Create Directory Structure 🟢
**Description**: Set up file organization matching ARCHITECTURE.md

**Tasks**:
- [ ] Create folder groups: App, Models, Data, Views, ViewModels, Services, Utilities
- [ ] Create subfolders: Views/Swipe, Views/Profile, Views/Chat, Views/Matches
- [ ] Add .gitkeep files where needed
- [ ] Organize project navigator

**Acceptance Criteria**:
- All folders exist and are properly nested
- Project navigator is clean and organized

---

## Phase 2: Data Models & SwiftData

### 2.1 Define Core Models 🟡
**Description**: Create SwiftData models for all entities

**Tasks**:
- [ ] Create `InterventionCategory` enum
- [ ] Create `Intervention` model with all properties
- [ ] Create `SwipeDecision` model
- [ ] Create `ChatMessage` model
- [ ] Add proper relationships and attributes

**Acceptance Criteria**:
- All models compile without errors
- SwiftData attributes properly configured (@Model, @Attribute, etc.)
- Relationships defined where needed

---

### 2.2 Set Up SwiftData Container 🟡
**Description**: Configure ModelContainer and context

**Tasks**:
- [ ] Create ModelContainer in app entry point
- [ ] Configure schema with all models
- [ ] Inject ModelContext into environment
- [ ] Add error handling for container initialization

**Acceptance Criteria**:
- App launches without database errors
- ModelContext available to all views
- Database file created in app container

---

### 2.3 Create Seed Data Service 🔴
**Description**: Implement intervention seeding on first launch

**Tasks**:
- [ ] Create `InterventionsData.swift` with hardcoded interventions (see INTERVENTIONS.md)
- [ ] Implement seeding logic to check if database is empty
- [ ] Seed 30+ interventions on first launch
- [ ] Add proper error handling

**Acceptance Criteria**:
- Database seeds automatically on first launch
- All 30+ interventions are inserted
- Subsequent launches don't re-seed
- Each intervention has complete data

---

## Phase 3: Swipe Interface

### 3.1 Create Basic Card View 🟡
**Description**: Build individual intervention card component

**Tasks**:
- [ ] Create `InterventionCardView.swift`
- [ ] Design card layout (image, name, category badge)
- [ ] Add SF Symbol with gradient background
- [ ] Style with rounded corners and shadow
- [ ] Make card fill ~90% screen width

**Acceptance Criteria**:
- Card displays intervention data
- Gradient background with SF Symbol renders correctly
- Card is visually appealing and matches dating app aesthetic

---

### 3.2 Implement Card Stack 🔴
**Description**: Create stack view with multiple cards and depth effect

**Tasks**:
- [ ] Create `CardStackView.swift`
- [ ] Render top 3-5 cards with z-index
- [ ] Apply scale and offset for depth effect
- [ ] Manage card array and current index
- [ ] Handle card removal and next card appearance

**Acceptance Criteria**:
- Multiple cards visible with depth perception
- Cards properly stacked with correct z-order
- Removing top card reveals next one smoothly

---

### 3.3 Add Swipe Gestures 🔴
**Description**: Implement drag gesture with swipe detection

**Tasks**:
- [ ] Add DragGesture to top card
- [ ] Calculate rotation based on horizontal offset
- [ ] Detect swipe threshold (e.g., 100 points)
- [ ] Auto-complete swipe animation on release
- [ ] Add spring animation for card return or removal

**Acceptance Criteria**:
- Card rotates naturally while dragging
- Card snaps back if not past threshold
- Card animates off-screen if past threshold
- Gesture feels smooth and responsive

---

### 3.4 Add Like/Dislike Indicators 🟡
**Description**: Show visual feedback during swipe

**Tasks**:
- [ ] Create overlay views for "LIKE" (green) and "NOPE" (red)
- [ ] Show/hide based on drag direction
- [ ] Fade in based on drag distance
- [ ] Position indicators on card corners

**Acceptance Criteria**:
- Indicators appear while dragging
- Opacity increases with drag distance
- Correct indicator shows for direction
- Indicators disappear when card is released

---

### 3.5 Add Haptic Feedback 🟢
**Description**: Provide tactile feedback for interactions

**Tasks**:
- [ ] Create `HapticService.swift`
- [ ] Trigger light impact when reaching swipe threshold
- [ ] Trigger success haptic on like/match
- [ ] Trigger selection haptic on card tap

**Acceptance Criteria**:
- Haptics fire at appropriate times
- Feedback intensity is appropriate
- Haptics work on physical devices

---

### 3.6 Create Swipe ViewModel 🟡
**Description**: Implement business logic for swipe interactions

**Tasks**:
- [ ] Create `SwipeViewModel.swift` with @Observable
- [ ] Fetch interventions from SwiftData
- [ ] Implement `swipeRight()` and `swipeLeft()` methods
- [ ] Save SwipeDecision to database
- [ ] Track current card index
- [ ] Detect when deck is empty

**Acceptance Criteria**:
- ViewModel properly manages state
- Swipe decisions persist to database
- View updates reactively to model changes
- Empty state handled gracefully

---

## Phase 4: Profile Details

### 4.1 Create Profile Detail View 🟡
**Description**: Build full-screen intervention profile

**Tasks**:
- [ ] Create `ProfileDetailView.swift`
- [ ] Add ScrollView with all profile sections
- [ ] Display intervention name and category
- [ ] Show bio text
- [ ] List interests (pros) and dealbreakers (cons)
- [ ] Add stats grid (research level, tech readiness, support)

**Acceptance Criteria**:
- Profile displays all intervention data
- Layout is clean and readable
- Scrolling works smoothly
- Matches dating app aesthetic

---

### 4.2 Create Image Carousel 🟡
**Description**: Build image viewer for intervention photos

**Tasks**:
- [ ] Create `ImageCarouselView.swift`
- [ ] Support both SF Symbols and actual images
- [ ] Add horizontal paging with TabView or custom gesture
- [ ] Show page indicators
- [ ] Apply gradient backgrounds to SF Symbols

**Acceptance Criteria**:
- Can swipe between multiple images
- SF Symbols render with gradients
- Page indicators show current position
- Images fill available space properly

---

### 4.3 Add Stats Grid Component 🟢
**Description**: Create reusable stats display

**Tasks**:
- [ ] Create `StatsGridView.swift`
- [ ] Display 3-4 key metrics in grid
- [ ] Style with icons and labels
- [ ] Make responsive to different screen sizes

**Acceptance Criteria**:
- Stats display clearly
- Grid layout adapts to content
- Visually consistent with app design

---

### 4.4 Add Message Button & Navigation 🟢
**Description**: Connect profile to chat

**Tasks**:
- [ ] Add large "Message" button at bottom
- [ ] Implement navigation to ChatView
- [ ] Pass intervention to chat
- [ ] Add dismiss gesture for profile modal

**Acceptance Criteria**:
- Button is prominent and accessible
- Tapping button opens chat
- Can dismiss profile and return to swipe deck
- Navigation feels smooth

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
