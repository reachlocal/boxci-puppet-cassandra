class cassandra {
  apt::key { '0353B12C':
    key_server => 'pool.sks-keyservers.net',
    before     => Apt::Source['apache-cassandra']
  }

  apt::key { '2B5C1B00':
    key_server => 'pool.sks-keyservers.net',
    before     => Apt::Source['apache-cassandra']
  }

  apt::source { 'apache-cassandra':
    location   => 'http://mirrors.sonic.net/apache/cassandra/debian',
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
