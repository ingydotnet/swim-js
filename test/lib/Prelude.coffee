require('app-module-path').addPath '../pegex-js/lib'
global.yaml = require 'js-yaml'
global.say = console.log
global.xxx = (o)->
  say yaml.dump o
  process.exit 1
global.die = (m)->
  say "Died: #{m}\n"
  process.exit 1
