class holland::service {

    cron {'holland':
        ensure  => present,
        command => '/usr/sbin/holland -q bk',
        user    => root,
        minute  => 0,
        hour    => 7,
        require => Package['holland']
    }

}
