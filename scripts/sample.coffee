# Description:
#   Runs a command on hubot
#   TOTAL VIOLATION of any and all security! 
#
# Commands:
#   hubot cmd <command> - runs a command on hubot host

recread = require 'recursive-readdir'
process = require 'process'
path = require 'path'

module.exports = (robot) ->
  robot.hear /search mp4 (.*)$/i, (msg) ->
    root = path.sep + "mnt" + path.sep + "titan" + path.sep + "test"
    recread(root, [], (err, files) ->
      for name, index in files
        msg.send name
    )
    

 
        