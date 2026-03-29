const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('fish')
        .setDescription('Go fishing for rewards'),
    async execute(interaction) {
        const userId = interaction.user.id;
        const userData = economy.getUser(userId);
        const now = Date.now();
        const cooldown = 15 * 60 * 1000;
        
        if (userData.lastFish && (now - userData.lastFish) < cooldown) {
            const remaining = cooldown - (now - userData.lastFish);
            const minutes = Math.ceil(remaining / (60 * 1000));
            return interaction.reply({ content: `⏰ The fish need time to repopulate! Try again in ${minutes} minutes.`, ephemeral: true });
        }
        
        if (economy.isJailed(userId)) {
            return interaction.reply({ content: '⛓️ You are in jail! You cannot fish.', ephemeral: true });
        }
        
        const fish = [
            { name: '🐟 Small Fish', reward: 30, chance: 0.5 },
            { name: '🐠 Medium Fish', reward: 70, chance: 0.3 },
            { name: '🐡 Large Fish', reward: 150, chance: 0.15 },
            { name: '🦈 Shark', reward: 500, chance: 0.05 }
        ];
        
        const random = Math.random();
        let cumulative = 0;
        let caught = null;
        
        for (const f of fish) {
            cumulative += f.chance;
            if (random < cumulative) {
                caught = f;
                break;
            }
        }
        
        if (caught) {
            economy.addMoney(userId, caught.reward);
            const embed = new EmbedBuilder()
                .setColor(0x00ff00)
                .setTitle('🎣 Fishing Success!')
                .setDescription(`You caught a ${caught.name} and earned **₹${caught.reward}**!`);
            await interaction.reply({ embeds: [embed] });
        } else {
            const embed = new EmbedBuilder()
                .setColor(0xff0000)
                .setTitle('🎣 Fishing Failed')
                .setDescription('You didn\'t catch anything... Try a different spot next time!');
            await interaction.reply({ embeds: [embed] });
        }
        
        economy.updateUser(userId, { lastFish: now });
    }
};
