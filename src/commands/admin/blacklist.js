const { SlashCommandBuilder, EmbedBuilder, PermissionFlagsBits } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('blacklist')
        .setDescription('Blacklist or unblacklist a user (Admin only)')
        .addUserOption(option => 
            option.setName('user')
                .setDescription('User to blacklist/unblacklist')
                .setRequired(true))
        .setDefaultMemberPermissions(PermissionFlagsBits.Administrator),
    async execute(interaction) {
        const target = interaction.options.getUser('user');
        const userData = economy.getUser(target.id);
        const newStatus = !userData.blacklisted;
        
        economy.updateUser(target.id, { blacklisted: newStatus });
        
        const embed = new EmbedBuilder()
            .setColor(newStatus ? 0xff0000 : 0x00ff00)
            .setTitle(newStatus ? '⛔ User Blacklisted' : '✅ User Unblacklisted')
            .setDescription(`${target.username} has been ${newStatus ? 'blacklisted' : 'removed from blacklist'}!`);
        
        await interaction.reply({ embeds: [embed] });
        
        console.log(`[ADMIN] ${interaction.user.tag} ${newStatus ? 'blacklisted' : 'unblacklisted'} ${target.tag}`);
    }
};
