# Description:
#   Runs a command on hubot
#   TOTAL VIOLATION of any and all security! 
#
# Commands:
#   hubot cmd <command> - runs a command on hubot host

module.exports = (robot) ->
  robot.hear /search mp4 (.*)$/i, (msg) ->
    # console.log(msg)
    @exec = require('child_process').exec
    filename = msg.match[1]
    cmd = "find /mnt/titan/mp4 -type f -name *#{filename}*.mp4"
    msg.send "Running [#{cmd}]..."

    @exec cmd, (error, stdout, stderr) -> 
      if error
        msg.send error
        msg.send stderr
      else
        if stdout.length > 0
          for name, index in split(/\r\n/,stdout)
            msg.send "#{index} #{name}"
          msg.send "found #{stdout.length} files."
        else
          msg.send "file does not found"

        