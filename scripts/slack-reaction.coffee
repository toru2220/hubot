# Description:
#   notify "reaction_added" event for slack.com
#   http://shokai.org/blog/archives/10344
#
# Author:
#   @shokai <hashimoto@shokai.org>

debug = require('debug')('hubot:slack-reaction')
_     = require 'lodash'

config =
  room: 'general'

module.exports = (robot) ->

  reactions =
    prefix: "reaction"
    get: (url) ->
      robot.brain.get("#{@prefix}_#{url}") or []
    set: (url, users) ->
      return unless users instanceof Array
      robot.brain.set "#{@prefix}_#{url}", users
    add: (url, user) ->
      users = @get url
      users.push user
      @set url, _.uniq(users)
    remove: (url, user) ->
      users = @get url
      users.splice(users.indexOf(user), 1)
      @set url, users

  robot.adapter.client?.on? 'raw_message', (msg) ->
    if msg.type isnt 'reaction_added' and
       msg.type isnt 'reaction_removed'
      robot.send {room: config.room}, msg.type
      return
    debug msg
    return if msg.item.type isnt 'message'
    return unless channel = robot.adapter.client.getChannelByID msg.item.channel
    return unless user = robot.adapter.client.getUserByID msg.user
    url = "https://#{robot.adapter.client.team.domain}.slack.com/archives/#{channel.name}/p#{msg.item.ts.replace('.','')}"
    switch msg.type
      when 'reaction_added'
        reactions.add url, user.name
        users = reactions.get url
        text = [0...users.length].map(-> ":#{msg.reaction}:").join ''
        _users =
          if users.length is 1
            user.name
          else
            "#{user.name} and #{users.filter((i) -> i isnt user.name).join ', '}"
        text += " #{url} by #{_users}"
        debug text
        robot.send {room: config.room}, text
      when 'reaction_removed'
        reactions.remove url, user.name
