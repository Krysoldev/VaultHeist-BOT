const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('dig')
        .setDescription('Dig for treasure'),
    async execute(interaction) {
        const userId = interaction.user.id;
        const userData = economy.getUser(userId);
        const now = Date.now();
        const cooldown = 20 * 60 * 1000;
        
        if (userData.lastDig && (now - userData.lastDig) < cooldown) {
            const remaining = cooldown - (now - userData.lastDig);
            const minutes = Math.ceil(remaining / (60 * 1000));
            return interaction.reply({ content: `⏰ The ground needs to settle! Try again in ${minutes} minutes.`, ephemeral: true });
        }
        
        if (economy.isJailed(userId)) {
            return interaction.reply({ content: '⛓️ You are in jail! You cannot dig.', ephemeral: true });
        }
        
        const treasures = [
            { name: '💎 Diamond', reward: 1000, chance: 0.02 },
            { name: '💰 Gold Coin', reward: 500, chance: 0.05 },
            { name: '🪙 Silver Coin', reward: 200, chance: 0.1 },
            { name: '⚱️ Old Pot', reward: 50, chance: 0.3 },
            { name: '🪨 Rock', reward: 0, chance: 0.53 }
        ];
        
        const random = Math.random();
        let cumulative = 0;
        let found = null;
        
        for (const treasure of treasures) {
            cumulative += treasure.chance;
            if (random < cumulative) {
                found = treasure;
                break;
            }
        }
        
        if (found && found.reward > 0) {
            economy.addMoney(userId, found.reward);
            const embed = new EmbedBuilder()
                .setColor(0x00ff00)
                .setTitle('⛏️ Treasure Found!')
                .setDescription(`You dug up ${found.name} and earned **₹${found.reward}**!`);
            await interaction.reply({ embeds: [embed] });
        } else {
            const embed = new EmbedBuilder()
                .setColor(0xff0000)
                .setTitle('⛏️ Nothing Found')
                .setDescription('You dug for hours but found nothing but dirt...');
            await interaction.reply({ embeds: [embed] });
        }
        
        economy.updateUser(userId, { lastDig: now });
    }
};
