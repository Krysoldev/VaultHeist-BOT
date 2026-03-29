const { SlashCommandBuilder, EmbedBuilder, PermissionFlagsBits } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('addmoney')
        .setDescription('Add money to a user (Admin only)')
        .addUserOption(option => 
            option.setName('user')
                .setDescription('User to add money to')
                .setRequired(true))
        .addIntegerOption(option => 
            option.setName('amount')
                .setDescription('Amount to add')
                .setRequired(true))
        .setDefaultMemberPermissions(PermissionFlagsBits.Administrator),
    async execute(interaction) {
        const target = interaction.options.getUser('user');
        const amount = interaction.options.getInteger('amount');
        
        if (amount <= 0) {
            return interaction.reply({ content: '❌ Amount must be positive!', ephemeral: true });
        }
        
        economy.addMoney(target.id, amount);
        
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle('💰 Money Added')
            .setDescription(`Added **₹${amount.toLocaleString()}** to ${target.username}'s wallet!`);
        
        await interaction.reply({ embeds: [embed] });
        
        console.log(`[ADMIN] ${interaction.user.tag} added ₹${amount} to ${target.tag}`);
    }
};
