class holland::install {

    include apt

    apt::source {'holland':
        location   => 'http://download.opensuse.org/repositories/home:/holland-backup/xUbuntu_14.04/',
        repos      => './',
        release    => ' ',
        key        => {
            id     => '5B31400395D88EF2FCA55ECF40A402AF984D0514',
            source => 'http://download.opensuse.org/repositories/home:/holland-backup/xUbuntu_14.04/Release.key',
        }
    }

    package {'holland':
        ensure  => latest,
        require => [
            Apt::Source['holland'],
            Class['apt::update'],
        ]
    }
}
