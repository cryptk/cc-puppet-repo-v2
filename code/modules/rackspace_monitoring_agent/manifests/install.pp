class rackspace_monitoring_agent::install {

    include apt

    apt::source {'rackspace-monitoring-agent':
        location => 'http://stable.packages.cloudmonitoring.rackspace.com/ubuntu-14.04-x86_64',
        release  => 'cloudmonitoring',
        key      => {
            id     => '84971191C39CAE2CC0E4C9B1A086F077D05AB914',
            source => 'https://monitoring.api.rackspacecloud.com/pki/agent/linux.asc',
        }
    }

    package {'rackspace-monitoring-agent':
        ensure  => latest,
        require => [
            Apt::Source['rackspace-monitoring-agent'],
            Class['apt::update'],
        ]
    }

}
