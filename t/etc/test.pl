use strict;

use File::Spec;
use FindBin;
use File::Which 'which';

use constant TRAVIS => $ENV{TRAVIS};
use constant MYSQL_BIN => $ENV{MYSQL_BIN} || which('mysql');
use constant TEST_DB_NAME => $ENV{TEST_DB_NAME} || 'xceptor_test';

my $dumpfile = File::Spec->catfile($FindBin::Bin, '..', 'misc', 'xceptor.mysql.dump');

### skip db fixture step under travis environment.
if( TRAVIS ) {
    warn "A build under travis environment";
} 
else {
    system sprintf("%s -u root -e 'DROP DATABASE IF EXISTS %s;'", MYSQL_BIN, TEST_DB_NAME); 
    system sprintf("%s -u root -e 'CREATE DATABASE %s;'", MYSQL_BIN, TEST_DB_NAME);
    system sprintf("%s -u root %s < %s", MYSQL_BIN, TEST_DB_NAME, $dumpfile);
}

+{
    DB => {
        connect_info => [
            'dbi:mysql:'. TEST_DB_NAME,
            'root',
            undef,
            {
                RaiseError => 1,
                mysql_auto_reconnect => 1,
                mysql_enable_utf8    => 1,
            },
        ],
    },
};

