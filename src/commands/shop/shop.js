const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const { items } = require('../../utils/items');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('shop')
        .setDescription('View the shop items'),
    async execute(interaction) {
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle('🛒 VaultHeist Shop')
            .setDescription('Purchase items to enhance your experience!');
        
        for (const [id, item] of Object.entries(items)) {
            embed.addFields({
                name: `${item.name}`,
                value: `💰 Price: ₹${item.price}\n📝 ${item.description}\n🆔 ID: \`${id}\``,
                inline: true
            });
        }
        
        embed.setFooter({ text: 'Use /buy <item> <quantity> to purchase items' });
        await interaction.reply({ embeds: [embed] });
    }
};
