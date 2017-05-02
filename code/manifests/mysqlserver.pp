class mysqlserver {

    include apt, holland
    #include apt, holland, ssl_certs


    # The following two files are needed to increase the open file limit for MySQL
    file {'/etc/security/limits.d/mysql-limits.conf':
        ensure => present,
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/filestore/mysql-limits.conf',
    }
    file {'/etc/pam.d/su':
        ensure => present,
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/filestore/pam.d_su',
    }

    # Use MySQL 5.6 from upstream
    apt::source {'mysql':
        location   => "http://repo.mysql.com/apt/${lsbdistid_downcase}/",
        release    => "${::lsbdistcodename}",
        repos      => 'mysql-5.6',
        key        => {
            id     => 'A4A9406876FCBD3C456770C88C718D3B5072E1F5',
            server => 'pgp.mit.edu',
        }
    }

    class {'::mysql::server':
        root_password                            => hiera('mysql::user::root::password', 'default'),
        remove_default_accounts                  => true,
        package_ensure                           => '5.6.17-1ubuntu14.04',
        restart                                  => true,
        override_options                         => {
            'mysqld'                             => {
                'innodb_file_per_table'          => 1,
                'innodb_buffer_pool_size'        => '256M',
                'innodb_log_file_size'           => '64M',
                'innodb_flush_log_at_trx_commit' => 1,
                'innodb_flush_method'            => 'O_DIRECT',
                'max-connections'                => 256,
                'max_connect_errors'             => 4294967295,
                'sql_mode'                       => 'NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES',
                'symbolic-links'                 => 0,
                'ssl'                            => true,
                'ssl-ca'                         => '/etc/ssl/wc.cryptkcoding.com/wc.cryptkcoding.com.ca.crt',
                'ssl-cert'                       => '/etc/ssl/wc.cryptkcoding.com/wc.cryptkcoding.com.crt',
                'ssl-key'                        => '/etc/ssl/wc.cryptkcoding.com/wc.cryptkcoding.com.key',
            }
        }
    }

    # Upstream MySQL does not come with a logrotate configuration
    logrotate::rule {'mysql-community-server':
        path          => '/var/log/mysql/mysql.log /var/log/mysql/mysql-slow.log /var/log/mysql/error.log',
        rotate_every  => 'day',
        rotate        => 7,
        missingok     => true,
        create        => true,
        create_mode   => 640,
        create_owner  => 'mysql',
        create_group  => 'adm',
        compress      => true,
        sharedscripts => true,
        postrotate    => '
            test -x /usr/bin/mysqladmin || exit 0
            # If this fails, check debian.conf! 
            MYADMIN="/usr/bin/mysqladmin --defaults-file=/etc/mysql/debian.cnf"
            if [ -z "`$MYADMIN ping 2>/dev/null`" ]; then
              # Really no mysqld or rather a missing debian-sys-maint user?
              # If this occurs and is not a error please report a bug.
              #if ps cax | grep -q mysqld; then
              if killall -q -s0 -umysql mysqld; then
                exit 1
              fi
            else
              $MYADMIN flush-logs
            fi',
    }

    package { 'libmysqlclient-dev':
        ensure => 'installed',
    }

    $sensu_plugins = ['sensu-plugins-mysql',
                     ]
    package { $sensu_plugins:
        ensure   => 'installed',
        provider => sensu_gem,
        require  => Package['libmysqlclient-dev']
    }

    sensu::check { 'mysql_alive':
        command     => '/opt/sensu/embedded/bin/check-mysql-alive.rb -u root -p :::mysql.password::: -s /var/run/mysqld/mysqld.sock -d mysql',
        require     => Package['sensu-plugins-mysql'],
        subscribers => 'mysqlserver',
        standalone  => true,
    }

}
