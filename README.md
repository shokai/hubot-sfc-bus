hubot-sfc-bus
=============
Hubot script for Bus Schedule at SFC (Keio University).

- https://github.com/shokai/hubot-sfc-bus
- https://www.npmjs.org/package/hubot-sfc-bus

[![Build Status](https://travis-ci.org/shokai/hubot-sfc-bus.svg?branch=master)](https://travis-ci.org/shokai/hubot-sfc-bus)

Install
-------

    % npm install hubot-sfc-bus -save


### edit `external-script.json`

```json
["hubot-sfc-bus"]
```


Usage
-----

    hubot バス 湘南台
    hubot バス 辻堂 土曜 11時

    hubot (bus|バス) (湘南台|辻堂) (平日|土曜|休日) (\d時)


![screen shot](http://gyazo.com/17dc05d6ee900ddef203d49b4bd1690a.png)
