# Description:
#   Runs a command on hubot
#   TOTAL VIOLATION of any and all security! 
#
# Commands:
#   hubot cmd <command> - runs a command on hubot host

r_readdir = require('recursive-readdir-filter')
process = require 'process'
Path = require 'path'

is_defined_env = (envname) ->
  if envname.length < 1
    return false
  else
    return true
    
search_movie = (msg,env_domain,env_localdir,filepattern,readdir_options) ->
    domain = env_domain
    localdir =env_localdir
  
    root = localdir 
    root_quote = root.replace ///#{Path.sep}///,"\\#{Path.sep}"
    msg.send "search in [#{root}]...."
    
    r_readdir root, readdir_options, (err, files)->
      if files.length < 1
        msg.send "file not found"
        return
      for name, index in files
        urlname = encodeURI(name.replace(///#{root_quote}///,domain))
        basename = Path.basename(name)
        msg.send "[:clapper:](#{urlname})"

module.exports = (robot) ->
  robot.hear /search mp4 (.*)$/i, (msg) ->

    domain = process.env.HUBOT_DOMAIN_MP4  or ''
    if not is_defined_env(domain)
       msg.send "please set ENV [HUBOT_DOMAIN_MP4]"
       return

    localdir = process.env.HUBOT_DOMAIN_LOCALDIR_MP4  or ''
    if not is_defined_env(localdir)
       msg.send "please set ENV [HUBOT_DOMAIN_LOCALDIR_MP4]"
       return

    filepattern = ///^.*?#{msg.match[1]}.*?\.(mp4|flv)$///
    
    options =
      filterFile: (stats)->
        stats.name.match(filepattern)
        
    search_movie(msg,domain,localdir,filepattern,options)

  robot.hear /search flv (.*)$/i, (msg) ->

    domain = process.env.HUBOT_DOMAIN_FLV  or ''
    if not is_defined_env(domain)
       msg.send "please set ENV [HUBOT_DOMAIN_FLV]"
       return

    localdir = process.env.HUBOT_DOMAIN_LOCALDIR_FLV  or ''
    if not is_defined_env(localdir)
       msg.send "please set ENV [HUBOT_DOMAIN_LOCALDIR_FLV]"
       return

    filepattern = ///^.*?#{msg.match[1]}.*?\.(mp4|flv)$///
    
    options =
      filterFile: (stats)->
        stats.name.match(filepattern)
        
    search_movie(msg,domain,localdir,filepattern,options)
    
    
