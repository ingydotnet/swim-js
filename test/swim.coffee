require './lib/Prelude'
require './lib/parse-testml-data'
require '../lib/Swim'
Assert = require 'assert'

to_html = (swim) ->
  return swim
  (new Swim(swim)).to_html()

data = parse_testml_data '''
=== Single Regex - Single Capture
--- swim
== Swim is Great!

* You
* Know
* It
--- html
<h2>Swim is Great!</h2>
<ul>
<li>You</li>
<li>Know</li>
<li>It</li>
'''

Assert.equal 'Foo', 'Bar', 'Baz'
###
tests = []
for t in data
  continue if t.SKIP?
  if t.ONLY?
    tests = [t]
    break
  tests.push t
  break if t.LAST?

for t in tests
    Assert.equal to_html(t.swim), t.html, t.label
###
