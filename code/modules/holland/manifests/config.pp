class holland::config {
    $plugin = hiera('holland::plugin', 'mysqldump')
    $backups_to_keep = hiera('holland::backups_to_keep', 1)
    $auto_purge_failures = hiera('holland::auto_purge_failures', 'yes')
    $purge_policy = hiera('holland::purge_policy', 'after-backup')
    $estimated_size_factor = hiera('holland::estimated_size_factor', 1.0)

    file {'/etc/holland/backupsets/default.conf':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template('holland/backupsets_default.conf.erb'),
        require => Package['holland'],
    }
}

