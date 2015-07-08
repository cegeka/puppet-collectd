define collectd::instance::config::cpu (
  $version='present'
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  case $::operatingsystemrelease {
    /^[56]\./: {

      file { "/etc/collectd${instance}.d/cpu":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }

      # Create /etc/collectd${instance}.d/cpu/init.conf
      file { "/etc/collectd${instance}.d/cpu/init.conf":
        ensure  => file
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => 'LoadPlugin cpu',
      }

    Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Cpu[$title] ~> Collectd::Instance::Service[$title]
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }
}
