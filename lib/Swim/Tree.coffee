require 'Pegex/Tree'
_ = require 'underscore'
class Swim.Tree extends Pegex.Tree

  constructor: ({@meta})->
    @meta ?= {}

#   got_block_func: (content)->
#     return {bfunc => $content}
# 
#   got_block_blank: (text)->
#     $self->add('blank')
# 
#   got_block_comment: (text)->
#     $self->add(comment => $text)
# 
#   got_line_comment: (text)->
#     $self->add(comment => $text)
# 
#   got_block_rule: (text)->
#     $self->add(rule => '')
# 
#   got_block_meta: (text)->
#     require Swim::Util
#     $self->{meta} = Swim::Util->merge_meta($self->meta, $text)
#     return

  got_block_head: (got)->
    marker = got.shift()
    text = _.chain(got)
      .filter (x)-> x
      .first()
      .value()
    text = text.replace /\n$/, ''
    level = marker.length
    @add_parse "head#{level}", text

  got_block_pref: (text)->
    text = text.replace /\n$/, ''
    text = text.replace /^  /gm, ''
    @add "pref", text

  got_block_list_bullet: (text)->
    items = _.chain(text.split /^\* /m)
      .map (s)->
        s.replace /^  /gm, ''
      .value()
    items.shift()
    items = _.chain(items)
      .map (i)=>
        item = @add_parse 'item', i, 'block-list-item'
        if item.item[0].para
          item.item[0] = item.item[0].para
        item
      .value()
    return list: items

#   got_block_list_number: (text)->
#     my @items = map {s/^  //gm; $_} split /^\+\ /m, $text
#     shift @items
#     my $items = [
#       map {
#         my $item = $self->add_parse(oitem => $_, 'block-list-item')
#         if ($item->{oitem}[0]{para}) {
#           $item->{oitem}[0] = $item->{oitem}[0]{para}
#         $item
#       } @items
#     ]
#     return { olist => $items }
# 
#   got_block_list_data: (text)->
#     content ($self, $text) = @_
#     my @items = map {s/^  //gm; $_} split /^\-\ /m, $text
#     shift @items
#     my $items = [
#       map {
#         my ($term, $def, $rest)
#         if (s/(.*?) :: +(\S.*)\n//) {
#           ($term, $def, $rest) = ($1, $2, $_)
#           $def = $self->collapse($self->parse($def))
#         else {
#           s/(.*)\n//
#           ($term, $def, $rest) = ($1, '', $_)
#         $term = $self->collapse($self->parse($term))
#         my $result = [$term, $def]
#         if (length $rest) {
#           push @$result, $self->parse($rest, 'block-list-item')
#         $result
#       } @items
#     ]
#     return { data => $items }
# 
#   got_block_title: (pair)->
#     my ($name, $abstract) = @$pair
#     if (defined $abstract) {
#       $name = $self->collapse($self->parse($name))
#       $abstract = $self->collapse($self->parse($abstract))
#       return {title => [ $name, $abstract ]}
#     else {
#       $self->add_parse(title => $name)

  got_block_verse: (text)->
    @add_parse 'verse', text

  got_block_para: (text)->
    @add_parse 'para', text

#   got_phrase_meta: (content)->
#     my $text
#     if ($content =~ /^(\w+)$/ and defined(my $value = $self->meta->{$1})) {
#       $text = $value
#     else {
#       $text = "<\$$content>"
#     return $text
#     $self->add(text => $text)
# 
#   got_phrase_func: (content)->
#     return {pfunc => $content}
# 
#   got_phrase_code: (content)->
#     $self->add(code => $content)
# 
#   got_phrase_bold: (content)->
#     $self->add(bold => $content)
# 
#   got_phrase_emph: (content)->
#     $self->add(emph => $content)
# 
#   got_phrase_del: (content)->
#     $self->add(del => $content)
# 
#   got_phrase_under: (content)->
#     $self->add(under => $content)
# 
#   got_phrase_hyper_named: (content)->
#     my ($text, $link) = @$content
#     { hyper => { link => $link, text => $text } }
# 
#   got_phrase_hyper_explicit: (content)->
#     { hyper => { link => $content, text => '' } }
# 
#   got_phrase_hyper_implicit: (content)->
#     { hyper => { link => $content, text => '' } }
# 
#   got_phrase_link_named: (content)->
#     my ($text, $link) = @$content
#     { link => { link => $link, text => $text } }
# 
#   got_phrase_link_plain: (content)->
#     { link => { link => $content, text => '' } }
# 
# #------------------------------------------------------------------------------
#   add: (tag, content)->
#     if (ref $content) {
#       $content = $content->[0]
#       if (@$content == 1) {
#         $content = $content->[0]
#       elsif (@$content > 1) {
#         $content = $self->collapse($content)
#     return { $tag => $content }

  add_parse: (tag, text, start)->
    return "#{tag}": @collapse @parse text, start

  parse: (text, start)->
    if not start?
      start = 'text-markup'
      text = text.replace /\n$/, ''
    debug = @parser.debug || false
    receiver = new Swim.Tree meta: @meta
    parser = new Pegex.Parser(
      grammar: new Swim.Grammar
        start: start
      receiver: receiver
      debug: debug
    )
    parser.parse text, start

  collapse: (content)->
    for i in [0 ... content.length]
      continue unless _.isString content[i]
      while i + 1 < content.length and _.isString content[i + 1]
        content[i] += content.splice $i + 1, 1
    content
