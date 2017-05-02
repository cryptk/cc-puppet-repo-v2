class webserver {

    #include ssl_certs

    class {'nginx':
        manage_repo => false,
    }

    file {'/etc/nginx/global':
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => '0755',
        recurse => true,
        purge   => true,
    }

    file {'/etc/nginx/global/common.conf':
        ensure => file,
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/filestore/nginx_common.conf',
        notify => Service['nginx'],
    }

    $sensu_plugins = ['sensu-plugins-php-fpm',
                      'sensu-plugins-http',
                     ]

    package { $sensu_plugins:
        ensure   => 'installed',
        provider => sensu_gem,
    }

    sensu::check { 'check_nginx_process':
        command     => '/opt/sensu/embedded/bin/check-process.rb -p nginx -c 5 -C 5',
        require     => Package['sensu-plugins-process-checks'],
        subscribers => 'webserver',
        standalone  => true,
    }

}
