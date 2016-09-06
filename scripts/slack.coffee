# Description:
#
# Author:
#   @temp <temp@temp.org>

module.exports = (robot) ->
  robot.hear /http://.*?/i, (msg) ->
    msg.reply "posted: #{msg.match[0]}"
