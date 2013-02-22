package Xceptor::Context;
use strict;
use warnings;
use File::Spec;
use FindBin;

use constant CONTEXT_ENV => $ENV{PLACK_ENV} || 'development';
use constant CONFIG_FILE => $ENV{XCEPTOR_CONFIG_FILE} || File::Spec->catfile( $FindBin::Bin, 'etc', 'conf', CONTEXT_ENV.'.pl' );
use constant CONFIG => require( CONFIG_FILE );

use Xceptor::DB;

sub new {
    my $class = shift;
    return bless {
        db => Xceptor::DB->new( { %{ CONFIG->{DB} }, suppress_row_objects => 1 } ),
    }, $class;
}

sub db {
    my $self = shift;
    return $self->{db};
}

1;
