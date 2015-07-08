define collectd::instance::config::memory (
  $version='present'
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  case $::operatingsystemrelease {
    /^[56]\./: {

      file { "/etc/collectd${instance}.d/memory":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }

      # Create /etc/collectd${instance}.d/memory/init.conf
      file { "/etc/collectd${instance}.d/memory/init.conf":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => 'LoadPlugin memory',
      }

      Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Memory[$title] ~> Collectd::Instance::Service[$title]
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }
}
