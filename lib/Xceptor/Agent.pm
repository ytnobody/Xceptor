package Xceptor::Agent;
use strict;
use warnings;
use Furl;
use HTTP::Request::Common;
use JSON;
use Carp;

our $VERSION = 0.01;
our $INSTANCE //= Furl->new( 
    agent   => __PACKAGE__. '/'. $VERSION, 
    timeout => 2,
);

sub new {
    my ($class, %opts) = @_;
    bless {%opts}, $class;
}

sub report {
    my ($self, %opts) = @_;
    my ($caller_class, $caller_file, $line) = caller();
    $opts{body} //= undef;
    $opts{reported_by} //= $caller_file.':'.$line ;
    my $req = POST $self->{base_url}.'/api/report/'.$self->{project}, [ %opts ];
    my $res = $INSTANCE->request($req);
    unless ($res->is_success) {
        carp __PACKAGE__.' Request failed : CODE['.$req->code.']';
        return;
    }
    my $json = JSON->new->utf8->decode( $res->content );
    return $json->{report};
}

1;

__END__

=head1 NAME

Xceptor::Agent - Reporter Agent for Xceptor

=head1 SYNOPSIS

  use Carp;
  use Xceptor::Agent;
  my $agent = Xceptor::Agent->new(
      base_url => 'http://url.to.your/xceptor/',
      project  => 'myproject',
  );
  
  sub notify {
      my $message = shift;
      carp "ERROR: $message";
      my $report = $agent->report(
          title => substr( $message, 0, 30 ),
          body  => $message,
      );
      carp "Reporting Failure" unless $report;
  }
  
  sub my_work {
      my $data = shift;
      unless ( $data ) {
          notify('Data was not pass');
      }
  }

=head1 AUTHOR

ytnobody

=cut

