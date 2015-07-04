require 'Pegex/Grammar'

class (global.Swim?=->).Grammar extends Pegex.Grammar
  file: '../swim-pm/ext/swim-pgx/swim.pgx'

  start_rules: [
    'document',
    'text-markup',
    'block-list-item',
  ]

  make_tree: ->
    {}
