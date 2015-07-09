global.Swim.Markup ?= class
require '../Swim/Markup'
_ = require 'underscore'

class global.Swim.HTML extends Swim.Markup
  top_block_separator: "\n"

  document_title: ''

  info:
    verse:
      tag: 'p'
      style: 'block'
      transform: 'transform_verse'
      attrs: ' class="verse"'

  render_text: (text)->
    text = text.replace /\n/, " "
    _.escape text

  render_para: (node)->
    out = @render(node)
    out = out.replace /\n$/, ''
    spacer = if out.match /\n/ then "\n" else ''
    "<p>#{spacer}#{out}#{spacer}</p>\n"

  render_rule:
    "<hr/>\n"

  render_blank:
    "<br/>\n"

  render_list: (node)->
    out = @render(node)
    out = out.replace /\n$/, ""
    "<ul>\n#{out}\n</ul>\n"

  render_item: (node)->
    out = @render(node)
    out = out.replace /(.)(<(?:ul|pre|p)(?: |>))/, "\$1\n\$2"
    spacer = if out.match /\n/ then "\n" else ''
    "<li>#{out}#{spacer}</li>\n"

  render_olist: (node)->
    out = @render(node)
    out = out.replace /\n$/, ""
    "<ol>\n#{out}\n</ol>\n"

  render_oitem: (node)->
    @render_item(node)

  render_data: (node)->
    out = "<dl>\n"
    for item in node
      [item, def, rest] = item
      term = @render(term)
      out += "<dt>#{term}</dt>\n"
      if def.length || rest
        out += "<dd>"
        if def.length
          out += @render(def) + "\n"
        if rest
          out += @render(rest) + "\n"
        out += "<dd>\n"
    out + "</dl>\n"

  render_pref: (node)->
    out = escape_html node
    "<pre><code>$out\n</code></pre>\n"


  render_pfunc: (node)->
    if node.match /^(\w[\-\w]*) ?((?s:.*)?)$/
      [name, args] = [RegExp.$1, RegExp.$2]
      name = name.replace /-/g, "-"
      method = "phrase_func_#{name}"
      if @[method]?
        out = @[method](args)
        return out if out?
    "&lt;#{node}&gt;"


#   render_title: (node)->
#     [name, abstract] = if typeof node == 'object' \
#       then node else [null, node]
#     name = @render(name)
#     if abstract?
#         abstract = @render(abstract)
#         document_title = "#{name} - #{abstract}"  # how was this before?
#         "<h1 class=\"title\">#{name}</h1>\n\n<p>#{abstract}</p>\n"
# 
#     else {
#         $document_title = "$name"
#         spacer = $name =~ /\n/ ? "\n" : ''
#         "<h1 class=\"title\">$spacer$name$spacer</h1>\n"
# 
# 
# 
  render_head: (node, number)->
    out = @render node
    # chomp $out
    "<h#{number}>#{out}</h#{number}>\n"

# 
#   render_comment: (node)->
#     out = _.escape($node)
#     if ($out =~ /\n/) {
#         "<!--\n$out\n-->\n"
# 
#     else {
#         "<!-- $out -->\n"
# 
# 
# 
#   render_code: (node)->
#     out = @render($node)
#     "<code>$out</code>"
# 
# 
#   render_bold: (node)->
#     out = @render($node)
#     "<strong>$out</strong>"
# 
# 
#   render_emph: (node)->
#     out = @render($node)
#     "<em>$out</em>"
# 
# 
#   render_del: (node)->
#     out = @render($node)
#     "<del>$out</del>"
# 
# 
#   render_under: (node)->
#     out = @render($node)
#     "<u>$out</u>"
# 
# 
#   render_hyper: (node)->
#     my ($link, $text) = @{$node}{qw(link text)}
#     $text = $link if not length $text
#     "<a href=\"$link\">$text</a>"
# 
# 
#   render_link: (node)->
#     my ($link, $text) = @{$node}{qw(link text)}
#     $text = $link if not length $text
# 
#     # XXX Temporary hack for inline grant blog
#     # We can solve this in a formal and extensible way later.
#     if (defined $ENV{SWIM_LINK_FORMAT_HACK}) {
#         $link = "https://metacpan.org/pod/$link"
# 
# 
#     "<a href=\"$link\">$text</a>"
# 
# 
#   render_complete: (out)->
#     chomp $out
#     <<"..."
# <!DOCTYPE html>
# <html>
# <head>
#   <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
#   <title>$document_title</title>
#   <link href="//swimtext.org/assets/default.css" rel="stylesheet" type="text/css">
# </head>
# <body>
# <div class="swim content">
# 
# $out
# 
# </div>
# </body>
# </html>
# ...
# 
# 
# #------------------------------------------------------------------------------
#   format_phrase_func_html {
#     my ($self, $tag, $class, $attrib, $content) = @_
#     attribs = ''
#     if (@$class) {
#         $attribs = ' class="' . join(' ', @$class) . '"'
# 
#     if (@$attrib) {
#         $attribs = ' ' . join(' ', map {
#             /=".*"$/ ? $_ : do { s/=(.*)/="$1"/; $_ }
#         } @$attrib)
# 
#     length($content)
#     ? "<$tag$attribs>$content</$tag>"
#     : "<$tag$attribs/>"
# 
# 
#   phrase_func_bold: (args)->
#     my ($success, $class, $attrib, $content) =
#         @parse_phrase_func_args_html($args)
#     return unless $success
#     @format_phrase_func_html('strong', $class, $attrib, $content)
# 
# 
#   parse_phrase_func_args_html: (args)->
#     my ($class, $attrib, $content) = ([], [], '')
#     $args =~ s/^ //
#     if ($args =~ /\A((?:\\:|[^\:])*):((?s:.*))\z/) {
#         $attrib = $1
#         $content = $2
#         $attrib =~ s/\\:/:/g
#         ($class, $attrib) = @parse_attrib($attrib)
# 
#     else {
#         $content = $args
# 
#     return 1, $class, $attrib, $content
# 
# 
#   parse_attrib: (text)->
#     my ($class, $attrib) = ([], [])
#     while (length $text) {
#         if ($text =~ s/^\s*(\w[\w\-]*)(?=\s|\z)\s*XXX//) {
#             push @$class, $1
# 
#         elsif ($text =~ s/^\s*(\w[\w\-]*="[^"]*")(?=\s|\z)s*XXX//) {
#             push @$attrib, $1
# 
#         elsif ($text =~ s/^\s*(\w[\w\-]*=\S+)(?=\s|\z)s*XXX//) {
#             push @$attrib, $1
# 
#         else {
#             last
# 
# 
#     return $class, $attrib
