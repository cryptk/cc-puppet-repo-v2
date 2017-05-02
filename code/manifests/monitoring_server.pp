class monitoring_server {

    include ssl_certs, monitoring_all

    package { 'redis-server':
        ensure => present,
    }

    class { 'rabbitmq':
        service_manage    => false,
        port              => '5672',
        delete_guest_user => true,
        ssl               => true,
        ssl_only          => false,
        ssl_key           => '/etc/ssl/wc.cryptkcoding.com/wc.cryptkcoding.com.key',
        ssl_cert          => '/etc/ssl/wc.cryptkcoding.com/wc.cryptkcoding.com.crt',
        ssl_cacert        => '/etc/ssl/wc.cryptkcoding.com/wc.cryptkcoding.com.ca.crt',
    }

    rabbitmq_user { 'sensu':
        admin    => false,
        password => hiera('sensu::rabbitmq_password'),
        tags     => ['monitoring'],
    }

    rabbitmq_vhost { '/sensu':
        ensure => present,
    }

    rabbitmq_user_permissions { 'sensu@/sensu':
        configure_permission => '.*',
        read_permission      => '.*',
        write_permission     => '.*',
        require              => [Rabbitmq_user['sensu'], Rabbitmq_vhost['/sensu']],
    }


    class { '::uchiwa':
        install_repo => false,
    }

    class {'nginx':
        manage_repo => false,
    }


}
