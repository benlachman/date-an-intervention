# API Setup Guide

This document explains how to set up API keys for the messaging feature in Date An Intervention.

## Overview

The app supports two LLM providers:
- **OpenAI** (ChatGPT-4o, GPT-3.5-turbo)
- **Anthropic** (Claude 3.5 Sonnet, Claude 3 Haiku)

## Setup Instructions

### Step 1: Get API Keys

#### OpenAI
1. Visit https://platform.openai.com/api-keys
2. Sign in or create an account
3. Click "Create new secret key"
4. Copy your API key (starts with `sk-proj-...`)

#### Anthropic (Optional)
1. Visit https://console.anthropic.com/
2. Sign in or create an account
3. Navigate to API Keys
4. Create a new API key
5. Copy your API key (starts with `sk-ant-...`)

### Step 2: Create Configuration File

1. Copy the example configuration file:
   ```bash
   cp Config.plist.example DateAnIntervention/Config.plist
   ```

2. Edit `DateAnIntervention/Config.plist` with your actual API keys:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>OPENAI_API_KEY</key>
       <string>sk-proj-YOUR_ACTUAL_KEY_HERE</string>
       <key>ANTHROPIC_API_KEY</key>
       <string>sk-ant-YOUR_ACTUAL_KEY_HERE</string>
       <key>LLM_PROVIDER</key>
       <string>openai</string>
       <key>LLM_MODEL</key>
       <string>gpt-4o</string>
       <key>LLM_TEMPERATURE</key>
       <string>0.8</string>
       <key>LLM_MAX_TOKENS</key>
       <string>250</string>
   </dict>
   </plist>
   ```

3. Add `Config.plist` to your Xcode project:
   - Open Xcode
   - Right-click on the `DateAnIntervention` folder
   - Select "Add Files to DateAnIntervention..."
   - Choose `Config.plist`
   - Make sure "Copy items if needed" is checked
   - Click "Add"

### Step 3: Configure Provider Settings

Edit `Config.plist` to customize your LLM settings:

#### LLM_PROVIDER
Choose which provider to use:
- `openai` (default) - Uses OpenAI's ChatGPT
- `anthropic` - Uses Anthropic's Claude

#### LLM_MODEL
Specify which model to use:

**OpenAI options:**
- `gpt-4o` (recommended) - Latest GPT-4 Optimized model
- `gpt-4` - GPT-4 standard
- `gpt-3.5-turbo` - Faster, cheaper option

**Anthropic options:**
- `claude-3-5-sonnet-20241022` (recommended) - Latest Claude 3.5 Sonnet
- `claude-3-haiku-20240307` - Faster, cheaper option

#### LLM_TEMPERATURE
Controls response creativity (0.0 - 1.0):
- `0.0` - More focused and deterministic
- `0.8` - Default, balanced creativity
- `1.0` - Maximum creativity

#### LLM_MAX_TOKENS
Maximum length of responses:
- `250` - Default, short responses
- `500` - Medium responses
- `1000` - Longer responses (costs more)

## Security Notes

- **NEVER commit `Config.plist` to version control** - it's already in `.gitignore`
- **Keep your API keys private** - treat them like passwords
- **Monitor your usage** - check your provider dashboards for billing
- **Set spending limits** - configure limits in your OpenAI/Anthropic accounts

## Troubleshooting

### "Invalid or missing API key" error
- Verify your API key is correct in `Config.plist`
- Make sure the key doesn't contain the placeholder text
- Check that `Config.plist` is added to the Xcode project

### "Network error" messages
- Check your internet connection
- Verify the API provider is not experiencing outages
- Check if your API key has billing enabled and credits available

### App crashes on messaging
- Make sure `Config.plist` is properly formatted XML
- Verify all required keys are present in the plist
- Check Xcode console for detailed error messages

## Example Configuration

### For OpenAI (Recommended for most users):
```xml
<key>LLM_PROVIDER</key>
<string>openai</string>
<key>LLM_MODEL</key>
<string>gpt-4o</string>
```

### For Anthropic:
```xml
<key>LLM_PROVIDER</key>
<string>anthropic</string>
<key>LLM_MODEL</key>
<string>claude-3-5-sonnet-20241022</string>
```

## Cost Estimates

**OpenAI Pricing (as of 2024):**
- GPT-4o: ~$0.005 per 1K input tokens, ~$0.015 per 1K output tokens
- GPT-3.5-turbo: ~$0.0005 per 1K input tokens, ~$0.0015 per 1K output tokens

**Anthropic Pricing (as of 2024):**
- Claude 3.5 Sonnet: ~$0.003 per 1K input tokens, ~$0.015 per 1K output tokens
- Claude 3 Haiku: ~$0.00025 per 1K input tokens, ~$0.00125 per 1K output tokens

Typical conversation (10 messages): **$0.01 - $0.10** depending on provider and model.

## Support

For API-related issues:
- OpenAI: https://platform.openai.com/docs
- Anthropic: https://docs.anthropic.com

For app issues, please file an issue on GitHub.
