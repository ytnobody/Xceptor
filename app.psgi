use strict;
use warnings;
use FindBin;
use File::Spec;
use File::Basename 'dirname';

use lib ("$FindBin::Bin/lib", "$FindBin::Bin/extlib/lib/perl5");
use Xceptor;
my $basedir = dirname(__FILE__);
my $config_name = $ENV{PLACK_ENV} || 'development';
Xceptor->run( %{do(File::Spec->catfile($basedir, 'etc', 'conf', $config_name.'.pl'))} );
