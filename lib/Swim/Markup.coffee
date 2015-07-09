require '../Swim/Tree'
require 'underscore'
class Swim.Markup extends Swim.Tree
  constructor: ->
    @option = {}

final = (tree)->
  die 42
  @stack = []
  @bullet = []
  out = @render tree
  if @option.complete
    if @.render_complete?
      out = @render_complete out
  out

render = (node)->
  if _.isString node
    out = @render_text node
  else if _.isArray node
    separator = @get_separator node
    out = _.chain(node)
      .map (x)->
        @render x
      .filter (x)->
        Boolean x.length
      .value()
      .join separator
  else if typeof node == 'object'
    out = @render_node node
  return out

###
render_node = ->
    my ($self, $hash) = @_;
    my ($name, $node) = each %$hash;
    my $number = $name =~ s/(\d)$// ? $1 : 0;
    my $method = "render_$name";
    push @{$self->{stack}}, $name;
    my $out = $self->$method($node, $number);
    pop @{$self->{stack}};
    $out;

render_pfunc = ->
    my ($self, $node) = @_;
    if ($node =~ /^([\-\w]+)(?:[\ \:]|\z)((?s:.*)?)$/) {
        my ($name, $args) = ($1, $2);
        my $out = @_render_func(phrase => $name, $args);
        return $out if defined $out;
    return "<$node>";

render_bfunc = ->
    my ($self, $content) = @_;
    my ($name, $args) = @$content;
    $args = '' unless defined $args;
    my $out = @_render_func(block => $name, $args);
    return $out if defined $out;
    if ($args) {
        chomp $args;
        return "<<<$name\n$args\n>>>\n";
    else {
        return "<<<$name>>>\n";

_render_func = ->
    my ($self, $type, $name, $args) = @_;
    (my $method = "${type}_func_$name") =~ s/-/_/g;
    (my $plugin = "Swim::Plugin::$name") =~ s/-/::/g;
    while (1) {
        if ($self->can($method)) {
            my $out = $self->$method($args);
            return $out if defined $out;
        last if $plugin eq "Swim::Plugin";
        eval "require $plugin";
        $plugin =~ s/(.*)::.*XXX/$1/;
    return;

my $phrase_types = {
    map { ($_, 1) } qw(
        code
        bold
        emph
        del
        under
        hyper
        link
        pfunc
        text
    ) };

#------------------------------------------------------------------------------
# Separator controls
#------------------------------------------------------------------------------
use constant default_separator => '';
use constant top_block_separator => '';

get_separator = ->
    my ($self, $node) = @_;
    @at_top_level ? @top_block_separator : @default_separator;

at_top_level = ->
    @{$_[0]->{stack}} == 0

node_is_block = ->
    my ($self, $node) = @_;
    my ($type) = keys %$node;
    return($phrase_types->{$type} ? 0 : 1);
###
