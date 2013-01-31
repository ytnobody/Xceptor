package Xceptor::Context;
use strict;
use warnings;
use File::Spec;
use FindBin;
use constant CONFIG => require File::Spec->catfile( $FindBin::Bin, 'etc', $ENV{PLACK_ENV}.'.pl' );

use Xceptor::DB;

sub new {
    my $class = shift;
    return bless {
        db => Xceptor::DB->new( CONFIG->{DB} ),
    }, $class;
}

sub db {
    my $self = shift;
    return $self->{db};
}

1;
