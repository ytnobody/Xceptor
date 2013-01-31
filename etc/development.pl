use strict;
use File::Spec;
use FindBin;
my $common_conf_file = File::Spec->catfile($FindBin::Bin, 'etc', 'common.pl');
my $common_conf = require $common_conf_file;

+{
    %$common_conf,
};

