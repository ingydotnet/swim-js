require('app-module-path').addPath '../pegex-js/lib'
modules = [
  'Swim'
  'Swim/Grammar'
  'Swim/Command'
  'Swim/Util'
  'Swim/HTML'
  'Swim/Byte'
  'Swim/Pod'
  'Swim/Markdown'
  'Swim/Tree'
  'Swim/Markup'
]

for module in modules
  test "Can require #{module}", ->
    ok require "../lib/#{module}"
