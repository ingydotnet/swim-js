class Swim
  VERSION: '0.0.1'

  constructor: (@text)->
    @meta = {}
    @option = {}
    @debug = false

  convert: (receiver_class)->
    parser = new Pegex.Parser(
      grammar: new Swim.Grammar()
      receiver: new receiver_class(
        meta: @meta,
        option: @option,
      ),
      debug: @debug,
    )
    parser.parse(@text)

  to_pod: ->
    @convert(Swim.Pod)

  to_md: ->
    @convert(Swim.Markdown)

  to_html: ->
    require './Swim/HTML'
    @convert(Swim.HTML)

  to_txt: ->
    @convert(Swim.Text)

# sub to_txt {
#   require IPC::Run;
#   my ($self) = @_;
#   my $in = $self->convert('Swim::Pod');
#   my ($out, $err);
#   my @cmd = ('pod2text');
# 
#   IPC::Run::run(\@cmd, \$in, \$out, \$err, IPC::Run::timeout(10))
#     or die "$0: $?: $!";
#   die "$err" if $err;
# 
#   $out;
# }
# 
# sub to_man {
#   my ($self) = @_;
#   $self->get_man;
# }
# 
# sub to_pdf {
#   require IPC::Run;
#   my ($self) = @_;
#   my ($in, $out, $err) = $self->get_man;
#   my @cmd = ('groffer', '--pdf', '--to-stdout');
#   IPC::Run::run(\@cmd, \$in, \$out, \$err, IPC::Run::timeout(10))
#     or die "$cmd[0]: $?: $!";
#   die "$err" if $err;
#   $out;
# }
# 
# sub to_dvi {
#   require IPC::Run;
#   my ($self) = @_;
#   my ($in, $out, $err) = $self->get_man;
#   my @cmd = ('groffer', '--dvi', '--to-stdout');
#   IPC::Run::run(\@cmd, \$in, \$out, \$err, IPC::Run::timeout(10))
#     or die "$cmd[0]: $?";
#   die "$err" if $err;
#   $out;
# }
# 
# sub to_ps {
#   require IPC::Run;
#   my ($self) = @_;
#   my ($in, $out, $err) = $self->get_man;
#   my @cmd = ('groffer', '--ps', '--to-stdout');
#   IPC::Run::run(\@cmd, \$in, \$out, \$err, IPC::Run::timeout(10))
#     or die "$cmd[0]: $?";
#   die "$err" if $err;
#   $out;
# }
# 
# sub get_man {
#   require IPC::Run;
#   my ($self) = @_;
#   $self->option->{complete} = 1;
#   my $in = $self->convert('Swim::Pod');
#   my ($out, $err);
# 
#   my @cmd = ('pod2man', '--utf8');
#   IPC::Run::run(\@cmd, \$in, \$out, \$err, IPC::Run::timeout(10))
#     or die "$0: $? - $!";
#   die "$err" if $err;
# 
#   $out;
# }

global.Swim = Swim
require 'Pegex/Parser'
require './Swim/Grammar'

