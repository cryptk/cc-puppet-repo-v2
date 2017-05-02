class rackspace_monitoring_agent::service {

    service{'rackspace-monitoring-agent':
        ensure => running,
        enable => true,
    }

}
