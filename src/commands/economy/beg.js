const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('beg')
        .setDescription('Beg for money'),
    async execute(interaction) {
        const userId = interaction.user.id;
        const userData = economy.getUser(userId);
        const now = Date.now();
        const cooldown = 5 * 60 * 1000;
        
        if (userData.lastBeg && (now - userData.lastBeg) < cooldown) {
            const remaining = cooldown - (now - userData.lastBeg);
            const minutes = Math.ceil(remaining / (60 * 1000));
            return interaction.reply({ content: `⏰ You've already begged recently! Try again in ${minutes} minutes.`, ephemeral: true });
        }
        
        const success = Math.random() > 0.3;
        let amount = 0;
        let message = '';
        
        if (success) {
            amount = Math.floor(Math.random() * 50) + 10;
            economy.addMoney(userId, amount);
            message = `Someone felt generous and gave you **₹${amount}**! 🎉`;
        } else {
            message = `Nobody gave you anything... Better luck next time! 😢`;
        }
        
        economy.updateUser(userId, { lastBeg: now });
        
        const embed = new EmbedBuilder()
            .setColor(success ? 0x00ff00 : 0xff0000)
            .setTitle('🫴 Begging')
            .setDescription(message)
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
