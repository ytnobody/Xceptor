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
