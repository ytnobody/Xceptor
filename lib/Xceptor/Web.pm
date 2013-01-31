package Xceptor::Web;
use strict;
use warnings;
use Nephia;

get '/' => sub {
    +{ template => 'index.tx', title => 'Xceptor' };
};

1;
