const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('help')
        .setDescription('Get help with all commands')
        .addStringOption(option => 
            option.setName('command')
                .setDescription('Get help for a specific command')
                .setRequired(false)),
    async execute(interaction) {
        const commandName = interaction.options.getString('command');
        
        if (commandName) {
            const command = interaction.client.commands.get(commandName);
            if (!command) {
                return interaction.reply({ content: '❌ Command not found!', ephemeral: true });
            }
            
            const embed = new EmbedBuilder()
                .setColor(0x00ff00)
                .setTitle(`📖 Help: /${command.data.name}`)
                .setDescription(command.data.description)
                .addFields({ name: 'Usage', value: `/${command.data.name} ${command.data.options.map(opt => `<${opt.name}>`).join(' ')}`, inline: false });
            
            return interaction.reply({ embeds: [embed] });
        }
        
        const categories = {
            '💰 Economy': ['balance', 'daily', 'work', 'beg', 'profile', 'leaderboard', 'rank'],
            '🏦 Banking': ['deposit', 'withdraw', 'bank', 'interest'],
            '🎲 Gambling': ['coinflip', 'slots', 'dice'],
            '🦹‍♂️ Robbery & Security': ['rob', 'bail', 'setpin', 'changepin', 'removepin'],
            '🛍️ Shop': ['shop', 'buy', 'sell', 'inventory'],
            '🎣 Fun': ['crime', 'hunt', 'fish', 'dig'],
            '⚔️ PvP': ['fight'],
            '🤝 Trading': ['trade'],
            '👑 Admin': ['addmoney', 'removemoney', 'resetuser', 'blacklist']
        };
        
        const embed = new EmbedBuilder()
            .setColor(0x9b59b6)
            .setTitle('🎮 VaultHeist Commands')
            .setDescription('Here are all available commands:')
            .setFooter({ text: 'Use /help <command> for detailed info' });
        
        for (const [category, commands] of Object.entries(categories)) {
            embed.addFields({
                name: category,
                value: commands.map(cmd => `\`/${cmd}\``).join(', '),
                inline: false
            });
        }
        
        await interaction.reply({ embeds: [embed] });
    }
};
