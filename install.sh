#!/bin/bash

set -e  # Exit on any error
set -u  # Treat unset variables as errors

SERVICE_NAME="com.jmhooper.download_cleanup"
INSTALL_DIR="$HOME/.download_cleanup"
PLIST_PATH="$HOME/Library/LaunchAgents/$SERVICE_NAME.plist"
SCRIPT_URL="https://raw.githubusercontent.com/jmhooper/download_cleanup/refs/heads/main/cleanup.rb"

echo "Installing download_cleanup service..."

# Step 1: Create the installation directory
mkdir -p "$INSTALL_DIR"

# Step 2: Download the script
echo "Downloading cleanup.rb..."
curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/cleanup.rb"
chmod +x "$INSTALL_DIR/cleanup.rb"

# Step 3: Create the plist file
echo "Creating plist file..."
cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$SERVICE_NAME</string>
    <key>ProgramArguments</key>
    <array>
        <string>$INSTALL_DIR/cleanup.rb</string>
    </array>
    <key>StartCalendarInterval</key>
    <array>
        <dict>
            <key>Hour</key>
            <integer>0</integer>
            <key>Minute</key>
            <integer>0</integer>
        </dict>
    </array>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

# Step 4: Load the service
echo "Loading the service..."
launchctl unload "$PLIST_PATH" 2>/dev/null || true  # Unload if already loaded
launchctl load "$PLIST_PATH"

echo "Installation complete. The service will run daily at midnight."
