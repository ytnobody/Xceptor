use strict;
use t::Util;

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

