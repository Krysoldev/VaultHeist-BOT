cat << 'EOF' > configure.sh
#!/bin/bash

# ============================================
# VAULT HEIST DISCORD BOT - CONFIGURATION WIZARD
# Created by: Krysol Dev
# ============================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

clear
echo -e "${MAGENTA}"
cat << "BANNER"
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                                                                   ║
    ║      ██╗  ██╗██████╗ ██╗   ██╗███████╗ ██████╗ ██╗              ║
    ║      ██║ ██╔╝██╔══██╗╚██╗ ██╔╝██╔════╝██╔═══██╗██║              ║
    ║      █████╔╝ ██████╔╝ ╚████╔╝ ███████╗██║   ██║██║              ║
    ║      ██╔═██╗ ██╔══██╗  ╚██╔╝  ╚════██║██║   ██║██║              ║
    ║      ██║  ██╗██║  ██║   ██║   ███████║╚██████╔╝███████╗         ║
    ║      ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚══════╝         ║
    ║                                                                   ║
    ║                         K R Y S O L                               ║
    ║                                                                   ║
    ║              DISCORD BOT CONFIGURATION WIZARD                     ║
    ║                                                                   ║
    ╚═══════════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"
echo ""

# Function to validate token format
validate_token() {
    if [[ $1 =~ ^[A-Za-z0-9_-]{50,}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to validate client ID
validate_client_id() {
    if [[ $1 =~ ^[0-9]{17,20}$ ]]; then
        return 0
    else
        return 1
    fi
}

echo -e "${YELLOW}📌 Get your credentials from:${NC}"
echo -e "${BLUE}   https://discord.com/developers/applications${NC}"
echo ""

# Get Bot Token
echo -e "${YELLOW}[1/3] Discord Bot Token${NC}"
echo -e "   → Select your application → Bot → Copy Token"
echo -ne "${CYAN}   Enter your token: ${NC}"
read -s TOKEN
echo ""

while ! validate_token "$TOKEN"; do
    echo -e "${RED}   ❌ Invalid token format! Token should be 50+ characters.${NC}"
    echo -ne "${CYAN}   Enter your token: ${NC}"
    read -s TOKEN
    echo ""
done
echo -e "${GREEN}   ✓ Token accepted${NC}"
echo ""

# Get Client ID
echo -e "${YELLOW}[2/3] Client ID (Application ID)${NC}"
echo -e "   → Select your application → General Information → Application ID"
echo -ne "${CYAN}   Enter your Client ID: ${NC}"
read CLIENT_ID

while ! validate_client_id "$CLIENT_ID"; do
    echo -e "${RED}   ❌ Invalid Client ID! Should be 17-20 digits.${NC}"
    echo -ne "${CYAN}   Enter your Client ID: ${NC}"
    read CLIENT_ID
done
echo -e "${GREEN}   ✓ Client ID accepted${NC}"
echo ""

# Get Guild ID (Optional)
echo -e "${YELLOW}[3/3] Guild ID (Server ID) - OPTIONAL${NC}"
echo -e "   → Enable Developer Mode in Discord → Right-click server → Copy ID"
echo -e "   → ${BLUE}Leave empty for global commands (takes 1 hour to register)${NC}"
echo -ne "${CYAN}   Enter Server ID (press Enter to skip): ${NC}"
read GUILD_ID

if [ -n "$GUILD_ID" ]; then
    echo -e "${GREEN}   ✓ Server ID saved${NC}"
else
    echo -e "${YELLOW}   → Using global commands mode${NC}"
fi
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

# Create backup
cp .env .env.backup 2>/dev/null

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ CONFIGURATION COMPLETE!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📋 Your settings:${NC}"
echo -e "   Token: ${TOKEN:0:15}...${TOKEN: -10}"
echo -e "   Client ID: $CLIENT_ID"
[ -n "$GUILD_ID" ] && echo -e "   Server ID: $GUILD_ID" || echo -e "   Server ID: ${YELLOW}Global mode${NC}"
echo ""
echo -e "${GREEN}🚀 Starting bot...${NC}"
echo ""

# Ask to start bot
read -p "Start bot now? (y/n): " start_now
if [[ $start_now == "y" || $start_now == "Y" ]]; then
    npm start
else
    echo -e "${YELLOW}To start later: npm start${NC}"
fi
EOF

chmod +x configure.sh
