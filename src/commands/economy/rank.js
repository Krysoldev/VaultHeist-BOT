const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('rank')
        .setDescription('Check your rank on the leaderboard')
        .addUserOption(option => 
            option.setName('user')
                .setDescription('User to check rank')),
    async execute(interaction) {
        const target = interaction.options.getUser('user') || interaction.user;
        const rank = economy.getRank(target.id);
        const userData = economy.getUser(target.id);
        const total = userData.balance + userData.bank;
        
        const embed = new EmbedBuilder()
            .setColor(0x9b59b6)
            .setTitle(`${target.username}'s Rank`)
            .addFields(
                { name: '📊 Rank', value: `#${rank}`, inline: true },
                { name: '💰 Total Wealth', value: `₹${total.toLocaleString()}`, inline: true },
                { name: '👥 Total Users', value: `${Object.keys(economy.loadUsers()).length}`, inline: true }
            )
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
