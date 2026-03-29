cat << 'EOF' > fix_error.sh
#!/bin/bash

# ============================================
# VAULT HEIST - ERROR FIX SCRIPT
# Created by: Krysol Dev
# ============================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

clear
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              🔧 FIXING ENOTDIR ERROR${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""

# Remove the problematic file/directory
echo -e "${YELLOW}[1/5] Removing problematic help.js...${NC}"
rm -rf src/commands/help.js 2>/dev/null
echo -e "${GREEN}✓ Removed${NC}"

# Recreate help.js in correct location
echo -e "${YELLOW}[2/5] Creating help.js in correct location...${NC}"
cat > src/commands/help.js << 'HELPEOF'
const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('help')
        .setDescription('Show all available commands'),
    async execute(interaction) {
        const embed = new EmbedBuilder()
            .setColor(0x9b59b6)
            .setTitle('🎮 VaultHeist Commands')
            .setDescription('Here are all available commands:')
            .addFields(
                { name: '💰 Economy', value: '`/balance`, `/daily`, `/work`, `/beg`, `/profile`, `/leaderboard`, `/rank`', inline: false },
                { name: '🏦 Banking', value: '`/deposit`, `/withdraw`, `/bank`, `/interest`', inline: false },
                { name: '🎲 Gambling', value: '`/coinflip`, `/slots`, `/dice`', inline: false },
                { name: '🦹‍♂️ Security', value: '`/rob`, `/bail`, `/setpin`, `/changepin`, `/removepin`', inline: false },
                { name: '🛍️ Shop', value: '`/shop`, `/buy`, `/sell`, `/inventory`', inline: false },
                { name: '🎣 Fun', value: '`/crime`, `/hunt`, `/fish`, `/dig`', inline: false },
                { name: '⚔️ PvP', value: '`/fight`', inline: false },
                { name: '🤝 Trading', value: '`/trade`', inline: false }
            )
            .setFooter({ text: 'Created by Krysol Dev' })
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
HELPEOF
echo -e "${GREEN}✓ Created${NC}"

# Fix index.js to properly handle commands
echo -e "${YELLOW}[3/5] Fixing index.js...${NC}"
cat > index.js << 'INDEXEOF'
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

// Load commands from folders
const commandFolders = fs.readdirSync('./src/commands');
for (const folder of commandFolders) {
    const folderPath = path.join('./src/commands', folder);
    // Check if it's a directory (not a file)
    if (fs.statSync(folderPath).isDirectory()) {
        const commandFiles = fs.readdirSync(folderPath).filter(file => file.endsWith('.js'));
        for (const file of commandFiles) {
            try {
                const command = require(`./src/commands/${folder}/${file}`);
                if ('data' in command && 'execute' in command) {
                    client.commands.set(command.data.name, command);
                    console.log(`✅ Loaded command: ${command.data.name}`);
                }
            } catch (err) {
                console.log(`❌ Error loading ${file}:`, err.message);
            }
        }
    }
}

// Load direct command files (like help.js)
const directCommands = fs.readdirSync('./src/commands').filter(file => file.endsWith('.js'));
for (const file of directCommands) {
    try {
        const command = require(`./src/commands/${file}`);
        if ('data' in command && 'execute' in command) {
            client.commands.set(command.data.name, command);
            console.log(`✅ Loaded command: ${command.data.name}`);
        }
    } catch (err) {
        console.log(`❌ Error loading ${file}:`, err.message);
    }
}

// Load events
const eventFiles = fs.readdirSync('./src/events').filter(file => file.endsWith('.js'));
for (const file of eventFiles) {
    try {
        const event = require(`./src/events/${file}`);
        if (event.once) {
            client.once(event.name, (...args) => event.execute(...args, client));
        } else {
            client.on(event.name, (...args) => event.execute(...args, client));
        }
        console.log(`✅ Loaded event: ${event.name}`);
    } catch (err) {
        console.log(`❌ Error loading event ${file}:`, err.message);
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
        console.log(`✅ Registered ${commands.length} commands`);
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
INDEXEOF
echo -e "${GREEN}✓ index.js fixed${NC}"

# Create economy utility if missing
echo -e "${YELLOW}[4/5] Creating economy utility...${NC}"
mkdir -p src/utils
cat > src/utils/economy.js << 'ECONEOF'
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
    updateUser(userId, { 
        balance: newBalance,
        totalEarned: user.totalEarned + amount
    });
    return newBalance;
}

function removeMoney(userId, amount) {
    const user = getUser(userId);
    if (user.balance < amount) return false;
    const newBalance = user.balance - amount;
    updateUser(userId, { 
        balance: newBalance,
        totalSpent: user.totalSpent + amount
    });
    return true;
}

function addBank(userId, amount) {
    const user = getUser(userId);
    const newBank = user.bank + amount;
    updateUser(userId, { bank: newBank });
    return newBank;
}

function removeBank(userId, amount) {
    const user = getUser(userId);
    if (user.bank < amount) return false;
    const newBank = user.bank - amount;
    updateUser(userId, { bank: newBank });
    return true;
}

function setPin(userId, pin) {
    updateUser(userId, { pin: pin.toString(), pinAttempts: 0 });
}

function verifyPin(userId, pin) {
    const user = getUser(userId);
    if (!user.pin) return true;
    if (user.pin !== pin.toString()) {
        const attempts = (user.pinAttempts || 0) + 1;
        updateUser(userId, { pinAttempts: attempts });
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
    const rank = sorted.findIndex(([id]) => id === userId) + 1;
    return rank;
}

module.exports = {
    getUser, updateUser, addMoney, removeMoney, addBank, removeBank,
    setPin, verifyPin, isJailed, setJail, addToInventory, removeFromInventory,
    getInventory, getRank, loadUsers, saveUsers
};
ECONEOF
echo -e "${GREEN}✓ economy.js created${NC}"

# Create items.js
echo -e "${YELLOW}[5/5] Creating items.js...${NC}"
cat > src/utils/items.js << 'ITEMEOF'
const items = {
    pickaxe: { name: '⛏️ Pickaxe', price: 500, sellPrice: 250, description: 'Increases mining rewards' },
    fishing_rod: { name: '🎣 Fishing Rod', price: 300, sellPrice: 150, description: 'Increases fishing rewards' },
    hunting_rifle: { name: '🔫 Hunting Rifle', price: 1000, sellPrice: 500, description: 'Increases hunting rewards' },
    lucky_coin: { name: '🪙 Lucky Coin', price: 2000, sellPrice: 1000, description: 'Increases gambling luck' },
    lockpick: { name: '🔓 Lockpick', price: 150, sellPrice: 75, description: 'Reduces jail time' },
    armor: { name: '🛡️ Armor', price: 3000, sellPrice: 1500, description: 'Reduces robbery losses' }
};
module.exports = { items };
ITEMEOF
echo -e "${GREEN}✓ items.js created${NC}"

# Create users.json
mkdir -p src/data
echo "{}" > src/data/users.json

# Create events
mkdir -p src/events
cat > src/events/ready.js << 'READYEOF'
module.exports = {
    name: 'ready',
    once: true,
    execute(client) {
        console.log(`✅ ${client.user.tag} is online!`);
        console.log(`📊 Serving ${client.guilds.cache.size} guilds`);
        client.user.setActivity('/help | VaultHeist', { type: 'PLAYING' });
    }
};
READYEOF

cat > src/events/interactionCreate.js << 'INTEOF'
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
INTEOF

# Create a simple balance command
mkdir -p src/commands/economy
cat > src/commands/economy/balance.js << 'BALEOF'
const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('balance')
        .setDescription('Check your balance')
        .addUserOption(option => option.setName('user').setDescription('User to check')),
    async execute(interaction) {
        const target = interaction.options.getUser('user') || interaction.user;
        const data = economy.getUser(target.id);
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle(`${target.username}'s Balance`)
            .addFields(
                { name: '💰 Wallet', value: `₹${data.balance.toLocaleString()}`, inline: true },
                { name: '🏦 Bank', value: `₹${data.bank.toLocaleString()}`, inline: true },
                { name: '💎 Total', value: `₹${(data.balance + data.bank).toLocaleString()}`, inline: true }
            );
        await interaction.reply({ embeds: [embed] });
    }
};
BALEOF

# Install dependencies if needed
echo ""
echo -e "${YELLOW}Installing dependencies...${NC}"
npm install --silent

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ FIX COMPLETE!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📋 What was fixed:${NC}"
echo "   ✓ Removed problematic help.js file"
echo "   ✓ Recreated help.js as proper command"
echo "   ✓ Fixed index.js to handle directories correctly"
echo "   ✓ Created all utility files"
echo "   ✓ Created event handlers"
echo "   ✓ Created balance command"
echo ""
echo -e "${GREEN}🚀 Now you can start the bot:${NC}"
echo "   npm start"
echo ""
echo -e "${YELLOW}⚠️  Make sure to configure .env first if not done:${NC}"
echo "   nano .env"
echo ""

# Ask to start bot
read -p "Start bot now? (y/n): " start_now
if [[ $start_now == "y" || $start_now == "Y" ]]; then
    echo -e "${GREEN}Starting bot...${NC}"
    npm start
fi
EOF

chmod +x fix_error.sh
./fix_error.sh
