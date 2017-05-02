class ssl_certs::config {

    $ssl_certs = hiera('ssl_certs', undef)
    if $ssl_certs != undef {
        ssl_certs::ssl_cert_bundle {$ssl_certs: }
    }

}
