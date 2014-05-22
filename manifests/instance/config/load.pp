define collectd::instance::config::load (
  $version='present'
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  case $::operatingsystemrelease {
    /^[56]\./: {

      file { "/etc/collectd${instance}.d/load":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }

      # Create /etc/collectd${instance}.d/load/init.conf
      file { "/etc/collectd${instance}.d/load/init.conf":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => 'LoadPlugin load',
      }

      Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Load[$title] ~> Collectd::Instance::Service[$title]
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }
}
