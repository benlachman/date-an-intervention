#!/bin/sh

#  ci_post_clone.sh
#  Date An Intervention
#
#  Xcode Cloud post-clone script
#  Generates Config.plist from environment variables for CI builds
#

set -e

echo "🔧 Running post-clone script for Xcode Cloud..."

# Check if we're running in Xcode Cloud
if [ -z "$CI_WORKSPACE" ]; then
    echo "⚠️  Not running in Xcode Cloud, skipping Config.plist generation"
    exit 0
fi

# Generate Config.plist with environment variables
CONFIG_PATH="$CI_PRIMARY_REPOSITORY_PATH/DateAnIntervention/Config.plist"

echo "📝 Generating Config.plist at: $CONFIG_PATH"

cat > "$CONFIG_PATH" <<EOF
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

# Set appropriate permissions
chmod 644 "$CONFIG_PATH"

echo "✅ Config.plist generated successfully"

# Verify the file was created
if [ -f "$CONFIG_PATH" ]; then
    echo "✅ Verified: Config.plist exists"
    echo "📄 File size: $(wc -c < "$CONFIG_PATH") bytes"
else
    echo "❌ Error: Config.plist was not created"
    exit 1
fi

echo "🎉 Post-clone script completed successfully"
