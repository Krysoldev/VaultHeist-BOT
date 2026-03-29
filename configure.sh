#!/bin/bash

echo "⚙️ Configure Bot"

read -p "Enter BOT TOKEN: " TOKEN
read -p "Enter CLIENT ID: " CLIENT_ID
read -p "Enter GUILD ID (optional): " GUILD_ID

cat > .env <<EOF
TOKEN=$TOKEN
CLIENT_ID=$CLIENT_ID
GUILD_ID=$GUILD_ID
EOF

echo "✅ Saved .env"
