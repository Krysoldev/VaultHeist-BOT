const economy = require('../utils/economy');

module.exports = {
    name: 'interactionCreate',
    async execute(interaction, client) {
        if (!interaction.isChatInputCommand()) return;
        
        const command = client.commands.get(interaction.commandName);
        
        if (!command) return;
        
        try {
            // Check if user is blacklisted
            const userData = economy.getUser(interaction.user.id);
            if (userData.blacklisted && !interaction.memberPermissions.has('Administrator')) {
                return interaction.reply({ content: '⛔ You are blacklisted from using this bot!', ephemeral: true });
            }
            
            // Check cooldowns
            const { cooldowns } = client;
            if (!cooldowns.has(command.data.name)) {
                cooldowns.set(command.data.name, new Map());
            }
            
            const now = Date.now();
            const timestamps = cooldowns.get(command.data.name);
            const cooldownAmount = (command.cooldown || 3) * 1000;
            
            if (timestamps.has(interaction.user.id)) {
                const expirationTime = timestamps.get(interaction.user.id) + cooldownAmount;
                
                if (now < expirationTime) {
                    const timeLeft = (expirationTime - now) / 1000;
                    return interaction.reply({ content: `⏰ Please wait ${timeLeft.toFixed(1)} more seconds before using \`/${command.data.name}\`.`, ephemeral: true });
                }
            }
            
            timestamps.set(interaction.user.id, now);
            setTimeout(() => timestamps.delete(interaction.user.id), cooldownAmount);
            
            await command.execute(interaction);
        } catch (error) {
            console.error(error);
            await interaction.reply({ content: 'There was an error executing this command!', ephemeral: true });
        }
    }
};
