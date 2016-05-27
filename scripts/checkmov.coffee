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
        urlname = urlname.replace(/\(/g,'\%28')
        urlname = urlname.replace(/\)/g,'\%29')
        
        basename = Path.basename(name)
        msg.send ":clapper:[movie](#{urlname})"

module.exports = (robot) ->
  robot.hear /search in (.*) from (.*) to (.*)$/i, (msg) ->

	keyword = msg.match[1]
	localdir = msg.match[2]
	contextpath = msg.match[3]

    domain = process.env.HUBOT_CHECKMOV_DOMAIN + "/" + contextpath  or ''
    if not is_defined_env(domain)
       msg.send "please set ENV [HUBOT_CHECKMOV_DOMAIN]"
       return

    filepattern = ///^.*?#{keyword}.*?\.(mp4|flv)$///
    
    options =
      filterFile: (stats)->
        stats.name.match(filepattern)
        
    search_movie(msg,domain,localdir,filepattern,options)
 
  robot.respond /checkmov help/i, (msg) ->
    msg.send "usage: search in (keyword) from (server_local_path) to (domain_context_path)"
 
    
