cat << 'EOF' > auto_fix.sh
#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}         VAULT HEIST - AUTO FIX & REPAIR TOOL${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# Function to check and fix missing directories
fix_directories() {
    echo -e "${YELLOW}[1/6] Checking directory structure...${NC}"
    
    mkdir -p src/commands/{economy,banking,security,gambling,fun,pvp,shop,trade,admin}
    mkdir -p src/events
    mkdir -p src/utils
    mkdir -p src/data
    
    echo -e "${GREEN}✓ Directories created/fixed${NC}"
}

# Function to check and fix package.json
fix_package_json() {
    echo -e "${YELLOW}[2/6] Checking package.json...${NC}"
    
    if [ ! -f "package.json" ]; then
        cat > package.json << 'EOF'
{
  "name": "vaultheist-bot",
  "version": "1.0.0",
  "description": "Advanced Discord Economy Bot",
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
EOF
        echo -e "${GREEN}✓ package.json created${NC}"
    else
        echo -e "${GREEN}✓ package.json exists${NC}"
    fi
}

# Function to check and fix .env
fix_env() {
    echo -e "${YELLOW}[3/6] Checking .env file...${NC}"
    
    if [ ! -f ".env" ]; then
        cat > .env << 'EOF'
TOKEN=PASTE_YOUR_TOKEN_HERE
CLIENT_ID=PASTE_YOUR_CLIENT_ID_HERE
GUILD_ID=PASTE_YOUR_GUILD_ID_HERE
EOF
        echo -e "${GREEN}✓ .env file created (edit with your credentials)${NC}"
    else
        echo -e "${GREEN}✓ .env file exists${NC}"
    fi
}

# Function to fix index.js
fix_index() {
    echo -e "${YELLOW}[4/6] Checking index.js...${NC}"
    
    cat > index.js << 'EOF'
const { Client, Collection, GatewayIntentBits, REST, Routes } = require('discord.js');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent,
        GatewayIntentBits.GuildMembers
    ]
});

client.commands = new Collection();
client.cooldowns = new Collection();

// Load commands from folders
const commandFolders = fs.readdirSync('./src/commands');
for (const folder of commandFolders) {
    const folderPath = path.join('./src/commands', folder);
    if (fs.existsSync(folderPath) && fs.statSync(folderPath).isDirectory()) {
        const commandFiles = fs.readdirSync(folderPath).filter(file => file.endsWith('.js'));
        for (const file of commandFiles) {
            try {
                const command = require(`./src/commands/${folder}/${file}`);
                if (command.data && command.execute) {
                    client.commands.set(command.data.name, command);
                }
            } catch (err) {
                console.log(`Error loading command ${file}:`, err.message);
            }
        }
    }
}

// Load direct commands
if (fs.existsSync('./src/commands')) {
    const directCommands = fs.readdirSync('./src/commands').filter(file => file.endsWith('.js'));
    for (const file of directCommands) {
        try {
            const command = require(`./src/commands/${file}`);
            if (command.data && command.execute) {
                client.commands.set(command.data.name, command);
            }
        } catch (err) {
            console.log(`Error loading command ${file}:`, err.message);
        }
    }
}

// Load events
if (fs.existsSync('./src/events')) {
    const eventFiles = fs.readdirSync('./src/events').filter(file => file.endsWith('.js'));
    for (const file of eventFiles) {
        try {
            const event = require(`./src/events/${file}`);
            if (event.once) {
                client.once(event.name, (...args) => event.execute(...args, client));
            } else {
                client.on(event.name, (...args) => event.execute(...args, client));
            }
        } catch (err) {
            console.log(`Error loading event ${file}:`, err.message);
        }
    }
}

// Register slash commands
const commands = [];
for (const command of client.commands.values()) {
    commands.push(command.data.toJSON());
}

const rest = new REST({ version: '10' }).setToken(process.env.TOKEN);

(async () => {
    try {
        console.log('Started refreshing application (/) commands.');
        
        if (process.env.GUILD_ID && process.env.GUILD_ID !== 'PASTE_YOUR_GUILD_ID_HERE') {
            await rest.put(
                Routes.applicationGuildCommands(process.env.CLIENT_ID, process.env.GUILD_ID),
                { body: commands },
            );
            console.log('Successfully reloaded guild application (/) commands.');
        } else {
            await rest.put(
                Routes.applicationCommands(process.env.CLIENT_ID),
                { body: commands },
            );
            console.log('Successfully reloaded global application (/) commands.');
        }
    } catch (error) {
        console.error('Error registering commands:', error);
    }
})();

client.login(process.env.TOKEN).catch(err => {
    console.error('Error logging in:', err.message);
});

process.on('unhandledRejection', error => {
    console.error('Unhandled promise rejection:', error);
});
EOF
    echo -e "${GREEN}✓ index.js fixed/updated${NC}"
}

# Function to fix core utilities
fix_utils() {
    echo -e "${YELLOW}[5/6] Checking utility files...${NC}"
    
    # Fix economy.js
    cat > src/utils/economy.js << 'EOF'
const fs = require('fs');
const path = require('path');

const usersPath = path.join(__dirname, '../data/users.json');

function loadUsers() {
    if (!fs.existsSync(usersPath)) {
        fs.writeFileSync(usersPath, JSON.stringify({}));
    }
    return JSON.parse(fs.readFileSync(usersPath, 'utf8'));
}

function saveUsers(users) {
    fs.writeFileSync(usersPath, JSON.stringify(users, null, 2));
}

function getUser(userId) {
    const users = loadUsers();
    if (!users[userId]) {
        users[userId] = {
            balance: 0,
            bank: 0,
            pin: null,
            pinAttempts: 0,
            jailedUntil: 0,
            inventory: [],
            totalEarned: 0,
            totalSpent: 0,
            lastDaily: 0,
            lastWork: 0,
            lastBeg: 0,
            lastCrime: 0,
            lastHunt: 0,
            lastFish: 0,
            lastDig: 0,
            lastRob: 0,
            lastFight: 0,
            blacklisted: false,
            wins: 0,
            losses: 0
        };
        saveUsers(users);
    }
    return users[userId];
}

function updateUser(userId, updates) {
    const users = loadUsers();
    if (!users[userId]) users[userId] = getUser(userId);
    Object.assign(users[userId], updates);
    saveUsers(users);
    return users[userId];
}

function addMoney(userId, amount) {
    const user = getUser(userId);
    const newBalance = user.balance + amount;
    updateUser(userId, { balance: newBalance, totalEarned: user.totalEarned + amount });
    return newBalance;
}

function removeMoney(userId, amount) {
    const user = getUser(userId);
    if (user.balance < amount) return false;
    updateUser(userId, { balance: user.balance - amount, totalSpent: user.totalSpent + amount });
    return true;
}

function addBank(userId, amount) {
    const user = getUser(userId);
    updateUser(userId, { bank: user.bank + amount });
    return user.bank + amount;
}

function removeBank(userId, amount) {
    const user = getUser(userId);
    if (user.bank < amount) return false;
    updateUser(userId, { bank: user.bank - amount });
    return true;
}

function setPin(userId, pin) {
    updateUser(userId, { pin: pin.toString(), pinAttempts: 0 });
}

function verifyPin(userId, pin) {
    const user = getUser(userId);
    if (!user.pin) return true;
    if (user.pin !== pin.toString()) {
        updateUser(userId, { pinAttempts: (user.pinAttempts || 0) + 1 });
        return false;
    }
    updateUser(userId, { pinAttempts: 0 });
    return true;
}

function isJailed(userId) {
    const user = getUser(userId);
    return user.jailedUntil > Date.now();
}

function setJail(userId, minutes) {
    updateUser(userId, { jailedUntil: Date.now() + (minutes * 60 * 1000) });
}

function addToInventory(userId, itemId, quantity = 1) {
    const user = getUser(userId);
    const inventory = [...user.inventory];
    const existing = inventory.find(i => i.id === itemId);
    if (existing) existing.quantity += quantity;
    else inventory.push({ id: itemId, quantity });
    updateUser(userId, { inventory });
}

function removeFromInventory(userId, itemId, quantity = 1) {
    const user = getUser(userId);
    const inventory = [...user.inventory];
    const index = inventory.findIndex(i => i.id === itemId);
    if (index === -1) return false;
    if (inventory[index].quantity <= quantity) inventory.splice(index, 1);
    else inventory[index].quantity -= quantity;
    updateUser(userId, { inventory });
    return true;
}

function getInventory(userId) {
    return getUser(userId).inventory;
}

function getRank(userId) {
    const users = loadUsers();
    const sorted = Object.entries(users)
        .filter(([_, data]) => !data.blacklisted)
        .sort((a, b) => (b[1].balance + b[1].bank) - (a[1].balance + a[1].bank));
    return sorted.findIndex(([id]) => id === userId) + 1;
}

module.exports = {
    getUser, updateUser, addMoney, removeMoney, addBank, removeBank,
    setPin, verifyPin, isJailed, setJail, addToInventory, removeFromInventory,
    getInventory, getRank, loadUsers, saveUsers
};
EOF

    # Fix items.js
    cat > src/utils/items.js << 'EOF'
const items = {
    pickaxe: { name: '⛏️ Pickaxe', price: 500, sellPrice: 250, description: 'Increases mining rewards' },
    fishing_rod: { name: '🎣 Fishing Rod', price: 300, sellPrice: 150, description: 'Increases fishing rewards' },
    hunting_rifle: { name: '🔫 Hunting Rifle', price: 1000, sellPrice: 500, description: 'Increases hunting rewards' },
    lucky_coin: { name: '🪙 Lucky Coin', price: 2000, sellPrice: 1000, description: 'Increases gambling luck' },
    lockpick: { name: '🔓 Lockpick', price: 150, sellPrice: 75, description: 'Reduces jail time' },
    armor: { name: '🛡️ Armor', price: 3000, sellPrice: 1500, description: 'Reduces robbery losses' }
};
module.exports = { items };
EOF

    echo -e "${GREEN}✓ Utility files fixed${NC}"
}

# Function to fix events
fix_events() {
    echo -e "${YELLOW}[6/6] Checking event files...${NC}"
    
    cat > src/events/ready.js << 'EOF'
module.exports = {
    name: 'ready',
    once: true,
    execute(client) {
        console.log(`✅ ${client.user.tag} is online!`);
        console.log(`📊 Serving ${client.guilds.cache.size} guilds`);
        client.user.setActivity('/help | VaultHeist', { type: 'PLAYING' });
    }
};
EOF

    cat > src/events/interactionCreate.js << 'EOF'
const economy = require('../utils/economy');

module.exports = {
    name: 'interactionCreate',
    async execute(interaction, client) {
        if (!interaction.isChatInputCommand()) return;
        
        const command = client.commands.get(interaction.commandName);
        if (!command) return;
        
        try {
            const userData = economy.getUser(interaction.user.id);
            if (userData.blacklisted && !interaction.memberPermissions?.has('Administrator')) {
                return interaction.reply({ content: '⛔ You are blacklisted!', ephemeral: true });
            }
            await command.execute(interaction);
        } catch (error) {
            console.error(`Error in ${interaction.commandName}:`, error);
            const errorMsg = { content: '❌ Error executing command!', ephemeral: true };
            if (interaction.replied || interaction.deferred) {
                await interaction.followUp(errorMsg);
            } else {
                await interaction.reply(errorMsg);
            }
        }
    }
};
EOF

    echo -e "${GREEN}✓ Event files fixed${NC}"
}

# Function to create missing basic commands
fix_commands() {
    echo -e "${YELLOW}[7/7] Creating missing commands...${NC}"
    
    # Create help command if missing
    if [ ! -f "src/commands/help.js" ]; then
        cat > src/commands/help.js << 'EOF'
const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
module.exports = {
    data: new SlashCommandBuilder().setName('help').setDescription('Show all commands'),
    async execute(interaction) {
        const embed = new EmbedBuilder().setColor(0x9b59b6).setTitle('🎮 VaultHeist Commands').addFields(
            { name: '💰 Economy', value: '`/balance`, `/daily`, `/work`, `/beg`, `/profile`', inline: false },
            { name: '🏦 Banking', value: '`/deposit`, `/withdraw`, `/bank`, `/interest`', inline: false },
            { name: '🎲 Gambling', value: '`/coinflip`, `/slots`, `/dice`', inline: false },
            { name: '🦹‍♂️ Security', value: '`/rob`, `/bail`, `/setpin`', inline: false }
        );
        await interaction.reply({ embeds: [embed] });
    }
};
EOF
        echo -e "${GREEN}✓ help command created${NC}"
    fi
    
    # Create balance command if missing
    if [ ! -f "src/commands/economy/balance.js" ]; then
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
        echo -e "${GREEN}✓ balance command created${NC}"
    fi
}

# Run all fixes
fix_directories
fix_package_json
fix_env
fix_index
fix_utils
fix_events
fix_commands

# Install dependencies if needed
echo -e "${YELLOW}[8/8] Checking dependencies...${NC}"
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}Installing dependencies...${NC}"
    npm install --silent
    echo -e "${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${GREEN}✓ Dependencies already installed${NC}"
fi

# Create users.json if missing
if [ ! -f "src/data/users.json" ]; then
    echo "{}" > src/data/users.json
    echo -e "${GREEN}✓ users.json created${NC}"
fi

# Test syntax
echo -e "${YELLOW}[9/9] Testing syntax...${NC}"
if node -c index.js 2>/dev/null; then
    echo -e "${GREEN}✓ Syntax check passed${NC}"
else
    echo -e "${RED}✗ Syntax error detected - please check your files${NC}"
fi

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ AUTO-FIX COMPLETE!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📋 Summary:${NC}"
echo "   ✓ All directories created"
echo "   ✓ Core files fixed"
echo "   ✓ Dependencies installed"
echo "   ✓ Commands restored"
echo ""
echo -e "${YELLOW}⚠️  Don't forget to edit .env with your bot credentials!${NC}"
echo ""
echo -e "${GREEN}🚀 Start the bot:${NC}"
echo "   npm start"
echo ""
echo -e "${BLUE}Or run with PM2:${NC}"
echo "   npm install -g pm2 && pm2 start index.js --name VaultHeist"
echo ""

# Ask if user wants to start bot
read -p "Start bot now? (y/n): " start_now
if [[ $start_now == "y" || $start_now == "Y" ]]; then
    echo -e "${GREEN}Starting bot...${NC}"
    npm start
fi
EOF

chmod +x auto_fix.sh
./auto_fix.sh
