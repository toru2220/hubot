# Description:
#   Runs a command on hubot
#   TOTAL VIOLATION of any and all security! 
#
# Commands:
#   hubot cmd <command> - runs a command on hubot host

r_readdir = require('recursive-readdir-filter')
process = require 'process'
Path = require 'path'

module.exports = (robot) ->
  robot.hear /search mp4 (.*)$/i, (msg) ->
  
    domain = process.env.HUBOT_DOMAIN_MP4  or ''
    if domain.length < 1
       msg.send "please set ENV [HUBOT_DOMAIN_MP4]"
       return
    
    root = Path.sep + "mnt" + Path.sep + "titan" + Path.sep + "mp4" 
    root_quote = root.replace ///#{Path.sep}///,"\\#{Path.sep}"
    msg.send "search in [#{root}]...."

    filepattern = ///^.*?#{msg.match[1]}.*?\.(mp4|flv)$///
    options =
      filterFile: (stats)->
        stats.name.match(filepattern)
        
    r_readdir root, options, (err, files)->
      for name, index in files
        urlname = encodeURI(name.replace(///#{root_quote}///,domain))
        basename = Path.basename(name)
        msg.send "[#{basename}](#{urlname})"
    
    
