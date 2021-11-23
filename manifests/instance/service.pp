define collectd::instance::service (
  $sysconfig = {}
) {

  if $title != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  file { "/etc/systemd/system/collectd${instance}.service.d":
    ensure => directory
  }

  file { "/etc/systemd/system/collectd${instance}.service.d/sysconfig.conf":
    ensure  => present,
    content => "[Service]\nEnvironmentFile=/etc/sysconfig/collectd${instance}",
    notify  => Service["collectd${instance}"]
  }

  file { "/etc/sysconfig/collectd${instance}":
    ensure  => present,
    content => template('collectd/systemd/sysconfig.erb'),
    notify  => Service["collectd${instance}"]
  }

  service { "collectd${instance}":
    ensure     => running,
    enable     => true,
  }

}
