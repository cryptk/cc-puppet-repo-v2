node default {
    include base
}

node 'cryptkcoding' {
    include base
    include webserver, mysqlserver

    logrotate::rule {'heatherjowett_nginx':
        path          => '/srv/heatherjowett/logs/*nginx.log',
        rotate_every  => 'week',
        missingok     => true,
        rotate        => 52,
        compress      => true,
        delaycompress => true,
        ifempty       => false,
        create        => true,
        create_mode   => '0640',
        create_owner  => 'www-data',
        create_group  => 'adm',
        sharedscripts => true,
        prerotate     => 'if [ -d /etc/logrotate.d/httpd-prerotate ]; then run-parts /etc/logrotate.d/httpd-prerotate; fi',
        postrotate    => '[ -s /run/nginx.pid ] && kill -USR1 `cat /run/nginx.pid`',
    }

    logrotate::rule {'heatherjowett_fpm':
        path          => '/srv/heatherjowett/logs/*.fpm.log',
        rotate        => 12,
        rotate_every  => 'week',
        missingok     => true,
        ifempty       => false,
        compress      => true,
        delaycompress => true,
        create        => true,
        create_mode   => '0644',
        create_owner  => 'www_hj_com',
        create_group  => 'nogroup',
        postrotate    => '/usr/lib/php5/php5-fpm-reopenlogs',
    }

    file {'/etc/nginx/global/minecraft.htpasswd':
        ensure => file,
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/filestore/nginx.minecraft.htpasswd',
        notify => Service['nginx'],
    }

}

node 'watcher' {
    include base
    include monitoring_server

    $sensu_plugins = ['sensu-plugins-php-fpm',
                      'sensu-plugins-http',
                      'sensu-plugins-wordpress',
                     ]
    package {$sensu_plugins:
        ensure   => present,
        provider => sensu_gem,
    }
}
