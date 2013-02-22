package t::Util;
use strict;
use warnings;
use File::Spec;
use FindBin;
use File::Which 'which';
use Exporter 'import';

our @EXPORT = qw/ TEST_DB_NAME /;

$ENV{PLACK_ENV} = 'test';
$ENV{XCEPTOR_CONFIG_FILE} =  File::Spec->catfile( $FindBin::Bin, '..', 'etc', 'conf', 'test.pl' );

use constant TRAVIS => $ENV{TRAVIS};
use constant MYSQL_BIN => $ENV{MYSQL_BIN} || which('mysql');
use constant TEST_DB_NAME => $ENV{TEST_DB_NAME} || 'xceptor_test';
use constant DUMPFILE => -e File::Spec->catfile($FindBin::Bin, '..', 'misc', 'xceptor.mysql.dump') ?
    File::Spec->catfile($FindBin::Bin, '..', 'misc', 'xceptor.mysql.dump') :
    File::Spec->catfile($FindBin::Bin, 'misc', 'xceptor.mysql.dump') 
;

### skip db fixture step under travis environment.
if( TRAVIS ) {
    warn "A build under travis environment";
}
else {
    system sprintf("%s -u root -e 'DROP DATABASE IF EXISTS %s;'", MYSQL_BIN, TEST_DB_NAME);
    system sprintf("%s -u root -e 'CREATE DATABASE %s;'", MYSQL_BIN, TEST_DB_NAME);
    system sprintf("%s -u root %s < %s", MYSQL_BIN, TEST_DB_NAME, DUMPFILE);
}


1;
