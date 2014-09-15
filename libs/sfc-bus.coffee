# Description:
#   Bus Schedule Component for Hubot Script
#
# Author:
#   @shokai

_       = require 'lodash'
cheerio = require 'cheerio'
request = require 'request'
async   = require 'async'
debug   = require('debug')('hubot-sfc-bus:sfc-bus')

bus = module.exports

bus.STOPS =
  "湘南台":
    "湘南台駅発 慶応大学行":                    "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000801156-1/nid:00129893"
    "湘南台駅発 慶応大学行 [綾瀬車庫行19系統]": "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000801968-8/nid:00129985"
    "本館前発 湘南台駅行":                      "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000800141-1/nid:00129986"
    "慶応大学発 湘南台駅行":                    "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000800141-2/nid:00129985"
  "辻堂":
    "慶応大学発 辻堂駅行": "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000801121-2/nid:00129985"
    "本館前発 辻堂駅行":   "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000801121-1/nid:00129986"
    "辻堂駅発 SFC行":      "http://www.kanachu.co.jp/dia/diagram/timetable/cs:0000800267-1/nid:00129934"

bus.getDay = ->
  return switch new Date().getDay()
    when 0 then "休日"
    when 6 then "土曜"
    else "平日"


## 路線名で検索
bus.getScheduleOfLines = (line, callback = ->) ->
  debug "getScheduleOfLines: #{line}"
  unless bus.STOPS.hasOwnProperty line
    callback "#{line}、そんな名前の路線知らない"
    return
  async.map _.keys(bus.STOPS[line]), (name, next) ->
    bus.getScheduleOfBusStop bus.STOPS[line][name], (err, schedule) ->
      next err, {name: name, schedule: schedule}
  , (err, res) ->
    callback err, res


## 時刻表をスクレイピングで取得
bus.getScheduleOfBusStop = (url, callback = ->) ->
  debug "getScheduleOfBusStop: #{url}"
  request url, (err, res, body) ->
    if err
      callback err
      return
    $ = cheerio.load(body)
    schedule = {}
    for selector in ['tr.row1', 'tr.row2']
      $(selector).each (i, tr) ->
        hour = $(tr).children('th').text() - 0
        tds = $(tr).children('td')
        for day, index in ['平日', '土曜', '休日']
          minutes = $(tds.get(index)).html().match(/>\d+</g)?.map (i) -> i.replace(/[><]/g,'') - 0
          unless schedule[hour]
            schedule[hour] = {}
          schedule[hour][day] = minutes
    callback null, schedule
