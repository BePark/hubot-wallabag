# Description:
#	 Detect all link to send to a link archive
#
# Commands:
#	 hubot link exporter add here - save all link from this channel to wallbag
#	 hubot link exporter stop here - stop to save link from this channel to wallbag 
#	 hubot link export this - save the link comming in the message
#	 hubot link exporter list channels - list channels to listen
#

linkExtract = require './lib/link-extract'

wallabagConfig =
	url: process.env.HUBOT_WALLABAG_URL
	username: process.env.HUBOT_WALLABAG_USERNAME
	password: process.env.HUBOT_WALLABAG_PASSWORD
	clientId: process.env.HUBOT_WALLABAG_CLIENT_ID
	clientSecret: process.env.HUBOT_WALLABAG_CLIENT_SECRET

linkExtract.initWallabag wallabagConfig

module.exports = (robot) ->
	robot.brain.on 'loaded', ->
		linkExtract.channelsBrains robot

	robot.hear linkExtract.regexpUrl(), (msg) ->
		text = msg.message.text
		channel = msg.message.room

		if linkExtract.shouldExtract(channel, text)
			urls = msg.match
			tags = linkExtract.tagExtract(text)

			console.log(urls)
			console.log(tags)

			linkExtract.addLinks(urls, tags, channel, true)

	robot.respond /link exporter add here/, (msg) ->
		linkExtract.addToWhiteList msg.message.room

	robot.respond /link exporter stop here/, (msg) ->
		linkExtract.removeFromWhiteList msg.message.room

	robot.respond /link export this/, (msg) ->
		text = msg.message.text
		channel = msg.message.room

		urls = text.match(linkExtract.regexpUrl())
		tags = linkExtract.tagExtract(text)

		console.log 'link-extract-chan', channel
		console.log 'link-extract-text', text
		console.log 'link-extract-tags', tags
		console.log 'link-extract-urls', urls

		linkExtract.addLinks(urls, tags, channel, false)

	robot.respond /link exporter list channels/, (msg) ->
		list = linkExtract.listChannels()
		if list.length <= 0
			'No channel listening'
		else
			list.join("\n")

# TODO is this chan?
