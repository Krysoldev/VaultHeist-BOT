const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

const jobs = [
    { name: 'Software Developer', pay: 200, min: 150, max: 300 },
    { name: 'Cashier', pay: 100, min: 80, max: 150 },
    { name: 'Doctor', pay: 400, min: 300, max: 500 },
    { name: 'Teacher', pay: 250, min: 200, max: 350 },
    { name: 'Chef', pay: 180, min: 120, max: 250 }
];

module.exports = {
    data: new SlashCommandBuilder()
        .setName('work')
        .setDescription('Work to earn money'),
    async execute(interaction) {
        const userId = interaction.user.id;
        const userData = economy.getUser(userId);
        const now = Date.now();
        const cooldown = 30 * 60 * 1000;
        
        if (userData.lastWork && (now - userData.lastWork) < cooldown) {
            const remaining = cooldown - (now - userData.lastWork);
            const minutes = Math.ceil(remaining / (60 * 1000));
            return interaction.reply({ content: `⏰ You need to rest! Come back in ${minutes} minutes.`, ephemeral: true });
        }
        
        const job = jobs[Math.floor(Math.random() * jobs.length)];
        const amount = Math.floor(Math.random() * (job.max - job.min + 1) + job.min);
        economy.addMoney(userId, amount);
        economy.updateUser(userId, { lastWork: now });
        
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle('💼 Work Complete!')
            .setDescription(`You worked as a **${job.name}** and earned **₹${amount.toLocaleString()}**!`)
            .setFooter({ text: 'You can work again in 30 minutes' })
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
