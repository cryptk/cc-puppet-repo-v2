class monitoring_all {

    package { 'ruby-json':
        ensure => present,
    }

    package { 'ruby-dev':
        ensure => present,
    }

    package { 'build-essential':
        ensure => present,
    }

    $sensu_plugins = ['sensu-plugins-process-checks',
                      'sensu-plugins-puppet',
                      'sensu-plugins-ntp',
                      'sensu-plugins-network-checks',
                     ]

    package { $sensu_plugins:
        ensure   => 'installed',
        provider => sensu_gem,
    }

    file {'/etc/apt/trusted.gpg.d/sensu.gpg':
        ensure => file,
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/filestore/sensu_keyring.gpg',
        notify => Exec['apt_update'],
    }

    file {'/etc/sudoers.d/sensu_sudoers':
        ensure => file,
        owner  => root,
        group  => root,
        mode   => '0644',
        source => 'puppet:///modules/filestore/sensu_sudoers',
    }

    class { 'sensu':
        require       => [Package['ruby-json'], Package['ruby-dev'], Package['build-essential'], File['/etc/apt/trusted.gpg.d/sensu.gpg']],
        subscriptions => hiera_array('sensu::subscriptions', 'all')
    }

}

