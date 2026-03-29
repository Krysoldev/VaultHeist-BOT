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
    if (!users[userId]) {
        users[userId] = getUser(userId);
    }
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
    if (existing) {
        existing.quantity += quantity;
    } else {
        inventory.push({ id: itemId, quantity });
    }
    updateUser(userId, { inventory });
}

function removeFromInventory(userId, itemId, quantity = 1) {
    const user = getUser(userId);
    const inventory = [...user.inventory];
    const index = inventory.findIndex(i => i.id === itemId);
    if (index === -1) return false;
    
    if (inventory[index].quantity <= quantity) {
        inventory.splice(index, 1);
    } else {
        inventory[index].quantity -= quantity;
    }
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
    getUser,
    updateUser,
    addMoney,
    removeMoney,
    addBank,
    removeBank,
    setPin,
    verifyPin,
    isJailed,
    setJail,
    addToInventory,
    removeFromInventory,
    getInventory,
    getRank,
    loadUsers,
    saveUsers
};
