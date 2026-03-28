cat << 'EOF' > wizard.sh
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

clear
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}         VAULT HEIST DISCORD BOT - CONFIGURATION WIZARD${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}Step 1: Discord Bot Token${NC}"
echo -e "Get it from: ${BLUE}https://discord.com/developers/applications${NC}"
echo -e "→ Select your app → Bot → Copy Token"
echo ""
read -sp "Paste your token here: " TOKEN
echo ""
echo ""

echo -e "${YELLOW}Step 2: Client ID (Application ID)${NC}"
echo -e "Get it from: ${BLUE}https://discord.com/developers/applications${NC}"
echo -e "→ Select your app → General Information → Application ID"
echo ""
read -p "Paste your Client ID: " CLIENT_ID
echo ""

echo -e "${YELLOW}Step 3: Guild ID (Server ID) - OPTIONAL${NC}"
echo -e "Enable Developer Mode in Discord → Right-click server → Copy ID"
echo -e "Leave empty for ${GREEN}global commands${NC} (takes 1 hour to register)"
echo ""
read -p "Server ID (press Enter to skip): " GUILD_ID
echo ""

# Save configuration
cat > .env << ENVEOF
# Discord Bot Configuration
TOKEN=$TOKEN
CLIENT_ID=$CLIENT_ID
GUILD_ID=$GUILD_ID

# Bot Settings
BOT_PREFIX=/
ENVEOF

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ CONFIGURATION COMPLETE!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📋 Your settings:${NC}"
echo -e "   Token: ${TOKEN:0:20}...${TOKEN: -10}"
echo -e "   Client ID: $CLIENT_ID"
[ -n "$GUILD_ID" ] && echo -e "   Server ID: $GUILD_ID" || echo -e "   Server ID: ${YELLOW}Global mode (commands appear globally)${NC}"
echo ""
echo -e "${GREEN}🚀 Starting bot...${NC}"
echo ""
npm start
EOF

chmod +x wizard.sh
./wizard.shw
