exports.run = (client) => {
	const env = require('dotenv');
	const express = require('express');
	const cors = require('cors');
	const helmet = require('helmet');

	const app = express();

	app.use(express.json());
	app.use(cors());
	app.use(helmet());

	const authError = (res) => {
		return res.status(401).send({ error: "Invalid API Key" });
	}

	const error = (res, text) => {
		return res.status(400).send({ error: `${text}` });
	}

	const logChannel = (body) => {
		client.guilds.cache.get(process.env.GUILD_ID).channels.cache.get(process.env.LOG_CHANNEL).send(body);
	}

	app.use(function(err, req, res, next) {
		if (req.headers["x-api-key"] != process.env.API_KEY) {
			return authError(res);
		} else {
			next();
		}
	})

	app.all("/", (req, res) => {
		res.status(200).send({ status: "ok" });
	})

	//called when a team is created
	app.post("/teams/create", (req, res) => {
		/*
		{
			players: [],
			teamName:
		}
		*/
		if (!req.body.players) {
			return error(res, "Players not found");
		}
		const guild = client.guilds.cache.get(process.env.GUILD_ID);
		guild.members.fetch();
		let teamRole = guild.roles.cache.find(r => r.name == req.body.teamName);
		if (!teamRole) {
			guild.roles.create({ data: { name: req.body.teamName } });
			teamRole = guild.roles.cache.find(r => r.name == req.body.teamName);
		}
		req.body.players.forEach(pl => {
			let m = guild.members.cache.find(member => member.user.tag == pl);
			if(m) { m.roles.add(teamRole.id); } else { logChannel(`Could not find user ${pl} to be added to team ${req.body.teamName}.`)}
		})
		logChannel(`> **${req.body.teamName}** created and was assigned to users: \`\`\`${req.body.players.join('\n')}\`\`\``);

		res.status(200).send({success: true});
	});

	app.post("/formSubmit", (req, res) => {
		/*
		{
			[formResponseBody]
		}
		*/
		if(!req.body) return error(req, "No body text");
		let chunk = "> **New Form Submission**\n";
		Object.entries(req.body).forEach(([key, value]) => {
			chunk += (`> ${key} - ${value}\n`);
		});
		logChannel(chunk);
		res.status(200).send({success: true});
	});

	app.listen(8080, () => {
		console.log("Express server live!");
	});

}
