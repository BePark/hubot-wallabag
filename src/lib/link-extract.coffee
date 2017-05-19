request = require('request');
WallabagApi = require './wallabag-api';

walla = null
channelWhiteList = []

module.exports = {
	regexpUrl: () ->
		return new RegExp("\\bhttps?://\\S+", "ig")

	shouldExtract: (channel, text) ->
		if channelWhiteList.indexOf(channel) != -1
			return true

		return false

	tagExtract: (text) ->
		regexp = new RegExp("(^|\\s)#(\\S+)", "ig")

		tags = while (tmp = regexp.exec(text)) != null
			tmp[2]

		return tags

	addToWhiteList: (channel) ->
		channelWhiteList.push(channel)

	listChannels: ->
		channelWhiteList

	removeFromWhiteList: (channel) ->
		channelWhiteList = channelWhiteList.filter (chan) -> chan isnt channel

	# brainify the channels to listen on
	channelsBrains: (robot) ->
		if robot.brain.data.linkExtractor
			channelWhiteList = robot.brain.data.linkExtractor
		else
			robot.brain.data.linkExtractor = channelWhiteList

	addLinks: (urls, tags, channel, auto) ->
		tags.push('channel-' + channel)
		tags.push('taken-' + (auto ? 'auto' : 'manual'))

		for url in urls
			walla.SavePage(url, tags)

	initWallabag: (config) ->
		walla = new WallabagApi(config.url, config.clientId, config.clientSecret, config.username, config.password)
}
