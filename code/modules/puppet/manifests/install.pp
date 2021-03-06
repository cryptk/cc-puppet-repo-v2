class puppet::install {

    include apt

    apt::source {'puppetlabs-pc1':
        location => 'http://apt.puppetlabs.com',
        repos    => 'PC1',
        key      => {
            id     => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
            server => 'pgp.mit.edu',
        },
    }

    package {'puppet-agent':
        ensure  => latest,
        require => [
            Apt::Source['puppetlabs-pc1'],
            Class['apt::update'],
        ]
    }
}
