class puppet::service {

    service {'puppet':
        ensure => stopped,
        enable => false,
    }

    cron { 'puppet-apply':
        ensure  => present,
        command => 'cd /etc/puppetlabs && /usr/bin/git pull -q && puppet apply /etc/puppetlabs/code/manifests --logdest /var/log/puppetlabs/puppet/puppet.log',
        user    => root,
        minute  => '*/30',
    }

}
