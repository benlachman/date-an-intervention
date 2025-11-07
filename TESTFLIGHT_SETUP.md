# TestFlight & Xcode Cloud Setup Guide

Complete guide for setting up internal/external TestFlight builds and Xcode Cloud CI/CD for Date An Intervention.

## Prerequisites

### Apple Developer Account Requirements
- **Active Apple Developer Program membership** ($99/year)
- **Team Agent or Admin role** for the account
- **App Store Connect access**

### Xcode Setup
- Xcode 15.0+ installed
- Signed in to your Apple Developer account in Xcode (Preferences → Accounts)

### App Configuration
- Unique Bundle Identifier (currently: `com.yourcompany.DateAnIntervention`)
- App icons for all required sizes
- Privacy descriptions in Info.plist (already configured)

---

## Part 1: Initial App Store Connect Setup

### 1. Create App in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **Apps** → **+** (Add App)
3. Fill in details:
   - **Platform**: iOS
   - **Name**: Date An Intervention
   - **Primary Language**: English
   - **Bundle ID**: Select or create `com.yourcompany.DateAnIntervention`
   - **SKU**: `date-an-intervention` (or any unique identifier)
   - **User Access**: Full Access

### 2. Update Bundle Identifier (if needed)

In Xcode project:
1. Open `DateAnIntervention.xcodeproj`
2. Select project in navigator → **DateAnIntervention** target
3. **Signing & Capabilities** tab
4. Update **Bundle Identifier** to match App Store Connect
5. Enable **Automatically manage signing**
6. Select your **Team**

### 3. Configure App Information

In App Store Connect:
1. **App Information**:
   - Category: Education or Utilities
   - Age Rating: Complete questionnaire

2. **Pricing and Availability**:
   - Price: Free (or set pricing)
   - Availability: Select countries

---

## Part 2: Xcode Cloud Setup

Xcode Cloud provides automated building, testing, and distribution.

### 1. Enable Xcode Cloud

1. In Xcode, select **Product** → **Xcode Cloud** → **Create Workflow**
2. Choose **DateAnIntervention** scheme
3. Click **Get Started**
4. Grant Xcode Cloud access to your repository

### 2. Configure Source Control

**For GitHub:**
1. Xcode Cloud will prompt for repository access
2. Install the Xcode Cloud GitHub app
3. Grant access to your repository
4. Xcode Cloud will automatically detect `date-an-intervention`

**Important for API Keys:**
- Your `Config.plist` is gitignored (good!)
- You'll need to set up environment variables or secrets in Xcode Cloud

### 3. Create Build Workflow

#### Default Workflow (Continuous Integration)
```yaml
# This creates automatically when you enable Xcode Cloud
Name: CI
Trigger: On every push to any branch
Actions:
  - Build
  - Test (if you have tests)
```

#### TestFlight Workflow (for distribution)

1. In Xcode Cloud settings (Product → Xcode Cloud → Manage Workflows)
2. Click **+** to create new workflow
3. Name it: "TestFlight Distribution"
4. Configure:

**Environment:**
- Xcode Version: Latest Release
- Clean Build: Yes (first time)

**Start Conditions:**
```
Branch: main (or your production branch)
Trigger: On Tag Creation
Pattern: v*.*.*  (e.g., v1.0.0, v1.0.1)
```

**Actions:**
- ✅ Archive
- ✅ TestFlight Internal Testing
- ✅ Analyze (optional)

**Post-Actions:**
- ✅ Notify on Success
- ✅ Notify on Failure

### 4. Configure Environment Variables (for API Keys)

Since `Config.plist` is gitignored, set up Xcode Cloud environment variables:

1. In App Store Connect → **Xcode Cloud** → **Settings**
2. Add **Environment Variables**:
   ```
   OPENAI_API_KEY = your_key_here (mark as secret)
   ANTHROPIC_API_KEY = your_key_here (mark as secret)
   ```

3. Create a build script to generate `Config.plist`:

Create `ci_scripts/ci_post_clone.sh`:
```bash
#!/bin/sh
set -e

# Generate Config.plist for Xcode Cloud builds
cat > "$CI_PRIMARY_REPOSITORY_PATH/DateAnIntervention/Config.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>OPENAI_API_KEY</key>
    <string>${OPENAI_API_KEY}</string>
    <key>ANTHROPIC_API_KEY</key>
    <string>${ANTHROPIC_API_KEY}</string>
    <key>LLM_PROVIDER</key>
    <string>openai</string>
    <key>LLM_MODEL</key>
    <string>gpt-4o</string>
    <key>LLM_TEMPERATURE</key>
    <string>0.9</string>
    <key>LLM_MAX_TOKENS</key>
    <string>150</string>
</dict>
</plist>
EOF

chmod 644 "$CI_PRIMARY_REPOSITORY_PATH/DateAnIntervention/Config.plist"
echo "Config.plist generated for Xcode Cloud"
```

Make it executable:
```bash
chmod +x ci_scripts/ci_post_clone.sh
```

---

## Part 3: Internal TestFlight Setup

Internal testing is for your team (up to 100 testers, no review required).

### 1. Add Internal Testers

1. Go to **App Store Connect** → **TestFlight** → **Internal Testing**
2. Click **App Store Connect Users** group (or create new group)
3. Add testers:
   - Must be App Store Connect users
   - Automatically approved
   - Can test immediately after build processes

### 2. Create First Build

**Manual Upload (first time):**
1. In Xcode: **Product** → **Archive**
2. Wait for archive to complete
3. Click **Distribute App**
4. Select **TestFlight & App Store**
5. Choose **Upload**
6. Follow prompts (sign, review, upload)
7. Wait for processing (10-30 minutes)

**Or via Xcode Cloud:**
1. Create a git tag: `git tag v1.0.0`
2. Push tag: `git push origin v1.0.0`
3. Xcode Cloud automatically builds and uploads
4. Monitor in App Store Connect → Xcode Cloud

### 3. Configure Build for Internal Testing

1. Once build shows in TestFlight:
2. Click the build
3. Review **Build Information**:
   - What to Test: Describe changes
   - Test Information: Complete required fields
   - Export Compliance: Answer questions
4. Build automatically goes to internal testers

### 4. Internal Testers Install App

Testers will:
1. Receive email invitation
2. Install **TestFlight** app from App Store
3. Open invitation link
4. Install your app through TestFlight
5. Provide feedback directly in TestFlight

---

## Part 4: External TestFlight Setup

External testing allows up to 10,000 testers, but requires App Review for first build.

### 1. Prepare for External Testing

**Required before external testing:**
- App icon (all sizes)
- Privacy Policy URL
- App Store screenshots (at least 1 set)
- App Description
- Keywords
- Support URL
- Marketing URL (optional)

### 2. Create External Test Group

1. **App Store Connect** → **TestFlight** → **External Testing**
2. Click **+** to create group
3. Name it (e.g., "Beta Testers")
4. Add build to group
5. Enable **Automatic Distribution** (optional)

### 3. Submit for Beta App Review

First external build requires review:

1. Add build to external group
2. Fill in **Test Information**:
   - Beta App Description
   - Feedback Email
   - What to Test
   - App Privacy Policy URL

3. Click **Submit for Review**
4. Wait 24-48 hours for approval

**Export Compliance:**
- If app uses encryption (HTTPS calls count):
  - Select "Yes" for encryption
  - Select "No" for qualifying exemptions (standard HTTPS)
  - Or complete CCATS form

### 4. Add External Testers

**Via Email:**
1. Click **Add Testers** in external group
2. Enter email addresses (comma-separated)
3. Testers receive invitation email

**Via Public Link:**
1. Enable **Public Link** in external group settings
2. Copy link
3. Share anywhere (social media, website, etc.)
4. Anyone with link can join (up to 10,000 testers)

### 5. Subsequent Builds

After first approval:
- New builds go to testers automatically (if auto-distribution enabled)
- Major changes may require re-review
- Minor updates typically don't need review

---

## Part 5: Best Practices & Tips

### Version Numbering

Use semantic versioning:
- **Version**: `1.0.0` (user-facing, set in Xcode)
- **Build**: `1` (increment for each TestFlight build)

Update before each build:
1. In Xcode target settings
2. Or automate with agvtool:
   ```bash
   agvtool next-version -all  # Increment build number
   ```

### Automated Workflow

Recommended git workflow:
```bash
# Development
git checkout develop
git commit -m "feat: new feature"
git push

# Release to TestFlight
git checkout main
git merge develop
git tag v1.0.1
git push origin main --tags

# Xcode Cloud automatically builds and distributes
```

### Testing Checklist

Before sending to external testers:
- [ ] Test on multiple device sizes
- [ ] Test on oldest supported iOS version
- [ ] Verify API keys work in build
- [ ] Test all core features
- [ ] Check crash logs in Xcode Organizer
- [ ] Review TestFlight feedback from internal testers
- [ ] Update "What to Test" notes

### Monitoring Builds

**Xcode Cloud:**
- Monitor builds: Product → Xcode Cloud → View Builds
- Check logs if build fails
- Review test results

**TestFlight:**
- View installs, sessions, crashes
- Read tester feedback
- Check Beta App Review status

### Common Issues

**Build Processing Stuck:**
- Usually resolves in 30-60 minutes
- Check App Store Connect status page
- Contact Apple Developer Support if > 2 hours

**Missing Compliance:**
- Always set export compliance info
- Required for TestFlight distribution
- Can set default in App Store Connect

**Crashes on Specific Devices:**
- Check crash logs in Xcode Organizer
- TestFlight provides aggregated crash data
- Enable TestFlight feedback for detailed reports

---

## Quick Start: Your First TestFlight Build

### Step-by-Step First Build

1. **Create App in App Store Connect**
   ```
   - Bundle ID: com.yourcompany.DateAnIntervention
   - Name: Date An Intervention
   - SKU: date-an-intervention
   ```

2. **Configure Xcode Project**
   ```
   - Enable "Automatically manage signing"
   - Select your Team
   - Set Version: 1.0.0, Build: 1
   ```

3. **Create Config.plist locally** (not in git)
   ```
   - Copy Config.plist.example to Config.plist
   - Add your real API keys
   ```

4. **Archive and Upload**
   ```
   Product → Archive
   Distribute App → TestFlight & App Store
   Upload → Wait for processing
   ```

5. **Add Internal Testers**
   ```
   App Store Connect → TestFlight → Internal Testing
   Add yourself as tester
   ```

6. **Test on Device**
   ```
   Install TestFlight app
   Accept invitation
   Install Date An Intervention
   Test the messaging features!
   ```

### Setting Up Xcode Cloud (After First Manual Build)

1. **Enable Xcode Cloud**
   ```
   Product → Xcode Cloud → Create Workflow
   Grant repository access
   ```

2. **Create ci_scripts/ci_post_clone.sh** (for API keys)

3. **Set Environment Variables** in App Store Connect

4. **Create Release Workflow**
   ```
   Trigger: Tag matching v*.*.*
   Actions: Archive → TestFlight
   ```

5. **Test Workflow**
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   # Watch build in App Store Connect
   ```

---

## Support & Resources

- **Apple Documentation**: [Xcode Cloud Docs](https://developer.apple.com/xcode-cloud/)
- **TestFlight Guide**: [TestFlight Beta Testing](https://developer.apple.com/testflight/)
- **App Store Connect**: [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
- **Developer Support**: [developer.apple.com/support](https://developer.apple.com/support)

---

## Next Steps

After TestFlight is working:

1. **Gather Feedback**: Use TestFlight's built-in feedback tools
2. **Iterate**: Push updates regularly via tags
3. **Monitor**: Check crash analytics and usage
4. **Prepare for Production**: When ready, submit to App Store
5. **App Store Submission**: Similar process, but requires full app listing

Good luck with your TestFlight builds! 🚀
