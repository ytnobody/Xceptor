package Xceptor::Context::Declare;
use strict;
use warnings;
use Exporter 'import';
use Xceptor::Context;

our @EXPORT = qw( c );
our $CONTEXT //= Xceptor::Context->new;

sub c {
   return $CONTEXT;
}

1;
