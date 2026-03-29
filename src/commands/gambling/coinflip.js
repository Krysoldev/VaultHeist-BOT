const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('coinflip')
        .setDescription('Flip a coin and bet on the outcome')
        .addStringOption(option => 
            option.setName('choice')
                .setDescription('Heads or Tails')
                .setRequired(true)
                .addChoices(
                    { name: 'Heads', value: 'heads' },
                    { name: 'Tails', value: 'tails' }
                ))
        .addIntegerOption(option => 
            option.setName('bet')
                .setDescription('Amount to bet')
                .setRequired(true)),
    async execute(interaction) {
        const userId = interaction.user.id;
        const choice = interaction.options.getString('choice');
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
        
        const result = Math.random() < 0.5 ? 'heads' : 'tails';
        const won = choice === result;
        const winnings = won ? bet * 2 : 0;
        
        if (won) {
            economy.addMoney(userId, winnings);
        } else {
            economy.removeMoney(userId, bet);
        }
        
        const embed = new EmbedBuilder()
            .setColor(won ? 0x00ff00 : 0xff0000)
            .setTitle('🪙 Coin Flip')
            .setDescription(`The coin landed on **${result.toUpperCase()}**!`)
            .addFields(
                { name: 'Your Choice', value: choice.toUpperCase(), inline: true },
                { name: 'Bet', value: `₹${bet.toLocaleString()}`, inline: true },
                { name: 'Result', value: won ? `✅ You won ₹${winnings.toLocaleString()}!` : `❌ You lost ₹${bet.toLocaleString()}!`, inline: true }
            )
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
