const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('interest')
        .setDescription('Claim interest on your bank balance'),
    async execute(interaction) {
        const userId = interaction.user.id;
        const userData = economy.getUser(userId);
        const now = Date.now();
        const cooldown = 24 * 60 * 60 * 1000;
        
        if (userData.lastInterest && (now - userData.lastInterest) < cooldown) {
            const remaining = cooldown - (now - userData.lastInterest);
            const hours = Math.floor(remaining / (60 * 60 * 1000));
            return interaction.reply({ content: `⏰ Interest available in ${hours} hours!`, ephemeral: true });
        }
        
        const interest = Math.floor(userData.bank * 0.05);
        if (interest === 0) {
            return interaction.reply({ content: '💡 You need at least ₹1 in your bank to earn interest!', ephemeral: true });
        }
        
        economy.addBank(userId, interest);
        economy.updateUser(userId, { lastInterest: now });
        
        const embed = new EmbedBuilder()
            .setColor(0xffd700)
            .setTitle('📈 Interest Earned!')
            .setDescription(`You earned **₹${interest.toLocaleString()}** in interest!`)
            .addFields(
                { name: '🏦 New Bank Balance', value: `₹${(userData.bank + interest).toLocaleString()}`, inline: true }
            )
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
