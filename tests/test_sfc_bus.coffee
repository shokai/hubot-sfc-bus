path = require 'path'
require path.resolve 'tests', 'test_helper'

assert = require 'assert'
bus    = require path.resolve 'libs', 'sfc-bus'

describe 'sfc-bus module', ->

  it 'sohuld have method "getDay"', ->
    assert.equal typeof bus['getDay'], 'function'

  it 'sohuld have method "getScheduleOfLines"', ->
    assert.equal typeof bus['getScheduleOfLines'], 'function'

  it 'sohuld have method "getScheduleOfBusStop"', ->
    assert.equal typeof bus['getScheduleOfBusStop'], 'function'

  describe 'method "getScheduleOfLines"', ->

    it 'should callback schedules of 湘南台', (done) ->

      @timeout 10000
      bus.getScheduleOfLines '湘南台', (err, schedules) ->
        if err
          return done err
        assert.equal schedules instanceof Array, true
        for schedule in schedules
          assert.equal typeof schedule['name'], 'string'
          assert.equal typeof schedule['schedule'], 'object'
          assert.equal schedule['schedule'] instanceof Array, false
          assert.equal (schedule.schedule['15']['平日'].length > 0), true
        done()

    it 'should callback schedules of 辻堂', (done) ->

      @timeout 10000
      bus.getScheduleOfLines '辻堂', (err, schedules) ->
        if err
          return done err
        assert.equal schedules instanceof Array, true
        for schedule in schedules
          assert.equal typeof schedule['name'], 'string'
          assert.equal typeof schedule['schedule'], 'object'
          assert.equal schedule['schedule'] instanceof Array, false
          assert.equal (schedule.schedule['15']['平日'].length > 0), true
        done()
