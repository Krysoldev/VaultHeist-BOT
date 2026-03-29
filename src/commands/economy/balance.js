const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('balance')
        .setDescription('Check your balance or someone else\'s')
        .addUserOption(option => 
            option.setName('user')
                .setDescription('User to check balance for')),
    async execute(interaction) {
        const target = interaction.options.getUser('user') || interaction.user;
        const userData = economy.getUser(target.id);
        
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle(`${target.username}'s Balance`)
            .addFields(
                { name: '💰 Wallet', value: `₹${userData.balance.toLocaleString()}`, inline: true },
                { name: '🏦 Bank', value: `₹${userData.bank.toLocaleString()}`, inline: true },
                { name: '💎 Total Net Worth', value: `₹${(userData.balance + userData.bank).toLocaleString()}`, inline: true }
            )
            .setTimestamp()
            .setFooter({ text: 'VaultHeist Economy Bot' });
        
        await interaction.reply({ embeds: [embed] });
    }
};
