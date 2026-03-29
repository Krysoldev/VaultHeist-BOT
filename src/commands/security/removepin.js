const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('removepin')
        .setDescription('Remove PIN from your account')
        .addIntegerOption(option => 
            option.setName('pin')
                .setDescription('Current PIN')
                .setRequired(true)
                .setMinValue(1000)
                .setMaxValue(9999)),
    async execute(interaction) {
        const userId = interaction.user.id;
        const pin = interaction.options.getInteger('pin');
        const userData = economy.getUser(userId);
        
        if (!userData.pin) {
            return interaction.reply({ content: '❌ You don\'t have a PIN set!', ephemeral: true });
        }
        
        if (!economy.verifyPin(userId, pin)) {
            return interaction.reply({ content: '❌ Invalid PIN!', ephemeral: true });
        }
        
        economy.updateUser(userId, { pin: null });
        
        const embed = new EmbedBuilder()
            .setColor(0xff0000)
            .setTitle('🔓 PIN Removed')
            .setDescription('Your account no longer has PIN protection.');
        
        await interaction.reply({ embeds: [embed] });
    }
};
