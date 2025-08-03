#!/bin/bash
set -e

APPDIR="$HOME/.local/bin"
ICONDIR="$HOME/.local/share/icons/hicolor/512x512/apps"
DESKTOPDIR="$HOME/.local/share/applications"
NAME="chat-gpt_1.1.0_amd64.AppImage"
URL="https://github.com/lencx/ChatGPT/releases/download/v1.1.0/ChatGPT_1.1.0_linux_x86_64.AppImage.tar.gz"

echo "📥 Downloading ChatGPT..."
mkdir -p "$APPDIR" "$ICONDIR" "$DESKTOPDIR"
cd "$(mktemp -d)"
wget -O chatgpt.tar.gz "$URL"
tar -xf chatgpt.tar.gz
chmod +x "$NAME"
mv "$NAME" "$APPDIR/"

echo "🎨 Extracting icon..."
cd "$APPDIR"
./"$NAME" --appimage-extract >/dev/null
ICON_PATH=$(find squashfs-root -type f -name '*.png' | grep -i 'icon\|chatgpt' | head -n1)
if [[ -f "$ICON_PATH" ]]; then
    cp "$ICON_PATH" "$ICONDIR/chatgpt.png"
    echo "✅ Icon installed to $ICONDIR/chatgpt.png"
else
    echo "⚠️ Warning: Could not find icon inside AppImage"
fi
rm -rf squashfs-root

echo "🖼️ Creating .desktop file..."
cat > "$DESKTOPDIR/chatgpt.desktop" <<EOF
[Desktop Entry]
Name=ChatGPT
Comment=ChatGPT Desktop Client
Exec=$APPDIR/$NAME
Icon=chatgpt
Terminal=false
Type=Application
Categories=Utility;Chat;
EOF

update-desktop-database "$DESKTOPDIR" || true
gtk-update-icon-cache "$HOME/.local/share/icons/hicolor/" || true

echo "✅ ChatGPT installed and integrated."
echo "➡️ Run it from your app launcher or with:"
echo "   $APPDIR/$NAME"
