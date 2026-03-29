const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('slots')
        .setDescription('Play slots and try your luck')
        .addIntegerOption(option => 
            option.setName('bet')
                .setDescription('Amount to bet')
                .setRequired(true)),
    async execute(interaction) {
        const userId = interaction.user.id;
        const bet = interaction.options.getInteger('bet');
        const userData = economy.getUser(userId);
        
        if (bet <= 0) {
            return interaction.reply({ content: '❌ Bet must be positive!', ephemeral: true });
        }
        
        if (userData.balance < bet) {
            return interaction.reply({ content: '❌ You don\'t have enough money!', ephemeral: true });
        }
        
        if (economy.isJailed(userId)) {
            return interaction.reply({ content: '⛓️ You are in jail and cannot gamble!', ephemeral: true });
        }
        
        const slots = ['🍒', '🍊', '🍋', '🍉', '⭐', '💎'];
        const result = [
            slots[Math.floor(Math.random() * slots.length)],
            slots[Math.floor(Math.random() * slots.length)],
            slots[Math.floor(Math.random() * slots.length)]
        ];
        
        let multiplier = 0;
        if (result[0] === result[1] && result[1] === result[2]) {
            multiplier = 5;
        } else if (result[0] === result[1] || result[1] === result[2] || result[0] === result[2]) {
            multiplier = 2;
        } else {
            multiplier = 0;
        }
        
        const winnings = bet * multiplier;
        
        if (winnings > 0) {
            economy.addMoney(userId, winnings);
        } else {
            economy.removeMoney(userId, bet);
        }
        
        const embed = new EmbedBuilder()
            .setColor(winnings > 0 ? 0x00ff00 : 0xff0000)
            .setTitle('🎰 Slots')
            .setDescription(`${result.join(' | ')}`)
            .addFields(
                { name: 'Bet', value: `₹${bet.toLocaleString()}`, inline: true },
                { name: 'Multiplier', value: `${multiplier}x`, inline: true },
                { name: 'Result', value: winnings > 0 ? `✅ You won ₹${winnings.toLocaleString()}!` : `❌ You lost ₹${bet.toLocaleString()}!`, inline: true }
            )
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
