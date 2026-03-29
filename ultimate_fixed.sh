cat << 'EOF' > ultimate_fixed.sh
#!/bin/bash

# ============================================
# VAULT HEIST DISCORD BOT - ULTIMATE INSTALLER
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

clear

# Banner
echo -e "${MAGENTA}"
cat << "BANNER"
    ╔══════════════════════════════════════════════════════════════════════╗
    ║                                                                      ║
    ║      ██╗  ██╗██████╗ ██╗   ██╗███████╗ ██████╗ ██╗                 ║
    ║      ██║ ██╔╝██╔══██╗╚██╗ ██╔╝██╔════╝██╔═══██╗██║                 ║
    ║      █████╔╝ ██████╔╝ ╚████╔╝ ███████╗██║   ██║██║                 ║
    ║      ██╔═██╗ ██╔══██╗  ╚██╔╝  ╚════██║██║   ██║██║                 ║
    ║      ██║  ██╗██║  ██║   ██║   ███████║╚██████╔╝███████╗            ║
    ║      ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚══════╝            ║
    ║                                                                      ║
    ║                         K R Y S O L                                  ║
    ║                                                                      ║
    ║                    DISCORD ECONOMY BOT v1.0                          ║
    ║                    Created by: Krysol Dev                            ║
    ║                                                                      ║
    ╚══════════════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"
echo ""

# ============================================
# FUNCTIONS
# ============================================

full_install() {
    clear
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    🚀 FULL INSTALLATION${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Check Node.js
    echo -e "${YELLOW}[1/5] Checking Node.js...${NC}"
    if ! command -v node &> /dev/null; then
        echo -e "${RED}Node.js not found! Installing...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - > /dev/null 2>&1
        sudo apt-get install -y nodejs > /dev/null 2>&1
    fi
    echo -e "${GREEN}✓ Node.js $(node -v) installed${NC}"
    
    # Create directories
    echo -e "${YELLOW}[2/5] Creating directories...${NC}"
    mkdir -p src/commands/{economy,banking,security,gambling,fun,pvp,shop,trade,admin}
    mkdir -p src/events src/utils src/data
    echo "{}" > src/data/users.json 2>/dev/null || true
    echo -e "${GREEN}✓ Directories created${NC}"
    
    # Create package.json
    echo -e "${YELLOW}[3/5] Creating package.json...${NC}"
    cat > package.json << 'PKGEOF'
{
  "name": "vaultheist-bot",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {"start": "node index.js"},
  "dependencies": {"discord.js": "^14.14.1", "dotenv": "^16.3.1"}
}
PKGEOF
    echo -e "${GREEN}✓ package.json created${NC}"
    
    # Create index.js
    echo -e "${YELLOW}[4/5] Creating index.js...${NC}"
    cat > index.js << 'INDEXEOF'
const { Client, Collection, GatewayIntentBits, REST, Routes } = require('discord.js');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const client = new Client({
    intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.MessageContent]
});

client.commands = new Collection();

// Load commands
const commandFolders = fs.readdirSync('./src/commands');
for (const folder of commandFolders) {
    const folderPath = path.join('./src/commands', folder);
    if (fs.statSync(folderPath).isDirectory()) {
        const commandFiles = fs.readdirSync(folderPath).filter(file => file.endsWith('.js'));
        for (const file of commandFiles) {
            try {
                const command = require(`./src/commands/${folder}/${file}`);
                if (command.data && command.execute) {
                    client.commands.set(command.data.name, command);
                }
            } catch (err) {}
        }
    }
}

// Load events
const eventFiles = fs.readdirSync('./src/events').filter(file => file.endsWith('.js'));
for (const file of eventFiles) {
    const event = require(`./src/events/${file}`);
    if (event.once) {
        client.once(event.name, (...args) => event.execute(...args, client));
    } else {
        client.on(event.name, (...args) => event.execute(...args, client));
    }
}

// Register commands
const commands = [];
for (const command of client.commands.values()) {
    commands.push(command.data.toJSON());
}

const rest = new REST({ version: '10' }).setToken(process.env.TOKEN);

(async () => {
    try {
        if (process.env.GUILD_ID) {
            await rest.put(Routes.applicationGuildCommands(process.env.CLIENT_ID, process.env.GUILD_ID), { body: commands });
        } else {
            await rest.put(Routes.applicationCommands(process.env.CLIENT_ID), { body: commands });
        }
        console.log('Commands registered!');
    } catch (error) {
        console.error(error);
    }
})();

client.login(process.env.TOKEN);
INDEXEOF
    echo -e "${GREEN}✓ index.js created${NC}"
    
    # Install dependencies
    echo -e "${YELLOW}[5/5] Installing dependencies...${NC}"
    npm install --silent
    echo -e "${GREEN}✓ Dependencies installed${NC}"
    
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ INSTALLATION COMPLETE!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

configure_only() {
    clear
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    ⚙️  CONFIGURATION WIZARD${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}📌 Get credentials from:${NC}"
    echo -e "${BLUE}   https://discord.com/developers/applications${NC}"
    echo ""
    
    # Get Bot Token
    echo -e "${YELLOW}Discord Bot Token:${NC}"
    echo -ne "${CYAN}   Enter token: ${NC}"
    read -s TOKEN
    echo ""
    echo ""
    
    # Get Client ID
    echo -e "${YELLOW}Client ID (Application ID):${NC}"
    echo -ne "${CYAN}   Enter Client ID: ${NC}"
    read CLIENT_ID
    echo ""
    
    # Get Guild ID
    echo -e "${YELLOW}Guild ID (Server ID) - OPTIONAL:${NC}"
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
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

auto_fix() {
    clear
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    🔧 AUTO-FIX & REPAIR${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Create directories
    echo -ne "${YELLOW}Creating directories...${NC}"
    mkdir -p src/commands/{economy,banking,security,gambling,fun,pvp,shop,trade,admin}
    mkdir -p src/events src/utils src/data
    echo -e " ${GREEN}✓${NC}"
    
    # Create users.json
    echo -ne "${YELLOW}Creating users.json...${NC}"
    [ ! -f "src/data/users.json" ] && echo "{}" > src/data/users.json
    echo -e " ${GREEN}✓${NC}"
    
    # Create events
    echo -ne "${YELLOW}Creating events...${NC}"
    cat > src/events/ready.js << 'EOF'
module.exports = {
    name: 'ready',
    once: true,
    execute(client) {
        console.log(`✅ ${client.user.tag} is online!`);
        client.user.setActivity('/help | VaultHeist', { type: 'PLAYING' });
    }
};
EOF
    cat > src/events/interactionCreate.js << 'EOF'
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
EOF
    echo -e " ${GREEN}✓${NC}"
    
    # Create help command
    echo -ne "${YELLOW}Creating help command...${NC}"
    cat > src/commands/help.js << 'EOF'
const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
module.exports = {
    data: new SlashCommandBuilder().setName('help').setDescription('Show all commands'),
    async execute(interaction) {
        const embed = new EmbedBuilder().setColor(0x9b59b6).setTitle('🎮 VaultHeist Commands').addFields(
            { name: '💰 Economy', value: '`/balance`, `/daily`, `/work`', inline: false },
            { name: '🏦 Banking', value: '`/deposit`, `/withdraw`, `/bank`', inline: false },
            { name: '🎲 Gambling', value: '`/coinflip`, `/slots`', inline: false }
        );
        await interaction.reply({ embeds: [embed] });
    }
};
EOF
    echo -e " ${GREEN}✓${NC}"
    
    # Create balance command
    echo -ne "${YELLOW}Creating balance command...${NC}"
    cat > src/commands/economy/balance.js << 'EOF'
const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');
module.exports = {
    data: new SlashCommandBuilder().setName('balance').setDescription('Check balance'),
    async execute(interaction) {
        const data = economy.getUser(interaction.user.id);
        const embed = new EmbedBuilder().setColor(0x00ff00).setTitle('Balance')
            .addFields({ name: '💰 Wallet', value: `₹${data.balance}`, inline: true });
        await interaction.reply({ embeds: [embed] });
    }
};
EOF
    echo -e " ${GREEN}✓${NC}"
    
    # Create economy utility
    echo -ne "${YELLOW}Creating economy utility...${NC}"
    cat > src/utils/economy.js << 'EOF'
const fs = require('fs');
const path = require('path');
const usersPath = path.join(__dirname, '../data/users.json');

function loadUsers() {
    if (!fs.existsSync(usersPath)) fs.writeFileSync(usersPath, '{}');
    return JSON.parse(fs.readFileSync(usersPath, 'utf8'));
}

function saveUsers(users) {
    fs.writeFileSync(usersPath, JSON.stringify(users, null, 2));
}

function getUser(userId) {
    const users = loadUsers();
    if (!users[userId]) {
        users[userId] = { balance: 0, bank: 0, pin: null, jailedUntil: 0, inventory: [] };
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
    updateUser(userId, { balance: user.balance + amount });
}

function removeMoney(userId, amount) {
    const user = getUser(userId);
    if (user.balance < amount) return false;
    updateUser(userId, { balance: user.balance - amount });
    return true;
}

module.exports = { getUser, updateUser, addMoney, removeMoney };
EOF
    echo -e " ${GREEN}✓${NC}"
    
    # Install dependencies if needed
    echo -ne "${YELLOW}Checking dependencies...${NC}"
    if [ ! -d "node_modules" ]; then
        npm install --silent
        echo -e " ${GREEN}installed${NC}"
    else
        echo -e " ${GREEN}ok${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}✅ AUTO-FIX COMPLETE!${NC}"
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

start_bot() {
    clear
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    🎮 STARTING BOT${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if [ ! -f ".env" ]; then
        echo -e "${RED}❌ .env file not found! Please configure first.${NC}"
        echo -e "${YELLOW}Press Enter to continue...${NC}"
        read
        return
    fi
    
    if grep -q "PASTE_YOUR_TOKEN" .env 2>/dev/null; then
        echo -e "${RED}❌ Token not configured! Please run configuration.${NC}"
        echo -e "${YELLOW}Press Enter to continue...${NC}"
        read
        return
    fi
    
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}Installing dependencies...${NC}"
        npm install --silent
    fi
    
    echo -e "${GREEN}🚀 Bot is starting...${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop${NC}"
    echo ""
    npm start
    
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

status_check() {
    clear
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    📊 STATUS CHECK${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # .env check
    echo -ne "${YELLOW}.env file:${NC} "
    if [ -f ".env" ]; then
        if grep -q "PASTE_YOUR_TOKEN" .env 2>/dev/null; then
            echo -e "${RED}Not configured${NC}"
        else
            echo -e "${GREEN}Configured ✓${NC}"
        fi
    else
        echo -e "${RED}Missing${NC}"
    fi
    
    # Dependencies check
    echo -ne "${YELLOW}Dependencies:${NC} "
    if [ -d "node_modules" ]; then
        echo -e "${GREEN}Installed ✓${NC}"
    else
        echo -e "${RED}Not installed${NC}"
    fi
    
    # Commands count
    echo -ne "${YELLOW}Commands:${NC} "
    if [ -d "src/commands" ]; then
        count=$(find src/commands -name "*.js" 2>/dev/null | wc -l)
        echo -e "${GREEN}$count commands ✓${NC}"
    else
        echo -e "${RED}No commands${NC}"
    fi
    
    # Users count
    echo -ne "${YELLOW}Users:${NC} "
    if [ -f "src/data/users.json" ]; then
        users=$(grep -c '"balance"' src/data/users.json 2>/dev/null || echo "0")
        echo -e "${GREEN}$users users registered ✓${NC}"
    else
        echo -e "${RED}No data${NC}"
    fi
    
    # PM2 check
    echo -ne "${YELLOW}PM2 Status:${NC} "
    if command -v pm2 &> /dev/null; then
        if pm2 list 2>/dev/null | grep -q "VaultHeist"; then
            echo -e "${GREEN}Running ✓${NC}"
        else
            echo -e "${YELLOW}Not running${NC}"
        fi
    else
        echo -e "${YELLOW}Not installed${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

# ============================================
# MAIN MENU
# ============================================
while true; do
    clear
    echo -e "${MAGENTA}"
    cat << "BANNER"
    ╔══════════════════════════════════════════════════════════════════════╗
    ║                                                                      ║
    ║      ██╗  ██╗██████╗ ██╗   ██╗███████╗ ██████╗ ██╗                 ║
    ║      ██║ ██╔╝██╔══██╗╚██╗ ██╔╝██╔════╝██╔═══██╗██║                 ║
    ║      █████╔╝ ██████╔╝ ╚████╔╝ ███████╗██║   ██║██║                 ║
    ║      ██╔═██╗ ██╔══██╗  ╚██╔╝  ╚════██║██║   ██║██║                 ║
    ║      ██║  ██╗██║  ██║   ██║   ███████║╚██████╔╝███████╗            ║
    ║      ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚══════╝            ║
    ║                                                                      ║
    ║                         K R Y S O L                                  ║
    ║                                                                      ║
    ║                    DISCORD ECONOMY BOT v1.0                          ║
    ║                    Created by: Krysol Dev                            ║
    ║                                                                      ║
    ╚══════════════════════════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    echo ""
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
            echo -e "${RED}Invalid option! Please enter 0-5.${NC}"
            sleep 2
            ;;
    esac
done
EOF

chmod +x ultimate_fixed.sh
./ultimate_fixed.sh
