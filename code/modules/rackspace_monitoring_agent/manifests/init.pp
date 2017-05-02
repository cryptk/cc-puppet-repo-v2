class rackspace_monitoring_agent {
    include rackspace_monitoring_agent::install
    include rackspace_monitoring_agent::config
    include rackspace_monitoring_agent::service
}
