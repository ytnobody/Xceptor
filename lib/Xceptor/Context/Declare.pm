package Xceptor::Context::Declare;
use strict;
use warnings;
use Exporter 'import';
use File::Spec;
use FindBin;
use Xceptor::Context;

use constant CONTEXT_ENV => $ENV{PLACK_ENV} || 'development';
use constant CONFIG_FILE => $ENV{XCEPTOR_CONFIG_FILE} || File::Spec->catfile( $FindBin::Bin, 'etc', 'conf', CONTEXT_ENV.'.pl' );


our @EXPORT = qw( c );
our $CONTEXT //= Xceptor::Context->new( config => require( CONFIG_FILE ) );

sub c {
   return $CONTEXT;
}

1;
