package Xceptor::Context;
use strict;
use warnings;

use Context::Micro;

use Xceptor::DB;

sub db {
    my $self = shift;
    return $self->entry(db => sub {
        Xceptor::DB->new( { %{ $self->config->{DB} }, suppress_row_objects => 1 } ),
    } );
}

1;
