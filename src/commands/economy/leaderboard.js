const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('leaderboard')
        .setDescription('View the richest users'),
    async execute(interaction) {
        const users = economy.loadUsers();
        const sorted = Object.entries(users)
            .filter(([_, data]) => !data.blacklisted)
            .sort((a, b) => (b[1].balance + b[1].bank) - (a[1].balance + a[1].bank))
            .slice(0, 10);
        
        if (sorted.length === 0) {
            return interaction.reply({ content: 'No users found!', ephemeral: true });
        }
        
        const embed = new EmbedBuilder()
            .setColor(0xffd700)
            .setTitle('🏆 Wealth Leaderboard')
            .setDescription('Top 10 richest users');
        
        for (let i = 0; i < sorted.length; i++) {
            const [userId, data] = sorted[i];
            const user = await interaction.client.users.fetch(userId).catch(() => null);
            const total = data.balance + data.bank;
            embed.addFields({
                name: `${i + 1}. ${user ? user.username : 'Unknown User'}`,
                value: `💰 ₹${total.toLocaleString()}\n🏦 Bank: ₹${data.bank.toLocaleString()}`,
                inline: false
            });
        }
        
        await interaction.reply({ embeds: [embed] });
    }
};
