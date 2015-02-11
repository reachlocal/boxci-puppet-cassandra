class cassandra {
  file{'/tmp/apache-cassandra-release.gpg':
    source  => 'puppet:///modules/cassandra/apache-cassandra-release.gpg',
  }
  apt::key{'apache-cassandra':
    key         => '2B5C1B00',
    key_source  => '/tmp/apache-cassandra-release.gpg',
    require     => File['/tmp/apache-cassandra-release.gpg'],
  }

  apt::source { 'apache-cassandra':
    location   => 'http://mirrors.sonic.net/apache/cassandra/debian',
    release    => '20x',
    repos      => 'main',
    require    => Apt::Key['apache-cassandra'],
  }

  package { 'cassandra':
    ensure  => present,
    require => Apt::Source['apache-cassandra'],
    install_options => ['--force-yes'],
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
