require('app-module-path').addPath '/home/ingy/src/pegex-js/lib'
yaml = require 'js-yaml'
global.say = console.log
global.xxx = (o)->
  say yaml.dump o
  process.exit 1
