class cassandra {
  apt::source { 'apache-cassandra':
    key        => '2B5C1B00',
    key_server => 'pgp.mit.edu',
    location   => 'http://www.apache.org/dist/cassandra/debian',
    release    => '20x',
    repos      => 'main',
  }

  package { 'cassandra':
    ensure  => present,
    require => Apt::Source['apache-cassandra'],
  }

  file { "cassandra.yml":
    path => "/etc/cassandra/cassandra.yaml",
    owner => "root",
    group => "root",
    require => Package['cassandra'],
    source => "puppet:///modules/cassandra/cassandra.yaml",
  }

  service { 'cassandra':
    name => 'cassandra',
    ensure => running,
    enable => true,
    subscribe => File['cassandra.yml'],
  }
}
