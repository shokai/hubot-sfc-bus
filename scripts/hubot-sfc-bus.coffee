# Description:
#   Bus Schedule at SFC (Keio University)
#
# Dependencies
#   "lodash":  "*"
#   "cheerio:  "*"
#   "request": "*"
#   "async":   "*"
#   "debug":   "*"
#
# Commands:
#   hubot バス (湘南台|辻堂)
#   hubot バス (湘南台|辻堂) (平日|土曜|休日) (\d時)
#
# Author:
#   @shokai

path  = require 'path'
Bus   = require path.join __dirname, '../libs/sfc-bus'
debug = require('debug')('hubot-sfc-bus')

module.exports = (robot) ->
  robot.error (err, msg) ->
    console.error err

  robot.respond /(バス|bus)\s+(.+)/i, (msg) ->
    who = msg.message.user.name
    arg  = msg.match[2]

    day = (arg.match(/(平日|休日|土曜)/) or [])[1] or Bus.getDay()
    hour = (arg.match(/(\d+)時/) or [])[1] - 0 or new Date().getHours()
    where = (arg.match(new RegExp "(#{Object.keys(Bus.STOPS).join('|')})") or [])[1]
    unless where
      msg.send """
      @#{who} #{Object.keys(Bus.STOPS).join(' ')} を指定してください
      例 hubot バス 湘南台
         hubot バス (湘南台|辻堂) (平日|土曜|休日) (0〜23時)
      """
      return

    msg.send "@#{who} #{day}#{hour}時 #{where}のバス時刻表について調べます"

    Bus.getScheduleOfLines where, (err, schedules) ->
      if err
        msg.send err
        return
      text = schedules.map (line) ->
        text = [hour, hour+1].map (h) ->
          minutes = line.schedule[h]?[day]?.map (i) ->
            "#{i}分"
          ?.join(' ') or 'なし'
          "#{h}時:  #{minutes}"
        ?.join "\n"
        return "#{line.name} (#{day})\n#{text}"
      .join "\n"
      msg.send text
