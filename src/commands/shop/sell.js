const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');
const { items } = require('../../utils/items');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('sell')
        .setDescription('Sell an item from your inventory')
        .addStringOption(option => 
            option.setName('item')
                .setDescription('Item ID to sell')
                .setRequired(true))
        .addIntegerOption(option => 
            option.setName('quantity')
                .setDescription('Quantity to sell')
                .setRequired(false)
                .setMinValue(1)),
    async execute(interaction) {
        const userId = interaction.user.id;
        const itemId = interaction.options.getString('item');
        const quantity = interaction.options.getInteger('quantity') || 1;
        const inventory = economy.getInventory(userId);
        
        if (!items[itemId]) {
            return interaction.reply({ content: '❌ Invalid item ID!', ephemeral: true });
        }
        
        const inventoryItem = inventory.find(i => i.id === itemId);
        if (!inventoryItem || inventoryItem.quantity < quantity) {
            return interaction.reply({ content: `❌ You don't have ${quantity}x ${items[itemId].name}!`, ephemeral: true });
        }
        
        const item = items[itemId];
        const totalPrice = item.sellPrice * quantity;
        
        economy.removeFromInventory(userId, itemId, quantity);
        economy.addMoney(userId, totalPrice);
        
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle('💰 Sale Successful!')
            .setDescription(`You sold **${quantity}x ${item.name}** for **₹${totalPrice.toLocaleString()}**!`);
        
        await interaction.reply({ embeds: [embed] });
    }
};
