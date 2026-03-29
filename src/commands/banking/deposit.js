const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('deposit')
        .setDescription('Deposit money into your bank')
        .addIntegerOption(option => 
            option.setName('amount')
                .setDescription('Amount to deposit')
                .setRequired(true)),
    async execute(interaction) {
        const userId = interaction.user.id;
        let amount = interaction.options.getInteger('amount');
        const userData = economy.getUser(userId);
        
        if (amount === -1) amount = userData.balance;
        
        if (amount <= 0) {
            return interaction.reply({ content: '❌ Please enter a valid amount!', ephemeral: true });
        }
        
        if (userData.balance < amount) {
            return interaction.reply({ content: '❌ You don\'t have enough money in your wallet!', ephemeral: true });
        }
        
        economy.removeMoney(userId, amount);
        economy.addBank(userId, amount);
        
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle('🏦 Deposit Successful')
            .setDescription(`You deposited **₹${amount.toLocaleString()}** into your bank!`)
            .addFields(
                { name: '💰 New Wallet Balance', value: `₹${(userData.balance - amount).toLocaleString()}`, inline: true },
                { name: '🏦 New Bank Balance', value: `₹${(userData.bank + amount).toLocaleString()}`, inline: true }
            )
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
