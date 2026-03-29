function validateAmount(amount) {
    if (!amount || amount <= 0) return false;
    if (isNaN(amount)) return false;
    if (!Number.isInteger(amount)) return false;
    return true;
}

function validatePin(pin) {
    if (!pin) return false;
    if (pin.toString().length !== 4) return false;
    if (isNaN(pin)) return false;
    return true;
}

function validateUser(user) {
    if (!user) return false;
    if (user.bot) return false;
    return true;
}

function hasEnoughMoney(balance, amount) {
    return balance >= amount;
}

function isWithinLimit(amount, maxLimit) {
    return amount <= maxLimit;
}

module.exports = {
    validateAmount,
    validatePin,
    validateUser,
    hasEnoughMoney,
    isWithinLimit
};
