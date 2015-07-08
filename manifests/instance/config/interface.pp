define collectd::instance::config::interface (
  $interface = '[]',
  $ignore_selected = false,
  $version = 'present'
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  case $::operatingsystemrelease {
    /^[56]\./: {

      file { "/etc/collectd${instance}.d/interface":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }

      file { "/etc/collectd${instance}.d/interface/init.conf":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('collectd/plugins/interface.conf.erb'),
      }

      Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Interface[$title] ~> Collectd::Instance::Service[$title]
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }
}
