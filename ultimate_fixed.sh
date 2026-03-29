cat << 'EOF' > ultimate_fixed.sh
#!/bin/bash

# ============================================
# VAULT HEIST DISCORD BOT - ULTIMATE INSTALLER (FIXED)
# Created by: Krysol Dev
# Combines Install, Configure, and Fix tools
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

# Animation frames
SPINNER=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
PROGRESS=('▒▒▒▒▒▒▒▒▒▒' '▓▒▒▒▒▒▒▒▒▒' '▓▓▒▒▒▒▒▒▒▒' '▓▓▓▒▒▒▒▒▒▒' '▓▓▓▓▒▒▒▒▒▒' '▓▓▓▓▓▒▒▒▒▒' '▓▓▓▓▓▓▒▒▒▒' '▓▓▓▓▓▓▓▒▒▒' '▓▓▓▓▓▓▓▓▒▒' '▓▓▓▓▓▓▓▓▓▒' '▓▓▓▓▓▓▓▓▓▓')

# Function for spinner animation
spinner() {
    local pid=$1
    local delay=0.1
    local i=0
    while ps -p $pid > /dev/null 2>&1; do
        printf "\r${CYAN}[%s]${NC} %s" "${SPINNER[$i]}" "$2"
        i=$(( (i+1) % ${#SPINNER[@]} ))
        sleep $delay
    done
    printf "\r${GREEN}[✓]${NC} %s\n" "$2"
}

# Function for progress bar
progress_bar() {
    local duration=$1
    local message=$2
    local steps=10
    for i in $(seq 0 $steps); do
        printf "\r${YELLOW}[%-10s]${NC} %s" "${PROGRESS[$i]}" "$message"
        sleep $((duration / steps))
    done
    printf "\r${GREEN}[▓▓▓▓▓▓▓▓▓▓]${NC} %s\n" "$message"
}

# Function for typing animation
type_animation() {
    local text="$1"
    local delay=${2:-0.03}
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo
}

# Function for bouncing dots
bouncing_dots() {
    local message="$1"
    local duration=${2:-2}
    local end_time=$((SECONDS + duration))
    local dots=0
    while [ $SECONDS -lt $end_time ]; do
        printf "\r${CYAN}%s%s${NC}" "$message" "$(printf '.%.0s' $(seq 1 $dots))"
        dots=$(( (dots + 1) % 4 ))
        sleep 0.3
    done
    printf "\r${GREEN}%s ✓${NC}\n" "$message"
}

# Clear screen
clear

# Animated Banner
echo -e "${MAGENTA}"
cat << "BANNER"
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                              ║
    ║      ██╗  ██╗██████╗ ██╗   ██╗███████╗ ██████╗ ██╗                         ║
    ║      ██║ ██╔╝██╔══██╗╚██╗ ██╔╝██╔════╝██╔═══██╗██║                         ║
    ║      █████╔╝ ██████╔╝ ╚████╔╝ ███████╗██║   ██║██║                         ║
    ║      ██╔═██╗ ██╔══██╗  ╚██╔╝  ╚════██║██║   ██║██║                         ║
    ║      ██║  ██╗██║  ██║   ██║   ███████║╚██████╔╝███████╗                    ║
    ║      ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚══════╝                    ║
    ║                                                                              ║
    ║                              K R Y S O L                                     ║
    ║                                                                              ║
    ║                    ██████╗  ██████╗ ████████╗                               ║
    ║                    ██╔══██╗██╔═══██╗╚══██╔══╝                               ║
    ║                    ██████╔╝██║   ██║   ██║                                  ║
    ║                    ██╔══██╗██║   ██║   ██║                                  ║
    ║                    ██████╔╝╚██████╔╝   ██║                                  ║
    ║                    ╚═════╝  ╚═════╝    ╚═╝                                  ║
    ║                                                                              ║
    ║                    ┌─────────────────────────────────┐                       ║
    ║                    │  DISCORD ECONOMY BOT v1.0       │                       ║
    ║                    │  Created by: Krysol Dev         │                       ║
    ║                    └─────────────────────────────────┘                       ║
    ║                                                                              ║
    ╚══════════════════════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"
echo ""

# Welcome message with typing effect
type_animation "⚡ Initializing VaultHeist Ultimate Installer..." 0.05
sleep 0.5
bouncing_dots "Loading modules" 2
echo ""

# ============================================
# MAIN MENU FUNCTION
# ============================================
show_menu() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    SELECT AN OPTION                            ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[1]${NC} 🚀 ${WHITE}FULL INSTALL${NC}      - Complete bot installation                ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[2]${NC} ⚙️  ${WHITE}CONFIGURE ONLY${NC}   - Edit .env configuration                  ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[3]${NC} 🔧 ${WHITE}AUTO-FIX & REPAIR${NC} - Fix broken bot files                     ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[4]${NC} 🎮 ${WHITE}START BOT${NC}         - Run the bot                              ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[5]${NC} 📊 ${WHITE}STATUS CHECK${NC}      - Check bot health                         ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[0]${NC} ❌ ${WHITE}EXIT${NC}              - Close this menu                          ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -ne "${YELLOW}➤ Enter your choice [0-5]: ${NC}"
}

# ============================================
# FULL INSTALL FUNCTION
# ============================================
full_install() {
    clear
    echo -e "${MAGENTA}"
    cat << "BANNER"
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                    🚀 FULL INSTALLATION                          ║
    ╚═══════════════════════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    echo ""

    # Step 1: Check Node.js
    echo -e "${YELLOW}[1/7] Checking Node.js...${NC}"
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js not found! Installing...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - > /dev/null 2>&1 &
        spinner $! "Installing Node.js"
        sudo apt-get install -y nodejs > /dev/null 2>&1
    fi
    progress_bar 1 "Node.js $(node -v)"
    
    # Step 2: Check Git
    echo -e "${YELLOW}[2/7] Checking Git...${NC}"
    if ! command -v git &> /dev/null; then
        sudo apt-get install -y git > /dev/null 2>&1 &
        spinner $! "Installing Git"
    fi
    progress_bar 1 "Git installed"
    
    # Step 3: Clone/Setup files
    echo -e "${YELLOW}[3/7] Setting up bot files...${NC}"
    mkdir -p src/commands/{economy,banking,security,gambling,fun,pvp,shop,trade,admin}
    mkdir -p src/events src/utils src/data
    echo "{}" > src/data/users.json 2>/dev/null || true
    progress_bar 1 "Directories created"
    
    # Step 4: Create package.json
    echo -e "${YELLOW}[4/7] Creating package.json...${NC}"
    if [ ! -f "package.json" ]; then
        cat > package.json << 'PKGEOF'
{
  "name": "vaultheist-bot",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js"
  },
  "dependencies": {
    "discord.js": "^14.14.1",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
PKGEOF
    fi
    progress_bar 1 "package.json ready"
    
    # Step 5: Create index.js
    echo -e "${YELLOW}[5/7] Creating index.js...${NC}"
    if [ ! -f "index.js" ] || [ $(wc -l < index.js) -lt 50 ]; then
        curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/index.js -o index.js 2>/dev/null &
        spinner $! "Downloading index.js"
    fi
    progress_bar 1 "index.js ready"
    
    # Step 6: Install dependencies
    echo -e "${YELLOW}[6/7] Installing dependencies...${NC}"
    npm install --silent 2>/dev/null &
    spinner $! "npm install"
    progress_bar 1 "Dependencies installed"
    
    # Step 7: Check configuration
    echo -e "${YELLOW}[7/7] Checking configuration...${NC}"
    if [ ! -f ".env" ] || grep -q "PASTE_YOUR_TOKEN" .env 2>/dev/null; then
        echo -e "${YELLOW}⚠️  .env not configured!${NC}"
        echo -e "${BLUE}→ Run configuration wizard now? (y/n)${NC}"
        read -p "   " run_config
        if [[ $run_config == "y" || $run_config == "Y" ]]; then
            configure_only
            return
        fi
    else
        echo -e "${GREEN}✓ .env configured${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ INSTALLATION COMPLETE!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${BLUE}📝 NEXT STEPS:${NC}"
    echo "1. Configure bot: ./ultimate_fixed.sh (option 2)"
    echo "2. Start bot: ./ultimate_fixed.sh (option 4)"
    echo ""
    
    echo -ne "${YELLOW}Press Enter to return to menu...${NC}"
    read
}

# ============================================
# CONFIGURE ONLY FUNCTION
# ============================================
configure_only() {
    clear
    echo -e "${MAGENTA}"
    cat << "BANNER"
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                    ⚙️  CONFIGURATION WIZARD                       ║
    ╚═══════════════════════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    echo ""

    # Function to validate token
    validate_token() {
        [[ $1 =~ ^[A-Za-z0-9_-]{50,}$ ]]
    }
    
    validate_client_id() {
        [[ $1 =~ ^[0-9]{17,20}$ ]]
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
        echo -e "${RED}   ❌ Invalid token! Token should be 50+ characters.${NC}"
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

    # Get Guild ID
    echo -e "${YELLOW}[3/3] Guild ID (Server ID) - OPTIONAL${NC}"
    echo -e "   → Enable Developer Mode → Right-click server → Copy ID"
    echo -e "   → ${BLUE}Leave empty for global commands${NC}"
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
    
    echo -ne "${YELLOW}Press Enter to return to menu...${NC}"
    read
}

# ============================================
# AUTO-FIX FUNCTION
# ============================================
auto_fix() {
    clear
    echo -e "${MAGENTA}"
    cat << "BANNER"
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                    🔧 AUTO-FIX & REPAIR TOOL                      ║
    ╚═══════════════════════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    echo ""

    # Fix directories
    echo -ne "${YELLOW}[1/8] Checking directories...${NC}"
    mkdir -p src/commands/{economy,banking,security,gambling,fun,pvp,shop,trade,admin}
    mkdir -p src/events src/utils src/data
    echo -e " ${GREEN}✓${NC}"
    
    # Fix package.json
    echo -ne "${YELLOW}[2/8] Checking package.json...${NC}"
    if [ ! -f "package.json" ]; then
        cat > package.json << 'PKGEOF'
{
  "name": "vaultheist-bot",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {"start": "node index.js", "dev": "nodemon index.js"},
  "dependencies": {"discord.js": "^14.14.1", "dotenv": "^16.3.1"},
  "devDependencies": {"nodemon": "^3.0.1"}
}
PKGEOF
        echo -e " ${GREEN}created${NC}"
    else
        echo -e " ${GREEN}ok${NC}"
    fi
    
    # Fix index.js
    echo -ne "${YELLOW}[3/8] Checking index.js...${NC}"
    if [ ! -f "index.js" ] || [ $(wc -l < index.js) -lt 50 ]; then
        curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/index.js -o index.js 2>/dev/null
        echo -e " ${GREEN}fixed${NC}"
    else
        echo -e " ${GREEN}ok${NC}"
    fi
    
    # Fix .env
    echo -ne "${YELLOW}[4/8] Checking .env...${NC}"
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
    
    # Fix utilities
    echo -ne "${YELLOW}[5/8] Checking utility files...${NC}"
    if [ ! -f "src/utils/economy.js" ]; then
        mkdir -p src/utils
        cat > src/utils/economy.js << 'UTILEOF'
const fs = require('fs'); const path = require('path');
const usersPath = path.join(__dirname, '../data/users.json');
function loadUsers() { if (!fs.existsSync(usersPath)) fs.writeFileSync(usersPath, '{}'); return JSON.parse(fs.readFileSync(usersPath, 'utf8')); }
function saveUsers(u) { fs.writeFileSync(usersPath, JSON.stringify(u, null, 2)); }
function getUser(id) { const u = loadUsers(); if (!u[id]) { u[id] = { balance: 0, bank: 0, pin: null, jailedUntil: 0, inventory: [] }; saveUsers(u); } return u[id]; }
function updateUser(id, updates) { const u = loadUsers(); if (!u[id]) u[id] = getUser(id); Object.assign(u[id], updates); saveUsers(u); }
function addMoney(id, a) { const u = getUser(id); updateUser(id, { balance: u.balance + a }); }
function removeMoney(id, a) { const u = getUser(id); if (u.balance < a) return false; updateUser(id, { balance: u.balance - a }); return true; }
function isJailed(id) { return getUser(id).jailedUntil > Date.now(); }
function setJail(id, m) { updateUser(id, { jailedUntil: Date.now() + (m * 60 * 1000) }); }
module.exports = { getUser, updateUser, addMoney, removeMoney, isJailed, setJail };
UTILEOF
        echo -e " ${GREEN}created${NC}"
    else
        echo -e " ${GREEN}ok${NC}"
    fi
    
    # Fix events
    echo -ne "${YELLOW}[6/8] Checking event files...${NC}"
    mkdir -p src/events
    if [ ! -f "src/events/ready.js" ]; then
        cat > src/events/ready.js << 'EVENTEOF'
module.exports = { name: 'ready', once: true, execute(c) { console.log(`✅ ${c.user.tag} is online!`); c.user.setActivity('/help | VaultHeist', { type: 'PLAYING' }); } };
EVENTEOF
    fi
    if [ ! -f "src/events/interactionCreate.js" ]; then
        cat > src/events/interactionCreate.js << 'INTEOF'
const economy = require('../utils/economy');
module.exports = { name: 'interactionCreate', async execute(i, c) { if (!i.isChatInputCommand()) return; const cmd = c.commands.get(i.commandName); if (!cmd) return; try { await cmd.execute(i); } catch(e) { console.error(e); await i.reply({ content: '❌ Error!', ephemeral: true }); } } };
INTEOF
    fi
    echo -e " ${GREEN}ok${NC}"
    
    # Fix users.json
    echo -ne "${YELLOW}[7/8] Checking users.json...${NC}"
    if [ ! -f "src/data/users.json" ]; then
        echo "{}" > src/data/users.json
        echo -e " ${GREEN}created${NC}"
    else
        echo -e " ${GREEN}ok${NC}"
    fi
    
    # Fix dependencies
    echo -ne "${YELLOW}[8/8] Checking dependencies...${NC}"
    if [ ! -d "node_modules" ]; then
        npm install --silent 2>/dev/null
        echo -e " ${GREEN}installed${NC}"
    else
        echo -e " ${GREEN}ok${NC}"
    fi
    
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
    clear
    echo -e "${MAGENTA}"
    cat << "BANNER"
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                    🎮 STARTING VAULT HEIST BOT                    ║
    ╚═══════════════════════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    echo ""
    
    if [ ! -f ".env" ]; then
        echo -e "${RED}❌ .env file not found! Please configure first.${NC}"
        echo -e "${YELLOW}→ Run option 2 to configure.${NC}"
        echo ""
        echo -ne "${YELLOW}Press Enter to return...${NC}"
        read
        return
    fi
    
    if grep -q "PASTE_YOUR_TOKEN" .env; then
        echo -e "${RED}❌ Token not configured! Please run configuration.${NC}"
        echo -e "${YELLOW}→ Run option 2 to configure.${NC}"
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
    echo ""
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
    clear
    echo -e "${MAGENTA}"
    cat << "BANNER"
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                    📊 BOT STATUS CHECK                           ║
    ╚═══════════════════════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    echo ""
    
    # Check .env
    echo -ne "${YELLOW}Checking .env...${NC}"
    if [ -f ".env" ]; then
        if grep -q "PASTE_YOUR_TOKEN" .env; then
            echo -e " ${RED}✗ Not configured${NC}"
        else
            echo -e " ${GREEN}✓ Configured${NC}"
            source .env 2>/dev/null
            echo -e "   ${BLUE}Token:${NC} ${TOKEN:0:15}...${TOKEN: -10}"
            echo -e "   ${BLUE}Client ID:${NC} $CLIENT_ID"
            [ -n "$GUILD_ID" ] && echo -e "   ${BLUE}Server ID:${NC} $GUILD_ID"
        fi
    else
        echo -e " ${RED}✗ Missing${NC}"
    fi
    
    # Check dependencies
    echo -ne "${YELLOW}Checking dependencies...${NC}"
    if [ -d "node_modules" ]; then
        echo -e " ${GREEN}✓ Installed${NC}"
        echo -e "   ${BLUE}Packages:${NC} $(ls node_modules 2>/dev/null | wc -l)"
    else
        echo -e " ${RED}✗ Not installed${NC}"
    fi
    
    # Check directories
    echo -ne "${YELLOW}Checking directories...${NC}"
    if [ -d "src/commands" ] && [ -d "src/events" ] && [ -d "src/utils" ]; then
        echo -e " ${GREEN}✓ All present${NC}"
        cmd_count=$(find src/commands -name "*.js" 2>/dev/null | wc -l)
        echo -e "   ${BLUE}Commands:${NC} $cmd_count"
    else
        echo -e " ${RED}✗ Missing directories${NC}"
    fi
    
    # Check users.json
    echo -ne "${YELLOW}Checking users.json...${NC}"
    if [ -f "src/data/users.json" ]; then
        users=$(grep -o '"balance"' src/data/users.json 2>/dev/null | wc -l)
        echo -e " ${GREEN}✓ Present${NC}"
        echo -e "   ${BLUE}Users:${NC} $users"
    else
        echo -e " ${RED}✗ Missing${NC}"
    fi
    
    # Check PM2 status
    echo -ne "${YELLOW}Checking PM2...${NC}"
    if command -v pm2 &> /dev/null; then
        if pm2 list 2>/dev/null | grep -q "VaultHeist"; then
            echo -e " ${GREEN}✓ Running${NC}"
            pm2 show VaultHeist 2>/dev/null | grep -E "status|restarts|uptime" | sed 's/^/   /'
        else
            echo -e " ${YELLOW}Not running${NC}"
        fi
    else
        echo -e " ${YELLOW}Not installed${NC}"
        echo -e "   ${BLUE}→ Install with: npm install -g pm2${NC}"
    fi
    
    echo ""
    echo -ne "${YELLOW}Press Enter to return to menu...${NC}"
    read
}

# ============================================
# MAIN LOOP - FIXED
# ============================================
while true; do
    show_menu
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
            echo -e "${RED}Invalid option! Please enter 0-5.${NC}"
            sleep 1
            ;;
    esac
    
    # Clear screen before showing menu again
    clear
    # Show banner again
    echo -e "${MAGENTA}"
    cat << "BANNER"
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                              ║
    ║      ██╗  ██╗██████╗ ██╗   ██╗███████╗ ██████╗ ██╗                         ║
    ║      ██║ ██╔╝██╔══██╗╚██╗ ██╔╝██╔════╝██╔═══██╗██║                         ║
    ║      █████╔╝ ██████╔╝ ╚████╔╝ ███████╗██║   ██║██║                         ║
    ║      ██╔═██╗ ██╔══██╗  ╚██╔╝  ╚════██║██║   ██║██║                         ║
    ║      ██║  ██╗██║  ██║   ██║   ███████║╚██████╔╝███████╗                    ║
    ║      ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚══════╝                    ║
    ║                                                                              ║
    ║                              K R Y S O L                                     ║
    ║                                                                              ║
    ║                    ██████╗  ██████╗ ████████╗                               ║
    ║                    ██╔══██╗██╔═══██╗╚══██╔══╝                               ║
    ║                    ██████╔╝██║   ██║   ██║                                  ║
    ║                    ██╔══██╗██║   ██║   ██║                                  ║
    ║                    ██████╔╝╚██████╔╝   ██║                                  ║
    ║                    ╚═════╝  ╚═════╝    ╚═╝                                  ║
    ║                                                                              ║
    ║                    ┌─────────────────────────────────┐                       ║
    ║                    │  DISCORD ECONOMY BOT v1.0       │                       ║
    ║                    │  Created by: Krysol Dev         │                       ║
    ║                    └─────────────────────────────────┘                       ║
    ║                                                                              ║
    ╚══════════════════════════════════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    echo ""
done
EOF

chmod +x ultimate_fixed.sh
./ultimate_fixed.sh
