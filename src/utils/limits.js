const MAX_DAILY = 1000;
const MAX_WORK = 500;
const MAX_BEG = 100;
const MAX_CRIME = 2000;
const MAX_HUNT = 500;
const MAX_FISH = 300;
const MAX_DIG = 1000;
const MAX_ROB_STEAL = 5000;
const MAX_GAMBLE_BET = 10000;
const MAX_TRADE = 50000;

function checkDailyLimit(amount) {
    return amount <= MAX_DAILY;
}

function checkWorkLimit(amount) {
    return amount <= MAX_WORK;
}

function checkBegLimit(amount) {
    return amount <= MAX_BEG;
}

function checkCrimeLimit(amount) {
    return amount <= MAX_CRIME;
}

function checkHuntLimit(amount) {
    return amount <= MAX_HUNT;
}

function checkFishLimit(amount) {
    return amount <= MAX_FISH;
}

function checkDigLimit(amount) {
    return amount <= MAX_DIG;
}

function checkRobLimit(amount) {
    return amount <= MAX_ROB_STEAL;
}

function checkGambleLimit(amount) {
    return amount <= MAX_GAMBLE_BET;
}

function checkTradeLimit(amount) {
    return amount <= MAX_TRADE;
}

module.exports = {
    MAX_DAILY,
    MAX_WORK,
    MAX_BEG,
    MAX_CRIME,
    MAX_HUNT,
    MAX_FISH,
    MAX_DIG,
    MAX_ROB_STEAL,
    MAX_GAMBLE_BET,
    MAX_TRADE,
    checkDailyLimit,
    checkWorkLimit,
    checkBegLimit,
    checkCrimeLimit,
    checkHuntLimit,
    checkFishLimit,
    checkDigLimit,
    checkRobLimit,
    checkGambleLimit,
    checkTradeLimit
};
