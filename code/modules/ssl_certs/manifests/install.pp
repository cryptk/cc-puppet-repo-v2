class ssl_certs::install {

    $ssl_certs = hiera('ssl_certs')
    ssl_certs::ssl_cert_set {$ssl_certs: }

}
