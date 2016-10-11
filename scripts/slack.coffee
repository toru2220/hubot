# Description:
#
# Author:
#   @temp <temp@temp.org>

child_process = require('child_process')

module.exports = (robot) ->
  robot.respond /save from (https.*?youtube\.com.*?)$/i, (msg) ->
    url = msg.match[1]
    msg.reply "download start: #{url}"
    child_process.exec "youtube-dl #{url}", (error, stdout, stderr) ->
      if !error
        output = stdout+''
        msg.send output
      else
        msg.send 'error'


