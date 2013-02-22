### environment specific config
use t::Util;
use File::Spec;
use File::Basename 'dirname';
my $basedir = File::Spec->rel2abs(
    File::Spec->catdir( dirname(__FILE__), '..', '..' )
);
+{
    %{ do(File::Spec->catfile($basedir, 'etc', 'conf', 'common.pl')) },
    envname => 'test',
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
