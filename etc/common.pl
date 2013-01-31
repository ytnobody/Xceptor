+{
    DB => {
        connect_info => [
            'dbi:mysql:xceptor',
            'root',
            undef,
            {
                RaiseError           => 1,
                mysql_auto_reconnect => 1, 
                mysql_enable_utf8    => 1,
            },
        ],
    },
};
