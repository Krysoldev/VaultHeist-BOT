const cooldowns = new Map();

function setCooldown(userId, command, seconds) {
    if (!cooldowns.has(command)) {
        cooldowns.set(command, new Map());
    }
    
    const timestamps = cooldowns.get(command);
    const now = Date.now();
    timestamps.set(userId, now);
    
    setTimeout(() => {
        timestamps.delete(userId);
    }, seconds * 1000);
}

function getCooldown(userId, command) {
    if (!cooldowns.has(command)) return 0;
    
    const timestamps = cooldowns.get(command);
    if (!timestamps.has(userId)) return 0;
    
    const now = Date.now();
    const expiration = timestamps.get(userId);
    const remaining = (expiration + (command.cooldown * 1000)) - now;
    
    return remaining > 0 ? remaining / 1000 : 0;
}

function clearCooldown(userId, command) {
    if (cooldowns.has(command)) {
        cooldowns.get(command).delete(userId);
    }
}

module.exports = {
    setCooldown,
    getCooldown,
    clearCooldown
};
