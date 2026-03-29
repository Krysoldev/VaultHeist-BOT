const { SlashCommandBuilder, EmbedBuilder, ActionRowBuilder, ButtonBuilder, ButtonStyle } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('trade')
        .setDescription('Trade money with another user')
        .addUserOption(option => 
            option.setName('user')
                .setDescription('User to trade with')
                .setRequired(true))
        .addIntegerOption(option => 
            option.setName('amount')
                .setDescription('Amount to trade')
                .setRequired(true)),
    async execute(interaction) {
        const userId = interaction.user.id;
        const target = interaction.options.getUser('user');
        const amount = interaction.options.getInteger('amount');
        const userData = economy.getUser(userId);
        
        if (userId === target.id) {
            return interaction.reply({ content: '❌ You cannot trade with yourself!', ephemeral: true });
        }
        
        if (amount <= 0) {
            return interaction.reply({ content: '❌ Amount must be positive!', ephemeral: true });
        }
        
        if (userData.balance < amount) {
            return interaction.reply({ content: '❌ You don\'t have enough money!', ephemeral: true });
        }
        
        if (economy.isJailed(userId) || economy.isJailed(target.id)) {
            return interaction.reply({ content: '⛓️ One of you is in jail and cannot trade!', ephemeral: true });
        }
        
        const embed = new EmbedBuilder()
            .setColor(0x00ff00)
            .setTitle('💰 Trade Offer')
            .setDescription(`${interaction.user.username} wants to trade **₹${amount.toLocaleString()}** with ${target.username}`)
            .setFooter({ text: 'Click accept to complete the trade' });
        
        const row = new ActionRowBuilder()
            .addComponents(
                new ButtonBuilder()
                    .setCustomId(`trade_accept_${userId}_${target.id}_${amount}`)
                    .setLabel('Accept')
                    .setStyle(ButtonStyle.Success),
                new ButtonBuilder()
                    .setCustomId(`trade_decline_${userId}_${target.id}`)
                    .setLabel('Decline')
                    .setStyle(ButtonStyle.Danger)
            );
        
        await interaction.reply({ embeds: [embed], components: [row] });
        
        const filter = i => i.user.id === target.id;
        const collector = interaction.channel.createMessageComponentCollector({ filter, time: 60000, max: 1 });
        
        collector.on('collect', async i => {
            if (i.customId.startsWith('trade_accept')) {
                const senderData = economy.getUser(userId);
                const receiverData = economy.getUser(target.id);
                
                if (senderData.balance < amount) {
                    return i.reply({ content: '❌ Trade failed: Sender no longer has enough money!', ephemeral: true });
                }
                
                economy.removeMoney(userId, amount);
                economy.addMoney(target.id, amount);
                
                await i.update({ content: '✅ Trade completed successfully!', embeds: [], components: [] });
            } else {
                await i.update({ content: '❌ Trade declined!', embeds: [], components: [] });
            }
        });
        
        collector.on('end', collected => {
            if (collected.size === 0) {
                interaction.editReply({ content: '⏰ Trade request expired!', embeds: [], components: [] });
            }
        });
    }
};
