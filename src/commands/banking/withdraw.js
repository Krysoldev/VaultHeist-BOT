const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('withdraw')
        .setDescription('Withdraw money from your bank')
        .addIntegerOption(option => 
            option.setName('amount')
                .setDescription('Amount to withdraw')
                .setRequired(true)),
    async execute(interaction) {
        const userId = interaction.user.id;
        let amount = interaction.options.getInteger('amount');
        const userData = economy.getUser(userId);
        
        if (amount === -1) amount = userData.bank;
        
        if (amount <= 0) {
            return interaction.reply({ content: '❌ Please enter a valid amount!', ephemeral: true });
        }
        
        if (userData.bank < amount) {
            return interaction.reply({ content: '❌ You don\'t have enough money in your bank!', ephemeral: true });
        }
        
        economy.removeBank(userId, amount);
        economy.addMoney(userId, amount);
        
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle('💵 Withdrawal Successful')
            .setDescription(`You withdrew **₹${amount.toLocaleString()}** from your bank!`)
            .addFields(
                { name: '💰 New Wallet Balance', value: `₹${(userData.balance + amount).toLocaleString()}`, inline: true },
                { name: '🏦 New Bank Balance', value: `₹${(userData.bank - amount).toLocaleString()}`, inline: true }
            )
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
