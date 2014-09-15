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
  robot.respond /(バス|bus)\s+([^\s]+)\s*(.*)/i, (msg) ->
    where = msg.match[2]
    who = msg.message.user.name
    day = Bus.getDay()
    hour = new Date().getHours()

    for opt in msg.match[3].split(/\s+/)
      if /(平日|休日|土曜)/.test opt
        day = opt
      if /\d+時/.test opt
        hour = opt.match(/(\d+)/)[1] - 0

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
