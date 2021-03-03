define collectd::instance::config::processes(
  $process_items={}
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  file { "/etc/collectd${instance}.d/processes":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { "/etc/collectd${instance}.d/processes/init.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/plugins/processes/init.conf.erb"),
    require => File["/etc/collectd${instance}.d/processes"],
    notify  => Service["collectd${instance}"]
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Processes[$title] ~> Collectd::Instance::Service[$title]
}
