const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

const crimes = [
    { name: 'pickpocket', reward: 100, risk: 50, jailTime: 10 },
    { name: 'rob a store', reward: 500, risk: 200, jailTime: 20 },
    { name: 'hack a bank', reward: 2000, risk: 1000, jailTime: 60 },
    { name: 'steal a car', reward: 1000, risk: 500, jailTime: 30 },
    { name: 'burglary', reward: 800, risk: 400, jailTime: 25 }
];

module.exports = {
    data: new SlashCommandBuilder()
        .setName('crime')
        .setDescription('Commit a crime for money (with risk)'),
    async execute(interaction) {
        const userId = interaction.user.id;
        const userData = economy.getUser(userId);
        const now = Date.now();
        const cooldown = 10 * 60 * 1000;
        
        if (userData.lastCrime && (now - userData.lastCrime) < cooldown) {
            const remaining = cooldown - (now - userData.lastCrime);
            const minutes = Math.ceil(remaining / (60 * 1000));
            return interaction.reply({ content: `⏰ You're still lying low! Try again in ${minutes} minutes.`, ephemeral: true });
        }
        
        if (economy.isJailed(userId)) {
            return interaction.reply({ content: '⛓️ You are in jail! You cannot commit crimes.', ephemeral: true });
        }
        
        const crime = crimes[Math.floor(Math.random() * crimes.length)];
        const success = Math.random() > 0.4;
        
        let embed;
        if (success) {
            economy.addMoney(userId, crime.reward);
            embed = new EmbedBuilder()
                .setColor(0x00ff00)
                .setTitle('🦹‍♂️ Crime Successful!')
                .setDescription(`You successfully committed ${crime.name} and got **₹${crime.reward}**!`)
                .setFooter({ text: 'Don\'t get caught next time!' });
        } else {
            economy.removeMoney(userId, crime.risk);
            economy.setJail(userId, crime.jailTime);
            embed = new EmbedBuilder()
                .setColor(0xff0000)
                .setTitle('🚔 Crime Failed!')
                .setDescription(`You got caught ${crime.name}! You were fined **₹${crime.risk}** and jailed for ${crime.jailTime} minutes!`);
        }
        
        economy.updateUser(userId, { lastCrime: now });
        await interaction.reply({ embeds: [embed] });
    }
};
