const {Command}  = require('discord.js-commando');

module.exports = class flipCommand extends Command {
	constructor(client) {
		super(client, {
			name: "flip",
			group: "fun",
			memberName: "flip",
			description: "This will flip a coin",
			examples: ["flip"],
		});
	}

	run(message) {
		/*
		Class:
			message
			user
			guildmember/member
			guild
		*/
		message.say(`:arrow_left: ${((Math.round(Math.random()) + 1) == 1 ? "Heads" : "Tails")}`);

	}

};
