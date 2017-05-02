class base {
    include apt, puppet, ntp, rackspace_monitoring_agent, monitoring_client
    package {['sysstat', 'vim', 'update-notifier-common']:
        ensure => latest,
    }

    file {'/etc/default/sysstat':
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => "# THIS FILE IS MANAGED BY PUPPET\n\nENABLED=\"true\"\n",
    }

    $local_users = hiera_hash('local_users', undef)
    if ($local_users) {
      create_resources('local_user', $local_users)
    }

    resources { 'cron':
        purge => true,
    }

}
