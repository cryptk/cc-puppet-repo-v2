class rackspace_monitoring_agent::config {

    $username = hiera('rackspace::username', undef)
    $api_key = hiera('rackspace::api_key', undef)

    if ($username != undef) and ($api_key != undef) {
        exec{'rackspace_monitoring_agent_config':
            command => "/usr/bin/rackspace-monitoring-agent --setup --username ${username} --apikey ${api_key}",
            creates => '/etc/rackspace-monitoring-agent.cfg',
        }
    }

}
