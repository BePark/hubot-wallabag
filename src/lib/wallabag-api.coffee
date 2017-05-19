# @see inspirate by https://github.com/wallabag/wallabagger/blob/master/wallabagger/js/wallabag-api.js

request = require('request');

class WallabagApi
	data:
		Url: null
		ClientId: null
		ClientSecret: null
		UserLogin: null
		UserPassword: null
		ApiToken: null
		RefreshToken: null
		ExpireDateMs: null

	constructor: (url, clientId, clientSecret, userLogin, userPassword) ->
		@data.Url = url
		@data.ClientId = clientId
		@data.ClientSecret = clientSecret
		@data.UserLogin = userLogin
		@data.UserPassword = userPassword

		@GetAppToken()

	SavePage: (pageUrl, tags) ->
		content = JSON.stringify({
			url: pageUrl,
			tags: tags.join(',')
		})

		self = this
		savePage = ->
			rinit = self.RequestInit('POST', self.AuhorizedHeader(), content)
			rinit.url = self.data.Url + '/api/entries.json'

			request(rinit, (error, response, body) ->
				info = JSON.parse(body)
				if error or response.statusCode != 200 or info == '' or info == false
					console.log 'Failed to save page ' + pageUrl
					console.log error
					console.log body
					#					console.log response
					return

				console.log info
			)

		# check init of tockens
		if @needNewAppToken()
			console.log @RefreshToken(savePage)
		else
			savePage()

	RefreshToken: (callback = null) ->
		content = JSON.stringify(
			grant_type: 'refresh_token'
			refresh_token: @data.RefreshToken
			client_id: @data.ClientId
			client_secret: @data.ClientSecret
		)

		rinit = @RequestInit('POST', @NotAuhorizedHeader(), content)
		rinit.url = @data.Url + '/oauth/v2/token'

		self = this
		request(rinit, (error, response, body) ->
			info = JSON.parse(body)
			if error or response.statusCode != 200 or info == '' or info == false
				console.log 'Failed to refresh token ' + rinit.url
				console.log error
				console.log body
				#				console.log response
				return

			nowDate = new Date(Date.now())
			self.data.ApiToken = info.access_token
			self.data.RefreshToken = info.refresh_token
			self.data.ExpireDateMs = nowDate.setSeconds(nowDate.getSeconds() + info.expires_in)

			if callback
				callback()

			info
		)

	GetAppToken: ->
		content = JSON.stringify(
			grant_type: 'password'
			client_id: @data.ClientId
			client_secret: @data.ClientSecret
			username: @data.UserLogin
			password: @data.UserPassword
		)

		rinit = @RequestInit('POST', @NotAuhorizedHeader(), content)
		rinit.url = @data.Url + '/oauth/v2/token'

		self = this
		request(rinit, (error, response, body) ->
			info = JSON.parse(body)
			if error or response.statusCode != 200 or info == '' or info == false
				console.log 'Failed to get app token from ' + rinit.url
				console.log error
				console.log body
				#				console.log response
				return

			nowDate = new Date
			self.data.ApiToken = info.access_token
			self.data.RefreshToken = info.refresh_token
			self.data.ExpireDateMs = nowDate.setSeconds(nowDate.getSeconds() + info.expires_in)

			info
		)

	RequestInit: (rmethod, rheaders, content) ->
		options =
			method: rmethod
			headers: rheaders
			mode: 'cors'
			cache: 'default'

		if content != '' && content != null
			options.body = content

		options

	AuhorizedHeader: ->
		{
			'Authorization': 'Bearer ' + @data.ApiToken
			'Accept': 'application/json'
			'Content-Type': 'application/json'
			'Accept-Encoding': 'gzip, deflate'
		}

	NotAuhorizedHeader: ->
		{
			'Accept': 'application/json'
			'Content-Type': 'application/json'
			'Accept-Encoding': 'gzip, deflate'
		}

	needNewAppToken: ->
		return @data.ApiToken == '' or @data.ApiToken == null or @expired()

	expired: ->
		return @data.ExpireDateMs != null and Date.now() > @data.ExpireDateMs

module.exports = WallabagApi
