const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('bail')
        .setDescription('Pay to get out of jail early'),
    async execute(interaction) {
        const userId = interaction.user.id;
        const userData = economy.getUser(userId);
        
        if (!economy.isJailed(userId)) {
            return interaction.reply({ content: '✅ You are not in jail!', ephemeral: true });
        }
        
        const bailAmount = 500;
        if (userData.balance < bailAmount) {
            return interaction.reply({ content: `❌ You need ₹${bailAmount} to bail out!`, ephemeral: true });
        }
        
        economy.removeMoney(userId, bailAmount);
        economy.updateUser(userId, { jailedUntil: 0 });
        
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle('🔓 Bail Paid!')
            .setDescription(`You paid **₹${bailAmount}** and are now free!`);
        
        await interaction.reply({ embeds: [embed] });
    }
};
