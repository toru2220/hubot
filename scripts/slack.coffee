# Description:
# download movie using youtube-dl
#
# Dependencies:
# None
#
# Configuration:
# HUBOT_YOUTUBEDL_DIR
# HUBOT_YOUTUBEDL_DIR_MP3(optional)
#
# Commands:
# hubot save start <youtube-url> - <youtube-url> download movie to <HUBOT_YOUTUBEDL_DIR>
# hubot conv start <youtube-url> - <youtube-url> download movie and convert mp3. save to <HUBOT_YOUTUBEDL_DIR_MP3>
# hubot (start or conv) test <youtube-url> - simulation mode
#
# Author:
# None

#���W���[�����[�h
child_process = require('child_process')
      
module.exports = (robot) ->
  savemov = process.env.HUBOT_YOUTUBEDL_DIR
  savemp3 = process.env.HUBOT_YOUTUBEDL_DIR_MP3

  #HUBOT_YOUTUBEDL_DIR���ݒ肳��Ă��Ȃ��ꍇ�̓G���[���b�Z�[�W��\�����ďI������
  if savemov == ""
    msg.reply "Please Set ENV[HUBOT_YOUTUBEDL_DIR]. finished."
    return

  #HUBOT_YOUTUBEDL_DIR_MP3���ݒ肳��Ă��Ȃ��ꍇ�͑����HUBOT_YOUTUBEDL_DIR��ۑ���Ɏw�肷��
  if savemp3 == ""
    msg.reply "ENV[HUBOT_YOUTUBEDL_DIR_MP3] is not set. use ENV[HUBOT_YOUTUBEDL_DIR] instead."
    savemp3 = savemov

  #�֐���`
  #youtube-dl�C���X�g�[���`�F�b�N
  isinstalled_youtube_dl = ->
    child_process.exec "which youtube-dl", (error, stdout, stderr) ->
      if stdout = ""
        msg.reply "youtube-dl is not installed. finished."
        return false
      else
        return true
  
  #ffmpeg�C���X�g�[���`�F�b�N
  isinstalled_ffmpeg = ->
    child_process.exec "which ffmpeg", (error, stdout, stderr) ->
      if stdout = ""
        msg.reply "[install check] ffmpeg is not installed. finished."
        return false
      else
        return true
  
  #�Ώۂ̃^�C�g�����擾���ۑ��p�̃t���p�X����Ԃ�
  generate_filename = (url,savedir,extension) ->
    child_process.exec "youtube-dl --get-title #{url}", (error, stdout, stderr) ->
      if !error
        msg.reply "[generate filename] title fetch failed. message = #{error}"
        return ""
      else
        savefilename = savedir + "/" + stdout + "." + extension
        msg.reply "[generate filename] title fetch success. save filename = #{savefilename}"
        return savefilename

  robot.respond /(save|conv) (start|test) (https.*?youtube\.com.*?)/i, (msg) ->
    savetype = msg.match[1]
    mode = msg.match[2]
    url = msg.match[3]
    
    #install check
    if !isinstalled_youtube_dl()
      return
      
    if !isinstalled_ffmpeg()
      return

    #generate title and set option
    savefilename_mp4 = generate_filename(url,savemov,"mp4")
    savefilename_mp3 = ""
    option = "--write-thumbnail"
    if savetype == "conv"
      savefilename_mp3 = generate_filename(url,savemp3,"mp3")
      
    #simulation mode
    if mode == "test"
      option = option + " --simulate"
 
    download_command_mp4 = "youtube-dl #{option} --output #{savefilename_mp4} #{url}"
    msg.reply "[download start] #{url} save to #{savefilename_mp4}"
    msg.reply "[command] #{download_command_mp4}"
    
    child_process.exec "#{download_command_mp4}", (error, stdout, stderr) ->
      if !error
        msg.reply "[success] download completed. #{savefilename_mp4}"
      else
        msg.reply "[failed] download failed. #{error}"

    #mp4�ۑ��̏ꍇ�͏I��
    if savetype == "save"
      return
      
    #mp3�ϊ��A�ϊ��㌳�t�@�C���͍폜(���s�����폜)
    convert_command_mp3 = "ffmpeg -i #{savefilename_mp4} -acodec libmp3lame -ab 192k #{savefilename_mp3}"
    msg.reply "[convert start] #{savefilename_mp4} convert to #{savefilename_mp3}"
    msg.reply "[command] #{convert_command_mp3}"
    cleanup_command = "rm #{savefilename_mp4}"

    if mode == "test"
        msg.reply "[simulation] convert skipped."
        return
  
    child_process.exec "#{convert_command_mp3}", (error, stdout, stderr) ->
      if !error
        msg.reply "[success] convert successful. #{savefilename_mp3}"
      else
        msg.reply "[failed] convert failed. #{error}"
     
    child_process.exec "#{cleanup_command}", (error, stdout, stderr) ->
      if !error
        msg.reply "[success] cleanup successful."
      else
        msg.reply "[failed] cleanup failed. #{error}"
  


