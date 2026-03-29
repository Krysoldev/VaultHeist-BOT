const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('dice')
        .setDescription('Roll dice and bet on the outcome')
        .addIntegerOption(option => 
            option.setName('bet')
                .setDescription('Amount to bet')
                .setRequired(true))
        .addIntegerOption(option => 
            option.setName('number')
                .setDescription('Number to bet on (1-6)')
                .setRequired(true)
                .setMinValue(1)
                .setMaxValue(6)),
    async execute(interaction) {
        const userId = interaction.user.id;
        const bet = interaction.options.getInteger('bet');
        const number = interaction.options.getInteger('number');
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
        
        const roll = Math.floor(Math.random() * 6) + 1;
        const won = roll === number;
        const winnings = won ? bet * 5 : 0;
        
        if (won) {
            economy.addMoney(userId, winnings);
        } else {
            economy.removeMoney(userId, bet);
        }
        
        const embed = new EmbedBuilder()
            .setColor(won ? 0x00ff00 : 0xff0000)
            .setTitle('🎲 Dice Roll')
            .setDescription(`The dice rolled a **${roll}**!`)
            .addFields(
                { name: 'Your Bet', value: `${number}`, inline: true },
                { name: 'Bet Amount', value: `₹${bet.toLocaleString()}`, inline: true },
                { name: 'Result', value: won ? `✅ You won ₹${winnings.toLocaleString()}!` : `❌ You lost ₹${bet.toLocaleString()}!`, inline: true }
            )
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
