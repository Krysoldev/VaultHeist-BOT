const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('daily')
        .setDescription('Claim your daily reward'),
    async execute(interaction) {
        const userId = interaction.user.id;
        const userData = economy.getUser(userId);
        const now = Date.now();
        const cooldown = 24 * 60 * 60 * 1000;
        
        if (userData.lastDaily && (now - userData.lastDaily) < cooldown) {
            const remaining = cooldown - (now - userData.lastDaily);
            const hours = Math.floor(remaining / (60 * 60 * 1000));
            const minutes = Math.floor((remaining % (60 * 60 * 1000)) / (60 * 1000));
            return interaction.reply({ content: `⏰ You've already claimed your daily reward! Come back in ${hours}h ${minutes}m.`, ephemeral: true });
        }
        
        const amount = 500 + Math.floor(Math.random() * 500);
        economy.addMoney(userId, amount);
        economy.updateUser(userId, { lastDaily: now });
        
        const embed = new EmbedBuilder()
            .setColor(0xffd700)
            .setTitle('🎁 Daily Reward!')
            .setDescription(`You received **₹${amount.toLocaleString()}**!`)
            .setFooter({ text: 'Come back tomorrow for more!' })
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
