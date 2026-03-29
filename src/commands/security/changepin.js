const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('changepin')
        .setDescription('Change your account PIN')
        .addIntegerOption(option => 
            option.setName('old_pin')
                .setDescription('Current PIN')
                .setRequired(true)
                .setMinValue(1000)
                .setMaxValue(9999))
        .addIntegerOption(option => 
            option.setName('new_pin')
                .setDescription('New 4-digit PIN')
                .setRequired(true)
                .setMinValue(1000)
                .setMaxValue(9999)),
    async execute(interaction) {
        const userId = interaction.user.id;
        const oldPin = interaction.options.getInteger('old_pin');
        const newPin = interaction.options.getInteger('new_pin');
        const userData = economy.getUser(userId);
        
        if (!userData.pin) {
            return interaction.reply({ content: '❌ You don\'t have a PIN set! Use /setpin first.', ephemeral: true });
        }
        
        if (!economy.verifyPin(userId, oldPin)) {
            return interaction.reply({ content: '❌ Invalid PIN!', ephemeral: true });
        }
        
        economy.setPin(userId, newPin);
        
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle('🔄 PIN Changed Successfully')
            .setDescription('Your PIN has been updated!');
        
        await interaction.reply({ embeds: [embed] });
    }
};
