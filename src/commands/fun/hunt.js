const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('hunt')
        .setDescription('Go hunting for rewards'),
    async execute(interaction) {
        const userId = interaction.user.id;
        const userData = economy.getUser(userId);
        const now = Date.now();
        const cooldown = 30 * 60 * 1000;
        
        if (userData.lastHunt && (now - userData.lastHunt) < cooldown) {
            const remaining = cooldown - (now - userData.lastHunt);
            const minutes = Math.ceil(remaining / (60 * 1000));
            return interaction.reply({ content: `⏰ You need to rest! Try again in ${minutes} minutes.`, ephemeral: true });
        }
        
        if (economy.isJailed(userId)) {
            return interaction.reply({ content: '⛓️ You are in jail! You cannot hunt.', ephemeral: true });
        }
        
        const animals = [
            { name: '🐇 Rabbit', reward: 50, chance: 0.4 },
            { name: '🦊 Fox', reward: 100, chance: 0.3 },
            { name: '🐗 Boar', reward: 200, chance: 0.2 },
            { name: '🦌 Deer', reward: 300, chance: 0.1 }
        ];
        
        const random = Math.random();
        let cumulative = 0;
        let caught = null;
        
        for (const animal of animals) {
            cumulative += animal.chance;
            if (random < cumulative) {
                caught = animal;
                break;
            }
        }
        
        if (caught) {
            economy.addMoney(userId, caught.reward);
            const embed = new EmbedBuilder()
                .setColor(0x00ff00)
                .setTitle('🏹 Hunt Successful!')
                .setDescription(`You caught a ${caught.name} and earned **₹${caught.reward}**!`);
            await interaction.reply({ embeds: [embed] });
        } else {
            const embed = new EmbedBuilder()
                .setColor(0xff0000)
                .setTitle('🏹 Hunt Failed')
                .setDescription('You didn\'t catch anything today... Better luck next time!');
            await interaction.reply({ embeds: [embed] });
        }
        
        economy.updateUser(userId, { lastHunt: now });
    }
};
