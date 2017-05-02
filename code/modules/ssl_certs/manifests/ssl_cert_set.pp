define ssl_certs::ssl_cert_set {

    $_title = regsubst($title, '_', '.', 'G')

    file {"/etc/ssl/${_title}":
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => "puppet:///modules/ssl_certs/${_title}",
        recurse => true,
        purge   => true,
    }

    file {"/etc/ssl/${_title}/${_title}.key":
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0444',
        content => hiera("ssl_certs::${title}"),
    }
}
