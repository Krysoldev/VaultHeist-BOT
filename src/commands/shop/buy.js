const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');
const { items } = require('../../utils/items');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('buy')
        .setDescription('Buy an item from the shop')
        .addStringOption(option => 
            option.setName('item')
                .setDescription('Item ID to buy')
                .setRequired(true))
        .addIntegerOption(option => 
            option.setName('quantity')
                .setDescription('Quantity to buy')
                .setRequired(false)
                .setMinValue(1)),
    async execute(interaction) {
        const userId = interaction.user.id;
        const itemId = interaction.options.getString('item');
        const quantity = interaction.options.getInteger('quantity') || 1;
        const userData = economy.getUser(userId);
        
        if (!items[itemId]) {
            return interaction.reply({ content: '❌ Invalid item ID! Use /shop to see available items.', ephemeral: true });
        }
        
        const item = items[itemId];
        const totalCost = item.price * quantity;
        
        if (userData.balance < totalCost) {
            return interaction.reply({ content: `❌ You need ₹${totalCost.toLocaleString()} to buy ${quantity}x ${item.name}!`, ephemeral: true });
        }
        
        economy.removeMoney(userId, totalCost);
        economy.addToInventory(userId, itemId, quantity);
        
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle('🛍️ Purchase Successful!')
            .setDescription(`You bought **${quantity}x ${item.name}** for **₹${totalCost.toLocaleString()}**!`)
            .setFooter({ text: 'Check your inventory with /inventory' });
        
        await interaction.reply({ embeds: [embed] });
    }
};
