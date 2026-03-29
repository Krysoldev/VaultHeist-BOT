cat << 'EOF' > install.sh
#!/bin/bash

# ============================================
# VAULT HEIST DISCORD BOT - INSTALLER
# Created by: Krysol Dev
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
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
    ║                    DISCORD ECONOMY BOT v1.0                       ║
    ║                                                                   ║
    ╚═══════════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"
echo ""

# Check Node.js
echo -e "${YELLOW}[1/5] Checking Node.js installation...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js not found! Installing...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi
echo -e "${GREEN}✓ Node.js $(node -v) installed${NC}"

# Check Git
echo -e "${YELLOW}[2/5] Checking Git...${NC}"
if ! command -v git &> /dev/null; then
    sudo apt-get install -y git
fi
echo -e "${GREEN}✓ Git installed${NC}"

# Clone repository if not already in it
echo -e "${YELLOW}[3/5] Setting up bot files...${NC}"
if [ ! -f "package.json" ]; then
    if [ -d ".git" ]; then
        echo -e "${GREEN}✓ Already in git repository${NC}"
    else
        echo -e "${YELLOW}Cloning repository...${NC}"
        git clone https://github.com/Krysoldev/VaultHeist-BOT.git temp_repo 2>/dev/null || true
        cp -r temp_repo/* . 2>/dev/null || true
        cp -r temp_repo/.* . 2>/dev/null || true
        rm -rf temp_repo 2>/dev/null || true
    fi
fi

# Create directories if missing
mkdir -p src/commands/{economy,banking,security,gambling,fun,pvp,shop,trade,admin}
mkdir -p src/events src/utils src/data

# Create users.json if missing
if [ ! -f "src/data/users.json" ]; then
    echo "{}" > src/data/users.json
fi

echo -e "${GREEN}✓ Bot files ready${NC}"

# Install dependencies
echo -e "${YELLOW}[4/5] Installing dependencies...${NC}"
npm install --silent
echo -e "${GREEN}✓ Dependencies installed${NC}"

# Check .env file
echo -e "${YELLOW}[5/5] Checking configuration...${NC}"
if [ ! -f ".env" ] || grep -q "PASTE_YOUR_TOKEN" .env; then
    echo -e "${YELLOW}⚠️  .env not configured!${NC}"
    echo -e "${BLUE}Run configuration wizard:${NC}"
    echo -e "   ./configure.sh"
else
    echo -e "${GREEN}✓ .env configured${NC}"
fi

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ INSTALLATION COMPLETE!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📝 NEXT STEPS:${NC}"
echo "1. Configure bot: ./configure.sh"
echo "2. Start bot: npm start"
echo "3. For PM2: npm install -g pm2 && pm2 start index.js --name VaultHeist"
echo ""
EOF

chmod +x install.sh
