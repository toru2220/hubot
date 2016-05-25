# Description:
#   Runs a command on hubot
#   TOTAL VIOLATION of any and all security! 
#
# Commands:
#   hubot cmd <command> - runs a command on hubot host

recread = require 'recursive-readdir-filter'
process = require 'process'
Path = require 'path'

module.exports = (robot) ->
  robot.hear /search mp4 (.*)$/i, (msg) ->
  
    domain = process.env.HUBOT_DOMAIN_MP4  or ''
    if domain.length < 1
       msg.send "please set ENV [HUBOT_DOMAIN_MP4]"
       return
    
    root = Path.sep + "mnt" + Path.sep + "titan" + Path.sep + "mp4"
    msg.send "search in [#{root}]"
    
    options = {
	    filterFile: (stats) ->
	        return stats.name.match(/.*?chat.*?mp4$/);
	}

    recread(root, options, (err, files) ->
      for name, index in files
        urlname = encodeURI(name.replace(/root/,domain))
        basename = Path.basename(name)
        msg.send "<h2>#{basename}<h2><br><video src=\"#{urlname}\"></video>"
        if index > 10
          break
    )


 
        