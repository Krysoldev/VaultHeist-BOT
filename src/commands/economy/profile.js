const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('profile')
        .setDescription('View your economy profile')
        .addUserOption(option => 
            option.setName('user')
                .setDescription('User to view profile')),
    async execute(interaction) {
        const target = interaction.options.getUser('user') || interaction.user;
        const userData = economy.getUser(target.id);
        const rank = economy.getRank(target.id);
        const isJailed = economy.isJailed(target.id);
        
        const embed = new EmbedBuilder()
            .setColor(0x9b59b6)
            .setTitle(`${target.username}'s Profile`)
            .setThumbnail(target.displayAvatarURL())
            .addFields(
                { name: '💰 Wallet', value: `₹${userData.balance.toLocaleString()}`, inline: true },
                { name: '🏦 Bank', value: `₹${userData.bank.toLocaleString()}`, inline: true },
                { name: '💎 Total', value: `₹${(userData.balance + userData.bank).toLocaleString()}`, inline: true },
                { name: '📊 Rank', value: `#${rank}`, inline: true },
                { name: '🏆 Wins/Losses', value: `${userData.wins || 0}/${userData.losses || 0}`, inline: true },
                { name: '🔒 PIN', value: userData.pin ? '✅ Set' : '❌ Not Set', inline: true },
                { name: '⛓️ Status', value: isJailed ? '🚫 In Jail' : '✅ Free', inline: true },
                { name: '💰 Total Earned', value: `₹${(userData.totalEarned || 0).toLocaleString()}`, inline: true },
                { name: '💸 Total Spent', value: `₹${(userData.totalSpent || 0).toLocaleString()}`, inline: true }
            )
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
