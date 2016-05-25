# Description
#   <description of the scripts functionality>
#
exec = require('child_process').exec
execCommand = (msg, cmd) ->
@maxBuffer = 1024*1024
options =
'maxBuffer': @maxBuffer
exec cmd, options, (error, stdout, stderr) ->
msg.send error if error
msg.send stdout
msg.send stderr if stderr

module.exports = (robot) ->
  robot.hear /hello/i, (res) ->
    res.send "hello everyone!"

  robot.respond /RUN (.*)$/i, (msg) ->
    query = msg.match[1]
    command = ""
    msg.send "Outputing status for #{query}"
    execCommand msg, command
    