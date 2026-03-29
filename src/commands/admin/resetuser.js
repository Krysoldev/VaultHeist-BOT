const { SlashCommandBuilder, EmbedBuilder, PermissionFlagsBits } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('resetuser')
        .setDescription('Reset a user\'s data (Admin only)')
        .addUserOption(option => 
            option.setName('user')
                .setDescription('User to reset')
                .setRequired(true))
        .setDefaultMemberPermissions(PermissionFlagsBits.Administrator),
    async execute(interaction) {
        const target = interaction.options.getUser('user');
        
        economy.updateUser(target.id, {
            balance: 0,
            bank: 0,
            pin: null,
            pinAttempts: 0,
            jailedUntil: 0,
            inventory: [],
            totalEarned: 0,
            totalSpent: 0,
            lastDaily: 0,
            lastWork: 0,
            lastBeg: 0,
            lastCrime: 0,
            lastHunt: 0,
            lastFish: 0,
            lastDig: 0,
            lastRob: 0,
            lastFight: 0,
            blacklisted: false,
            wins: 0,
            losses: 0
        });
        
        const embed = new EmbedBuilder()
            .setColor(0xff0000)
            .setTitle('🔄 User Reset')
            .setDescription(`${target.username}'s data has been reset!`);
        
        await interaction.reply({ embeds: [embed] });
        
        console.log(`[ADMIN] ${interaction.user.tag} reset ${target.tag}`);
    }
};
