# Development Team Configuration

To avoid reselecting your development team every time you regenerate the Xcode project:

## Find Your Team ID

1. Open Xcode
2. Go to **Xcode → Preferences → Accounts**
3. Select your Apple ID
4. Click **Manage Certificates**
5. Your Team ID is shown next to your team name (e.g., `AB12CD34EF`)

Or run this command:
```bash
security find-identity -v -p codesigning
```

## Set Your Team ID

Edit `project.yml` and replace `YOUR_TEAM_ID` with your actual Team ID:

```yaml
options:
  bundleIdPrefix: com.nicemohawk
  deploymentTarget:
    iOS: "18.0"
  developmentLanguage: en
  xcodeVersion: "15.0"
  developmentTeam: AB12CD34EF  # ← Replace with your Team ID
```

## Regenerate Project

After setting your Team ID:

```bash
xcodegen generate
```

Your development team will now be automatically selected in the Xcode project! ✅

## Note

Don't commit your Team ID to git if you're working with others who have different Team IDs. You can:

1. Add it to `.gitignore` and use a local override
2. Or just set it manually in Xcode once after each `xcodegen generate`
