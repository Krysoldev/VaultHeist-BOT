const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');
const { items } = require('../../utils/items');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('inventory')
        .setDescription('View your inventory'),
    async execute(interaction) {
        const userId = interaction.user.id;
        const inventory = economy.getInventory(userId);
        
        if (inventory.length === 0) {
            return interaction.reply({ content: '📦 Your inventory is empty! Visit the shop with /shop.', ephemeral: true });
        }
        
        const embed = new EmbedBuilder()
            .setColor(0x9b59b6)
            .setTitle('📦 Inventory')
            .setDescription('Your collected items:');
        
        for (const item of inventory) {
            const itemData = items[item.id];
            embed.addFields({
                name: `${itemData.name} x${item.quantity}`,
                value: `💰 Sell price: ₹${itemData.sellPrice} each\n📝 ${itemData.description}`,
                inline: true
            });
        }
        
        await interaction.reply({ embeds: [embed] });
    }
};
