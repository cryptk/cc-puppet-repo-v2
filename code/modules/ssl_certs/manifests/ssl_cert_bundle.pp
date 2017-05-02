define ssl_certs::ssl_cert_bundle {

    $_title = regsubst($title, '_', '.', 'G')
    warning("FOO ${_title}")

    concat {"/etc/ssl/${_title}/${_title}.bundle.crt":
        owner => root,
        group => root,
        mode  => '0644',
    }

    concat::fragment {"${_title}_crt_bundle":
        target => "/etc/ssl/${_title}/${_title}.bundle.crt",
        source => "/etc/ssl/${_title}/${_title}.crt",
        order  => 01,
    }

    concat::fragment {"${_title}_ca_bundle":
        target => "/etc/ssl/${_title}/${_title}.bundle.crt",
        source => "/etc/ssl/${_title}/${_title}.ca.crt",
        order  => 02,
    }

    concat {"/etc/ssl/${_title}/${_title}.pem":
        owner => root,
        group => root,
        mode  => '0644',
    }

    concat::fragment {"${_title}_key_pem":
        target => "/etc/ssl/${_title}/${_title}.pem",
        source => "/etc/ssl/${_title}/${_title}.key",
        order  => 01,
    }

    concat::fragment {"${_title}_crt_pem":
        target => "/etc/ssl/${_title}/${_title}.pem",
        source => "/etc/ssl/${_title}/${_title}.crt",
        order  => 02,
    }

    concat::fragment {"${_title}_ca_pem":
        target => "/etc/ssl/${_title}/${_title}.pem",
        source => "/etc/ssl/${_title}/${_title}.ca.crt",
        order  => 03,
    }

    concat::fragment {"${_title}_dhparam_pem":
        target => "/etc/ssl/${_title}/${_title}.pem",
        source => "/etc/ssl/${_title}/dhparam.pem",
        order  => 04,
    }

}
