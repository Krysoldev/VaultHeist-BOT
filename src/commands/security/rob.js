const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('rob')
        .setDescription('Attempt to rob another user')
        .addUserOption(option => 
            option.setName('target')
                .setDescription('User to rob')
                .setRequired(true))
        .addIntegerOption(option => 
            option.setName('pin')
                .setDescription('Your PIN (if set)')
                .setRequired(false)),
    async execute(interaction) {
        const userId = interaction.user.id;
        const target = interaction.options.getUser('target');
        const providedPin = interaction.options.getInteger('pin');
        const userData = economy.getUser(userId);
        const targetData = economy.getUser(target.id);
        
        if (userId === target.id) {
            return interaction.reply({ content: '❌ You cannot rob yourself!', ephemeral: true });
        }
        
        if (target.bot) {
            return interaction.reply({ content: '❌ You cannot rob bots!', ephemeral: true });
        }
        
        if (economy.isJailed(userId)) {
            return interaction.reply({ content: '⛓️ You are in jail! You cannot rob anyone.', ephemeral: true });
        }
        
        if (userData.pin && !economy.verifyPin(userId, providedPin)) {
            const attempts = (userData.pinAttempts || 0);
            if (attempts >= 3) {
                economy.setJail(userId, 30);
                economy.removeMoney(userId, 1000);
                return interaction.reply({ content: '🔒 You failed PIN verification 3 times! You have been jailed for 30 minutes and fined ₹1000!', ephemeral: true });
            }
            return interaction.reply({ content: `❌ Invalid PIN! You have ${3 - attempts} attempts remaining.`, ephemeral: true });
        }
        
        const now = Date.now();
        const cooldown = 30 * 60 * 1000;
        if (userData.lastRob && (now - userData.lastRob) < cooldown) {
            const remaining = cooldown - (now - userData.lastRob);
            const minutes = Math.ceil(remaining / (60 * 1000));
            return interaction.reply({ content: `⏰ You're being watched! Try again in ${minutes} minutes.`, ephemeral: true });
        }
        
        const success = Math.random() > 0.4;
        const maxSteal = Math.floor((targetData.balance + targetData.bank) * 0.2);
        const stealAmount = Math.floor(Math.random() * maxSteal) + 100;
        
        if (success && (targetData.balance + targetData.bank) >= stealAmount) {
            if (targetData.bank >= stealAmount) {
                economy.removeBank(target.id, stealAmount);
            } else {
                const remaining = stealAmount - targetData.bank;
                economy.removeBank(target.id, targetData.bank);
                economy.removeMoney(target.id, remaining);
            }
            economy.addMoney(userId, stealAmount);
            economy.updateUser(userId, { lastRob: now });
            
            const embed = new EmbedBuilder()
                .setColor(0x00ff00)
                .setTitle('🦹‍♂️ Robbery Successful!')
                .setDescription(`You successfully robbed ${target.username} and got **₹${stealAmount.toLocaleString()}**!`)
                .setFooter({ text: 'You can rob again in 30 minutes' });
            await interaction.reply({ embeds: [embed] });
        } else {
            const fine = Math.floor(Math.random() * 500) + 200;
            economy.removeMoney(userId, fine);
            economy.setJail(userId, 15);
            economy.updateUser(userId, { lastRob: now });
            
            const embed = new EmbedBuilder()
                .setColor(0xff0000)
                .setTitle('🚔 Robbery Failed!')
                .setDescription(`You got caught! You were fined **₹${fine}** and jailed for 15 minutes!`)
                .setFooter({ text: 'Better luck next time!' });
            await interaction.reply({ embeds: [embed] });
        }
    }
};
