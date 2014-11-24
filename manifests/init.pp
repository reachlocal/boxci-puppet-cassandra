class cassandra {
  apt_key{'apache-cassandra':
    ensure => 'present',
    id     => '2B5C1B00',
    source => 'https://www.apache.org/dist/cassandra/debian/dists/20x/Release.gpg',
  }

  apt::source { 'apache-cassandra':
    key        => '2B5C1B00',
    location   => 'http://mirrors.sonic.net/apache/cassandra/debian',
    release    => '20x',
    repos      => 'main',
    require    => Apt_key['apache-cassandra'],
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
