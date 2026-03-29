const { SlashCommandBuilder, EmbedBuilder, PermissionFlagsBits } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('removemoney')
        .setDescription('Remove money from a user (Admin only)')
        .addUserOption(option => 
            option.setName('user')
                .setDescription('User to remove money from')
                .setRequired(true))
        .addIntegerOption(option => 
            option.setName('amount')
                .setDescription('Amount to remove')
                .setRequired(true))
        .setDefaultMemberPermissions(PermissionFlagsBits.Administrator),
    async execute(interaction) {
        const target = interaction.options.getUser('user');
        const amount = interaction.options.getInteger('amount');
        
        if (amount <= 0) {
            return interaction.reply({ content: '❌ Amount must be positive!', ephemeral: true });
        }
        
        const success = economy.removeMoney(target.id, amount);
        
        if (!success) {
            return interaction.reply({ content: '❌ User doesn\'t have enough money!', ephemeral: true });
        }
        
        const embed = new EmbedBuilder()
            .setColor(0xff0000)
            .setTitle('💰 Money Removed')
            .setDescription(`Removed **₹${amount.toLocaleString()}** from ${target.username}'s wallet!`);
        
        await interaction.reply({ embeds: [embed] });
        
        console.log(`[ADMIN] ${interaction.user.tag} removed ₹${amount} from ${target.tag}`);
    }
};
