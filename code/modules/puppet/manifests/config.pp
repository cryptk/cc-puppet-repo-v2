class puppet::config {

#    file {'hieradir':
#        ensure => directory,
#        path   => '/etc/hiera',
#        owner  => puppet,
#        group  => puppet,
#        mode   => '0755',
#    }
#
#    class {'hiera':
#        hierarchy => [
#            'secure',
#            'node/%{::fqdn}',
#            'env/%{::environment}',
#            'common',
#        ],
#        eyaml       => true,
#        create_keys => false,
#        confdir     => '/etc/hiera',
#        hiera_yaml  => '/etc/hiera/hiera.yaml',
#        require     => File['hieradir'],
#    }
#
#    file {'hiera-public-key':
#        ensure => file,
#        path   => '/etc/hiera/keys/public_key.pkcs7.pem',
#        source => 'puppet:///modules/puppet/hiera/public_key.pkcs7.pem',
#        owner  => puppet,
#        group  => puppet,
#        mode   => '0644',
#    }

}
