const { CommandoClient } = require('discord.js-commando');

const path = require('path');

const env = require('dotenv');

const client = new CommandoClient({
	commandPrefix: "?",
	owner: "136637808063414272"
});

client.on('ready', () => {
	console.log("Bot online!");
	//Start webserver
	require('./server.js').run(client);
});

client.on('message', (msg) => {
	//Stop infinite loop/botception
	if (msg.author.bot) return;

	//Limit this to the org guild
	if(msg.guild.id != process.env.GUILD_ID) return;

	//Diagflow integration
	async function rundiagFlow(projectID, content) {

		const diagflow  = require(`@google-cloud/dialogflow`);
		const uuid = require('uuid');
		const sessionID = uuid.v4();



		const sessionClient = new diagflow.SessionsClient({keyFilename: './conf.json'});
		const sessionPath = sessionClient.projectAgentSessionPath(projectID, sessionID);

		const request = {
			session: sessionPath,
			queryInput: {
				text: {
					text: content,
					languageCode: 'en-US'
				},
			},
		}

		const responses = await sessionClient.detectIntent(request);
		const result = responses[0].queryResult;
		if (result.intent) {
			msg.say(result.fulfillmentText);
		} else {
			return;
		}
	};

	rundiagFlow('sfhacks2021-306909', msg.content);
	//End of Diagflow integration

})

// Register command groups 
client.registry.registerDefaultTypes().registerGroups(["fun", "fun"], ["utility", "utility"]).registerDefaultGroups().registerDefaultCommands({ unknownCommand: false, prefix: false }).registerCommandsIn(path.join(__dirname, "commands"));

//Authenticate and log into discord
client.login(process.env.TOKEN);
