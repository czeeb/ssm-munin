# munin::master - Define a munin master
#
# The munin master will install munin, and collect all exported munin
# node definitions as files into /etc/munin/munin-conf.d/.
#
# Parameters:
#
# - node_definitions: A hash of node definitions used by
#   create_resources to make static node definitions.
#
class munin::master ($node_definitions={}) {

  # The munin package and configuration
  package { 'munin':
    ensure => latest,
  }

  file { '/etc/munin/munin.conf':
    content => template('munin/munin.conf.erb'),
    require => Package['munin'],
    owner   => 'root',
    group   => 'munin',
    mode    => '0444',
  }

  file { '/etc/munin/munin-conf.d':
    ensure  => directory,
    recurse => true,
    purge   => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  # Collect all exported node definitions
  Munin::Master::Node_definition <<| |>>

  # Create static node definitions
  create_resources(munin::master::node_definition, $node_definitions, {})
}
