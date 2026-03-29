const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');
const economy = require('../../utils/economy');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('fight')
        .setDescription('Fight another user')
        .addUserOption(option => 
            option.setName('opponent')
                .setDescription('User to fight')
                .setRequired(true))
        .addIntegerOption(option => 
            option.setName('bet')
                .setDescription('Amount to bet')
                .setRequired(true)),
    async execute(interaction) {
        const userId = interaction.user.id;
        const opponent = interaction.options.getUser('opponent');
        const bet = interaction.options.getInteger('bet');
        const userData = economy.getUser(userId);
        const opponentData = economy.getUser(opponent.id);
        
        if (userId === opponent.id) {
            return interaction.reply({ content: '❌ You cannot fight yourself!', ephemeral: true });
        }
        
        if (opponent.bot) {
            return interaction.reply({ content: '❌ You cannot fight bots!', ephemeral: true });
        }
        
        if (bet <= 0) {
            return interaction.reply({ content: '❌ Bet must be positive!', ephemeral: true });
        }
        
        if (userData.balance < bet) {
            return interaction.reply({ content: '❌ You don\'t have enough money!', ephemeral: true });
        }
        
        if (opponentData.balance < bet) {
            return interaction.reply({ content: '❌ Opponent doesn\'t have enough money to bet!', ephemeral: true });
        }
        
        if (economy.isJailed(userId) || economy.isJailed(opponent.id)) {
            return interaction.reply({ content: '⛓️ One of you is in jail and cannot fight!', ephemeral: true });
        }
        
        const now = Date.now();
        const cooldown = 30 * 60 * 1000;
        if (userData.lastFight && (now - userData.lastFight) < cooldown) {
            const remaining = cooldown - (now - userData.lastFight);
            const minutes = Math.ceil(remaining / (60 * 1000));
            return interaction.reply({ content: `⏰ You need to recover! Try again in ${minutes} minutes.`, ephemeral: true });
        }
        
        const userPower = Math.random();
        const opponentPower = Math.random();
        const winner = userPower > opponentPower ? interaction.user : opponent;
        const loser = winner === interaction.user ? opponent : interaction.user;
        
        if (winner === interaction.user) {
            economy.addMoney(userId, bet);
            economy.removeMoney(opponent.id, bet);
            economy.updateUser(userId, { wins: (userData.wins || 0) + 1, lastFight: now });
            economy.updateUser(opponent.id, { losses: (opponentData.losses || 0) + 1 });
        } else {
            economy.addMoney(opponent.id, bet);
            economy.removeMoney(userId, bet);
            economy.updateUser(opponent.id, { wins: (opponentData.wins || 0) + 1 });
            economy.updateUser(userId, { losses: (userData.losses || 0) + 1, lastFight: now });
        }
        
        const embed = new EmbedBuilder()
            .setColor(0xffd700)
            .setTitle('⚔️ Fight!')
            .setDescription(`${winner.username} defeated ${loser.username}!`)
            .addFields(
                { name: 'Bet', value: `₹${bet.toLocaleString()}`, inline: true },
                { name: 'Winner', value: winner.username, inline: true },
                { name: 'Prize', value: `₹${bet.toLocaleString()}`, inline: true }
            )
            .setTimestamp();
        
        await interaction.reply({ embeds: [embed] });
    }
};
