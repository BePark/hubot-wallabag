# hubot-wallabag

The purpose of this project was to save links from a [slack](https://slack.com/) channel (or any hubot adapter)
to [wallabag](https://wallabag.org/) using our [hubot](https://hubot.github.com/) bot.

So all links are send inside the same wallabag account. An improvements will be
made when the [group](https://github.com/wallabag/wallabag/pull/2268) will be present
inside wallabag.

Normally it should works with any other adapter than slack (or none).

## Usage

* *[hubot name] link exporter add here* will save all link from this channel to wallbag
* *[hubot name] link exporter stop here* will stop to save all links 
* *[hubot name] link export this* will save the link following in the message
* *[hubot name] link exporter list channels* list all chanels to save sared links

### adding tags
Each time a link is saved two tags are present:
* the channel name with "channel-[channel-name]"
* if the link was automatically added or not with "taken-auto" or "taken-manual"

If you wan to add tags, just write you links and then add your tags with a "#" in
front of them, like on social media.

## Installation

In hubot project repo, run:

`npm install hubot-wallabag --save`

Then add **hubot-wallabag** to your `external-scripts.json`:

```json
["hubot-wallabag"]
```

## Configuration

Using environmental variable, give te token for wallabag.

* *HUBOT_WALLABAG_URL*: url to wallabag instance
* *HUBOT_WALLABAG_USERNAME*: the username to connect to wallabag
* *HUBOT_WALLABAG_PASSWORD*: the password to connect to wallabag
* *HUBOT_WALLABAG_CLIENT_ID*: the client id to connect to your instance (go to your wallabag instance in '/developer')
* *HUBOT_WALLABAG_CLIENT_SECRET*: the secret to connect to wallabag

## TODO
* using groups when it will be ready
* adding a way to not save link even on listened channels
* pushing links from wallabag to hubot
* find a way to make the oauth auth not hardcoded because it's ugly!

## License
The MIT license is applied here.

## Notes
This projects is written in coffeescript because of hubot ;) Fell free to improve it!
