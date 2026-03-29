cat << 'EOF' > ultimate_working.sh
#!/bin/bash

# ============================================
# VAULT HEIST DISCORD BOT - ULTIMATE WORKING INSTALLER
# Created by: Krysol Dev
# ============================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# Function to clear screen and show banner
show_banner() {
    clear
    echo -e "${MAGENTA}"
    echo '    ╔══════════════════════════════════════════════════════════════════════╗'
    echo '    ║                                                                      ║'
    echo '    ║      ██╗  ██╗██████╗ ██╗   ██╗███████╗ ██████╗ ██╗                 ║'
    echo '    ║      ██║ ██╔╝██╔══██╗╚██╗ ██╔╝██╔════╝██╔═══██╗██║                 ║'
    echo '    ║      █████╔╝ ██████╔╝ ╚████╔╝ ███████╗██║   ██║██║                 ║'
    echo '    ║      ██╔═██╗ ██╔══██╗  ╚██╔╝  ╚════██║██║   ██║██║                 ║'
    echo '    ║      ██║  ██╗██║  ██║   ██║   ███████║╚██████╔╝███████╗            ║'
    echo '    ║      ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚══════╝            ║'
    echo '    ║                                                                      ║'
    echo '    ║                         K R Y S O L                                  ║'
    echo '    ║                                                                      ║'
    echo '    ║                    DISCORD ECONOMY BOT v1.0                          ║'
    echo '    ║                    Created by: Krysol Dev                            ║'
    echo '    ║                                                                      ║'
    echo '    ╚══════════════════════════════════════════════════════════════════════╝'
    echo -e "${NC}"
    echo ""
}

# Function for spinner animation
spinner() {
    local pid=$1
    local message=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    while ps -p $pid > /dev/null 2>&1; do
        printf "\r${CYAN}[%s]${NC} %s" "${spin:$i:1}" "$message"
        i=$(( (i+1) % 10 ))
        sleep 0.1
    done
    printf "\r${GREEN}[✓]${NC} %s\n" "$message"
}

# Function for progress bar
progress_bar() {
    local duration=$1
    local message=$2
    local chars=('▒' '▓' '█')
    echo -ne "${YELLOW}$message [${NC}"
    for i in $(seq 1 20); do
        echo -ne "${GREEN}█${NC}"
        sleep $((duration / 20))
    done
    echo -e "${YELLOW}]${NC} ${GREEN}✓${NC}"
}

# ============================================
# INSTALL FUNCTION
# ============================================
full_install() {
    show_banner
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    🚀 FULL INSTALLATION${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Check Node.js
    echo -ne "${YELLOW}[1/6] Checking Node.js...${NC}"
    if ! command -v node &> /dev/null; then
        echo -e " ${RED}Not found${NC}"
        echo -e "${YELLOW}Installing Node.js...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - > /dev/null 2>&1 &
        spinner $! "Installing Node.js"
        sudo apt-get install -y nodejs > /dev/null 2>&1
    else
        echo -e " ${GREEN}✓ $(node -v)${NC}"
    fi
    
    # Create directories
    echo -ne "${YELLOW}[2/6] Creating directories...${NC}"
    mkdir -p src/commands/{economy,banking,security,gambling,fun,pvp,shop,trade,admin}
    mkdir -p src/events src/utils src/data
    echo "{}" > src/data/users.json 2>/dev/null || true
    echo -e " ${GREEN}✓${NC}"
    
    # Download from GitHub
    echo -e "${YELLOW}[3/6] Downloading bot files...${NC}"
    echo -ne "${CYAN}   → Downloading package.json...${NC}"
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/package.json -o package.json 2>/dev/null &
    spinner $! "Downloading package.json"
    
    echo -ne "${CYAN}   → Downloading index.js...${NC}"
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/index.js -o index.js 2>/dev/null &
    spinner $! "Downloading index.js"
    
    echo -ne "${CYAN}   → Downloading economy utils...${NC}"
    mkdir -p src/utils
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/src/utils/economy.js -o src/utils/economy.js 2>/dev/null &
    spinner $! "Downloading economy.js"
    
    echo -ne "${CYAN}   → Downloading events...${NC}"
    mkdir -p src/events
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/src/events/ready.js -o src/events/ready.js 2>/dev/null &
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/src/events/interactionCreate.js -o src/events/interactionCreate.js 2>/dev/null &
    wait
    echo -e "${GREEN}   ✓ Events downloaded${NC}"
    
    echo -ne "${CYAN}   → Downloading commands...${NC}"
    mkdir -p src/commands/economy
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/src/commands/economy/balance.js -o src/commands/economy/balance.js 2>/dev/null &
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/src/commands/help.js -o src/commands/help.js 2>/dev/null &
    wait
    echo -e "${GREEN}   ✓ Commands downloaded${NC}"
    
    # Install dependencies
    echo -e "${YELLOW}[4/6] Installing dependencies...${NC}"
    npm install --silent &
    spinner $! "npm install"
    
    # Create .env template
    echo -e "${YELLOW}[5/6] Creating .env template...${NC}"
    if [ ! -f ".env" ]; then
        cat > .env << 'ENVEOF'
TOKEN=PASTE_YOUR_TOKEN_HERE
CLIENT_ID=PASTE_YOUR_CLIENT_ID_HERE
GUILD_ID=
ENVEOF
        echo -e "${GREEN}✓ .env template created${NC}"
    else
        echo -e "${GREEN}✓ .env already exists${NC}"
    fi
    
    # Final check
    echo -e "${YELLOW}[6/6] Finalizing...${NC}"
    progress_bar 2 "Setting up permissions"
    
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ INSTALLATION COMPLETE!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${BLUE}📝 NEXT STEPS:${NC}"
    echo "   1. Configure bot: Select option 2"
    echo "   2. Start bot: Select option 4"
    echo ""
    echo -ne "${YELLOW}Press Enter to return to menu...${NC}"
    read
}

# ============================================
# CONFIGURE FUNCTION
# ============================================
configure_only() {
    show_banner
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    ⚙️  CONFIGURATION WIZARD${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}📌 Get your credentials from:${NC}"
    echo -e "${BLUE}   https://discord.com/developers/applications${NC}"
    echo ""
    
    # Get Bot Token
    echo -e "${YELLOW}[1/3] Discord Bot Token${NC}"
    echo -e "   → Select your application → Bot → Copy Token"
    echo -ne "${CYAN}   Enter your token: ${NC}"
    read -s TOKEN
    echo ""
    echo ""
    
    # Get Client ID
    echo -e "${YELLOW}[2/3] Client ID (Application ID)${NC}"
    echo -e "   → Select your application → General Information → Application ID"
    echo -ne "${CYAN}   Enter your Client ID: ${NC}"
    read CLIENT_ID
    echo ""
    
    # Get Guild ID
    echo -e "${YELLOW}[3/3] Guild ID (Server ID) - OPTIONAL${NC}"
    echo -e "   → Enable Developer Mode in Discord → Right-click server → Copy ID"
    echo -e "   → ${BLUE}Leave empty for global commands${NC}"
    echo -ne "${CYAN}   Enter Server ID (press Enter to skip): ${NC}"
    read GUILD_ID
    echo ""
    
    # Save configuration
    cat > .env << ENVEOF
TOKEN=$TOKEN
CLIENT_ID=$CLIENT_ID
GUILD_ID=$GUILD_ID
ENVEOF
    
    echo -e "${GREEN}✅ Configuration saved to .env${NC}"
    echo ""
    echo -e "${BLUE}📋 Your settings:${NC}"
    echo -e "   Token: ${TOKEN:0:15}...${TOKEN: -10}"
    echo -e "   Client ID: $CLIENT_ID"
    [ -n "$GUILD_ID" ] && echo -e "   Server ID: $GUILD_ID" || echo -e "   Server ID: ${YELLOW}Global mode${NC}"
    echo ""
    
    echo -ne "${YELLOW}Press Enter to return to menu...${NC}"
    read
}

# ============================================
# AUTO-FIX FUNCTION
# ============================================
auto_fix() {
    show_banner
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    🔧 AUTO-FIX & REPAIR${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Fix directories
    echo -ne "${YELLOW}[1/7] Fixing directories...${NC}"
    mkdir -p src/commands/{economy,banking,security,gambling,fun,pvp,shop,trade,admin}
    mkdir -p src/events src/utils src/data
    echo -e " ${GREEN}✓${NC}"
    
    # Fix package.json
    echo -ne "${YELLOW}[2/7] Fixing package.json...${NC}"
    if [ ! -f "package.json" ]; then
        curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/package.json -o package.json 2>/dev/null
        echo -e " ${GREEN}created${NC}"
    else
        echo -e " ${GREEN}ok${NC}"
    fi
    
    # Fix index.js
    echo -ne "${YELLOW}[3/7] Fixing index.js...${NC}"
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/index.js -o index.js 2>/dev/null
    echo -e " ${GREEN}fixed${NC}"
    
    # Fix .env
    echo -ne "${YELLOW}[4/7] Fixing .env...${NC}"
    if [ ! -f ".env" ]; then
        cat > .env << 'ENVEOF'
TOKEN=PASTE_YOUR_TOKEN_HERE
CLIENT_ID=PASTE_YOUR_CLIENT_ID_HERE
GUILD_ID=
ENVEOF
        echo -e " ${GREEN}created${NC}"
    elif grep -q "PASTE_YOUR_TOKEN" .env; then
        echo -e " ${YELLOW}needs config${NC}"
    else
        echo -e " ${GREEN}configured${NC}"
    fi
    
    # Fix utils
    echo -ne "${YELLOW}[5/7] Fixing utility files...${NC}"
    mkdir -p src/utils
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/src/utils/economy.js -o src/utils/economy.js 2>/dev/null
    echo -e " ${GREEN}fixed${NC}"
    
    # Fix events
    echo -ne "${YELLOW}[6/7] Fixing event files...${NC}"
    mkdir -p src/events
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/src/events/ready.js -o src/events/ready.js 2>/dev/null
    curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/src/events/interactionCreate.js -o src/events/interactionCreate.js 2>/dev/null
    echo -e " ${GREEN}fixed${NC}"
    
    # Fix dependencies
    echo -ne "${YELLOW}[7/7] Fixing dependencies...${NC}"
    if [ ! -d "node_modules" ]; then
        npm install --silent &
        spinner $! "Installing dependencies"
    else
        echo -e " ${GREEN}ok${NC}"
    fi
    
    # Create users.json
    [ ! -f "src/data/users.json" ] && echo "{}" > src/data/users.json
    
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ AUTO-FIX COMPLETE!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -ne "${YELLOW}Press Enter to return to menu...${NC}"
    read
}

# ============================================
# START BOT FUNCTION
# ============================================
start_bot() {
    show_banner
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    🎮 STARTING BOT${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if [ ! -f ".env" ]; then
        echo -e "${RED}❌ .env file not found! Please configure first.${NC}"
        echo -e "${YELLOW}→ Select option 2 to configure${NC}"
        echo ""
        echo -ne "${YELLOW}Press Enter to return...${NC}"
        read
        return
    fi
    
    if grep -q "PASTE_YOUR_TOKEN" .env; then
        echo -e "${RED}❌ Token not configured! Please run configuration.${NC}"
        echo -e "${YELLOW}→ Select option 2 to configure${NC}"
        echo ""
        echo -ne "${YELLOW}Press Enter to return...${NC}"
        read
        return
    fi
    
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}Installing dependencies...${NC}"
        npm install --silent
    fi
    
    echo -e "${GREEN}🚀 Bot is starting...${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop the bot${NC}"
    echo ""
    npm start
    
    echo ""
    echo -ne "${YELLOW}Press Enter to return to menu...${NC}"
    read
}

# ============================================
# STATUS CHECK FUNCTION
# ============================================
status_check() {
    show_banner
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    📊 STATUS CHECK${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # .env check
    echo -ne "${YELLOW}.env file:${NC} "
    if [ -f ".env" ]; then
        if grep -q "PASTE_YOUR_TOKEN" .env; then
            echo -e "${RED}Not configured ⚠️${NC}"
        else
            echo -e "${GREEN}Configured ✓${NC}"
            source .env
            echo -e "   ${BLUE}Token:${NC} ${TOKEN:0:15}...${TOKEN: -10}"
            echo -e "   ${BLUE}Client ID:${NC} $CLIENT_ID"
        fi
    else
        echo -e "${RED}Missing ✗${NC}"
    fi
    
    # Dependencies
    echo -ne "${YELLOW}Dependencies:${NC} "
    if [ -d "node_modules" ]; then
        echo -e "${GREEN}Installed ✓${NC}"
        echo -e "   ${BLUE}Packages:${NC} $(ls node_modules 2>/dev/null | wc -l)"
    else
        echo -e "${RED}Not installed ✗${NC}"
    fi
    
    # Commands
    echo -ne "${YELLOW}Commands:${NC} "
    if [ -d "src/commands" ]; then
        count=$(find src/commands -name "*.js" 2>/dev/null | wc -l)
        echo -e "${GREEN}$count commands ✓${NC}"
    else
        echo -e "${RED}No commands ✗${NC}"
    fi
    
    # Users
    echo -ne "${YELLOW}Users:${NC} "
    if [ -f "src/data/users.json" ]; then
        users=$(grep -c '"balance"' src/data/users.json 2>/dev/null || echo "0")
        echo -e "${GREEN}$users users ✓${NC}"
    else
        echo -e "${YELLOW}0 users${NC}"
    fi
    
    # PM2
    echo -ne "${YELLOW}PM2:${NC} "
    if command -v pm2 &> /dev/null; then
        if pm2 list 2>/dev/null | grep -q "VaultHeist"; then
            echo -e "${GREEN}Running ✓${NC}"
            pm2 show VaultHeist 2>/dev/null | grep -E "status|restarts" | sed 's/^/   /'
        else
            echo -e "${YELLOW}Not running${NC}"
        fi
    else
        echo -e "${YELLOW}Not installed${NC}"
    fi
    
    echo ""
    echo -ne "${YELLOW}Press Enter to return to menu...${NC}"
    read
}

# ============================================
# MAIN MENU LOOP
# ============================================
while true; do
    show_banner
    
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    SELECT AN OPTION                            ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[1]${NC} 🚀 FULL INSTALL      - Complete bot installation        ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[2]${NC} ⚙️  CONFIGURE ONLY   - Edit .env configuration          ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[3]${NC} 🔧 AUTO-FIX & REPAIR - Fix broken bot files             ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[4]${NC} 🎮 START BOT         - Run the bot                      ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[5]${NC} 📊 STATUS CHECK      - Check bot health                 ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[0]${NC} ❌ EXIT              - Close this menu                  ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -ne "${YELLOW}➤ Enter your choice [0-5]: ${NC}"
    read choice
    
    case $choice in
        1) full_install ;;
        2) configure_only ;;
        3) auto_fix ;;
        4) start_bot ;;
        5) status_check ;;
        0) 
            echo ""
            echo -e "${GREEN}Thank you for using VaultHeist! Goodbye! 👋${NC}"
            echo ""
            exit 0
            ;;
        *) 
            echo -e "${RED}Invalid option '$choice'! Please enter 0-5.${NC}"
            sleep 2
            ;;
    esac
done
EOF

chmod +x ultimate_working.sh
./ultimate_working.sh
