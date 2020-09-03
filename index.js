const Discord = require('discord.js');
const { Client, MessageEmbed } = require('discord.js');
const client = new Discord.Client();
const guildInvites = new Map();
const fs = require('fs')
const welcomeName = require('./config.json')


client.on('message', async message => {
    const prefix = '+';
    let args = message.content.slice(prefix.length).trim().split(/ +/g);

    if (message.content.includes(`${prefix}cred`)) {
        message.delete()
        const embed = new MessageEmbed()
            .setTitle('AlphaBet Invite Manager')
            .setDescription(`Made By:
        **Effortless-#7382**\n
        Made For:
        **_AlphaBet_ Server**`)
            .setTimestamp()
            .setFooter(message.author.username, message.author.displayAvatarURL())
            .setThumbnail(message.author.displayAvatarURL())
            .setColor('YELLOW')

        message.channel.send(embed);
    }


});


client.on('ready', () => {
    console.log(`Logged in as ${client.user.tag}!`);
    client.guilds.cache.forEach(guild => {
        guild.fetchInvites()
            .then(invites => guildInvites.set(guild.id, invites))
            .catch(err => console.log(err));
    })
    const presence = ["To Invites | +cred", `To Invites | +cred`];
    setInterval(() => {
        const index = Math.floor(Math.random() * (presence.length - 1) + 1);
        client.user.setActivity(presence[index], { type: "LISTENING" });
    }, 30000);
});


client.on('inviteCreate', async member => guildInvites.set(invite.guild.id, await invite.guild.fetchInvites()));

client.on('guildMemberAdd', async member => {
    const catchedInvites = guildInvites.get(member.guild.id)
    const newInvites = await member.guild.fetchInvites();
    guildInvites.set(member.guild.id, newInvites)
    try {
        const usedInvite = newInvites.find(inv => catchedInvites.get(inv.code).uses < inv.uses)
        const embed = new MessageEmbed()
            .setDescription(`
        **Joined using:**: ${usedInvite.inviter.tag} Invite\n
        **Number Of Invites:** ${usedInvite.uses}\n
        **Invite Link Used:** ${usedInvite.url}`)
            .setTimestamp()
            .setTitle(`${member.user.tag} is Member number ${member.guild.memberCount}!`)
            .setColor('YELLOW')
        const welcomeChannel = member.guild.channels.cache.find(channel => channel.name.includes() === `welcome` || channel.type === 'text')
        if (welcomeChannel) {
            welcomeChannel.send(embed).catch(err => console.log(err))
        }
    } catch (err) {
        console.log(err)
    }

});
client.on('guildMemberRemove', async member => {
    try {

        const embed = new MessageEmbed()
            .setTimestamp()
            .setTitle(`${member.user.tag} is Has Left The Server!`)
            .setColor('YELLOW')
        const welcomeChannel = member.guild.channels.cache.find(channel => channel.name.includes() === 'welcome' || channel.type === 'text')
        if (welcomeChannel) {
            welcomeChannel.send(embed).catch(err => console.log(err))
        }
    } catch (err) {
        console.log(err)
    }



});





client.login('NzUwODU2MzcwNTkyNTQ2OTA2.X1AnfA.LhAVfjw96lohkX105yOiZC0BK7E');