const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('bank')
        .setDescription('View your bank information'),
    async execute(interaction) {
        const userId = interaction.user.id;
        const userData = economy.getUser(userId);
        
        const embed = new EmbedBuilder()
            .setColor(0x3498db)
            .setTitle('🏦 Bank Account')
            .addFields(
                { name: '💰 Current Balance', value: `₹${userData.bank.toLocaleString()}`, inline: true },
                { name: '💎 Wallet', value: `₹${userData.balance.toLocaleString()}`, inline: true },
                { name: '💵 Total Wealth', value: `₹${(userData.balance + userData.bank).toLocaleString()}`, inline: true }
            )
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
