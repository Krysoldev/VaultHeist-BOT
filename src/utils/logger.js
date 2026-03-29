const fs = require('fs');
const path = require('path');

const logPath = path.join(__dirname, '../data/logs.txt');

function logAction(action, userId, username, details) {
    const timestamp = new Date().toISOString();
    const logEntry = `[${timestamp}] ${action} | User: ${username} (${userId}) | ${details}\n`;
    
    fs.appendFileSync(logPath, logEntry);
    console.log(logEntry.trim());
}

function logTransaction(userId, username, type, amount, balance) {
    logAction('TRANSACTION', userId, username, `${type}: $${amount} | New Balance: $${balance}`);
}

function logRobbery(victimId, victimName, robberId, robberName, amount, success) {
    const status = success ? 'SUCCESS' : 'FAILED';
    logAction('ROBBERY', robberId, robberName, `${status} | Victim: ${victimName} (${victimId}) | Amount: $${amount}`);
}

function logAdminAction(adminId, adminName, action, targetId, targetName, details) {
    logAction('ADMIN', adminId, adminName, `${action} | Target: ${targetName} (${targetId}) | ${details}`);
}

module.exports = {
    logAction,
    logTransaction,
    logRobbery,
    logAdminAction
};
