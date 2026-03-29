const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('setpin')
        .setDescription('Set a PIN for your account')
        .addIntegerOption(option => 
            option.setName('pin')
                .setDescription('4-digit PIN')
                .setRequired(true)
                .setMinValue(1000)
                .setMaxValue(9999)),
    async execute(interaction) {
        const userId = interaction.user.id;
        const pin = interaction.options.getInteger('pin');
        const userData = economy.getUser(userId);
        
        if (userData.pin) {
            return interaction.reply({ content: '❌ You already have a PIN set! Use /changepin to change it.', ephemeral: true });
        }
        
        economy.setPin(userId, pin);
        
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle('🔒 PIN Set Successfully')
            .setDescription('Your account is now protected! Remember your PIN for transactions.')
            .setFooter({ text: '⚠️ Never share your PIN with anyone!' });
        
        await interaction.reply({ embeds: [embed] });
    }
};
