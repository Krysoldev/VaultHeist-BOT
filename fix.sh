cat << 'EOF' > fix.sh
#!/bin/bash

# ============================================
# VAULT HEIST DISCORD BOT - AUTO FIX TOOL
# Created by: Krysol Dev
# ============================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
    ║                   AUTO FIX & REPAIR TOOL                          ║
    ║                                                                   ║
    ╚═══════════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"
echo ""

# Function to check and fix directories
fix_directories() {
    echo -ne "${YELLOW}[1/8] Checking directories...${NC}"
    mkdir -p src/commands/{economy,banking,security,gambling,fun,pvp,shop,trade,admin}
    mkdir -p src/events src/utils src/data
    echo -e " ${GREEN}✓${NC}"
}

# Function to fix package.json
fix_package() {
    echo -ne "${YELLOW}[2/8] Checking package.json...${NC}"
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
        echo -e " ${GREEN}created${NC}"
    else
        echo -e " ${GREEN}ok${NC}"
    fi
}

# Function to fix index.js
fix_index() {
    echo -ne "${YELLOW}[3/8] Checking index.js...${NC}"
    if [ ! -f "index.js" ] || [ $(wc -l < index.js) -lt 50 ]; then
        curl -sSL https://raw.githubusercontent.com/Krysoldev/VaultHeist-BOT/main/index.js -o index.js 2>/dev/null
        echo -e " ${GREEN}fixed${NC}"
    else
        echo -e " ${GREEN}ok${NC}"
    fi
}

# Function to fix .env
fix_env() {
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
        echo -e "   ${BLUE}→ Run ./configure.sh to set up${NC}"
    else
        echo -e " ${GREEN}configured${NC}"
    fi
}

# Function to fix utilities
fix_utils() {
    echo -ne "${YELLOW}[5/8] Checking utility files...${NC}"
    
    if [ ! -f "src/utils/economy.js" ]; then
        cat > src/utils/economy.js << 'UTILEOF'
const fs = require('fs');
const path = require('path');
const usersPath = path.join(__dirname, '../data/users.json');

function loadUsers() {
    if (!fs.existsSync(usersPath)) fs.writeFileSync(usersPath, JSON.stringify({}));
    return JSON.parse(fs.readFileSync(usersPath, 'utf8'));
}

function saveUsers(users) { fs.writeFileSync(usersPath, JSON.stringify(users, null, 2)); }

function getUser(userId) {
    const users = loadUsers();
    if (!users[userId]) {
        users[userId] = { balance: 0, bank: 0, pin: null, pinAttempts: 0, jailedUntil: 0, inventory: [], totalEarned: 0, totalSpent: 0, lastDaily: 0, lastWork: 0, lastBeg: 0, lastCrime: 0, lastHunt: 0, lastFish: 0, lastDig: 0, lastRob: 0, lastFight: 0, blacklisted: false, wins: 0, losses: 0 };
        saveUsers(users);
    }
    return users[userId];
}

function updateUser(userId, updates) {
    const users = loadUsers();
    if (!users[userId]) users[userId] = getUser(userId);
    Object.assign(users[userId], updates);
    saveUsers(users);
}

function addMoney(userId, amount) {
    const user = getUser(userId);
    updateUser(userId, { balance: user.balance + amount, totalEarned: user.totalEarned + amount });
}

function removeMoney(userId, amount) {
    const user = getUser(userId);
    if (user.balance < amount) return false;
    updateUser(userId, { balance: user.balance - amount, totalSpent: user.totalSpent + amount });
    return true;
}

function isJailed(userId) { return getUser(userId).jailedUntil > Date.now(); }
function setJail(userId, minutes) { updateUser(userId, { jailedUntil: Date.now() + (minutes * 60 * 1000) }); }

module.exports = { getUser, updateUser, addMoney, removeMoney, isJailed, setJail };
UTILEOF
    fi
    
    echo -e " ${GREEN}ok${NC}"
}

# Function to fix events
fix_events() {
    echo -ne "${YELLOW}[6/8] Checking event files...${NC}"
    
    if [ ! -f "src/events/ready.js" ]; then
        cat > src/events/ready.js << 'EVENTEOF'
module.exports = {
    name: 'ready',
    once: true,
    execute(client) {
        console.log(`✅ ${client.user.tag} is online!`);
        client.user.setActivity('/help | VaultHeist', { type: 'PLAYING' });
    }
};
EVENTEOF
    fi
    
    if [ ! -f "src/events/interactionCreate.js" ]; then
        cat > src/events/interactionCreate.js << 'EVENTEOF'
const economy = require('../utils/economy');

module.exports = {
    name: 'interactionCreate',
    async execute(interaction, client) {
        if (!interaction.isChatInputCommand()) return;
        const command = client.commands.get(interaction.commandName);
        if (!command) return;
        try {
            await command.execute(interaction);
        } catch (error) {
            console.error(error);
            await interaction.reply({ content: '❌ Error!', ephemeral: true });
        }
    }
};
EVENTEOF
    fi
    
    echo -e " ${GREEN}ok${NC}"
}

# Function to fix users.json
fix_users() {
    echo -ne "${YELLOW}[7/8] Checking users.json...${NC}"
    if [ ! -f "src/data/users.json" ]; then
        echo "{}" > src/data/users.json
        echo -e " ${GREEN}created${NC}"
    else
        echo -e " ${GREEN}ok${NC}"
    fi
}

# Function to reinstall dependencies
fix_deps() {
    echo -ne "${YELLOW}[8/8] Checking dependencies...${NC}"
    if [ ! -d "node_modules" ]; then
        npm install --silent 2>/dev/null
        echo -e " ${GREEN}installed${NC}"
    else
        echo -e " ${GREEN}ok${NC}"
    fi
}

# Run all fixes
fix_directories
fix_package
fix_index
fix_env
fix_utils
fix_events
fix_users
fix_deps

# Syntax check
echo ""
echo -ne "${YELLOW}Testing syntax...${NC}"
if node -c index.js 2>/dev/null; then
    echo -e " ${GREEN}✓ Passed${NC}"
else
    echo -e " ${RED}✗ Failed - check files manually${NC}"
fi

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ AUTO-FIX COMPLETE!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📋 Summary:${NC}"
echo "   ✓ Directories fixed"
echo "   ✓ Core files restored"
echo "   ✓ Dependencies installed"
echo "   ✓ Data files verified"
echo ""
echo -e "${YELLOW}⚠️  If .env not configured, run: ./configure.sh${NC}"
echo ""
echo -e "${GREEN}🚀 Start bot: npm start${NC}"
EOF

chmod +x fix.sh
