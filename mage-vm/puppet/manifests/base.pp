$as_vagrant = 'sudo -u vagrant -H bash -l -c'
$home       = '/home/vagrant'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

## Preinstall #####################################

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':
    unless => "test -e ${home}/.rvm"
  }
}
class { 'apt_get_update':
  stage => preinstall
}


## Basics #####################################

package { ['curl', 'build-essential', 'git-core', 'unzip']:
  ensure => installed
}


## PostgreSQL #####################################

class { 'postgresql::globals':
  encoding => 'UTF8',
  locale => 'en_US.UTF-8'
}->
class { 'postgresql::server': }

$pg_user = 'mage-pg'
$pg_pass = 'scrummage'

postgresql::server::role { $pg_user:
  username => $pg_user,
  password_hash => postgresql_password($pg_user, $pg_pass),
  createdb => true,
  superuser => true
}

postgresql::server::db { 'mage-dev':
  user     => $pg_user,
  password => $pg_pass,
  require  => Postgresql::Server::Role[$pg_user]
}

postgresql::server::db { 'mage-test':
  user     => $pg_user,
  password => $pg_pass,
  require  => Postgresql::Server::Role[$pg_user]
}

postgresql::server::db { 'mage-prod':
  user     => $pg_user,
  password => $pg_pass,
  require  => Postgresql::Server::Role[$pg_user]
}

package { 'libpq-dev':
  ensure => installed
}

package { 'postgresql-contrib':
  ensure => installed,
  require => Class['postgresql::server'],
}


## SQLite #####################################

package { ['sqlite3', 'libsqlite3-dev']:
  ensure => installed
}


## Node.js ####################################

class { 'nodejs':
  version => 'v0.10.26',
}


## PhantomJS ##################################

class phantomjs (
  $package_version = '1.9.7', # set package version to download
  $source_file = "phantomjs-$package_version-linux-i686.tar.bz2",
  $source_url = "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$package_version-linux-i686.tar.bz2",
  $source_dir = '/opt',
  $install_dir = '/usr/local/bin',
  $package_update = false
) {
  # Dependencies
  package { ['libfontconfig', 'libfontconfig-dev', 'libfreetype6-dev']:
    ensure => installed
  }

  exec { 'get-phantomjs':
    command => "/usr/bin/wget -P $source_dir $source_url \
      && mkdir $source_dir/phantomjs \
      && tar xvf $source_dir/$source_file -C $source_dir \
      && mv $source_dir/phantomjs-$package_version-linux-i686/* $source_dir/phantomjs/ \
      && rm -rf $source_dir/phantomjs-$package_version-linux-i686*",
    creates => "$source_dir/phantomjs/",
    require => Package['curl', 'unzip'],
    unless => "test -e $source_dir/phantomjs/bin/phantomjs"
  }

  file { "$install_dir/phantomjs":
    ensure => link,
    target => "$source_dir/phantomjs/bin/phantomjs",
    force => true
  }

  if $package_update {
    exec { 'remove phantomjs':
      command => "/bin/rm -rf $source_dir/phantomjs",
      notify => Exec[ 'get-phantomjs' ]
    }
  }
} 

class { 'phantomjs':
  package_version => '1.9.7',
  package_update => false,
  install_dir => '/usr/local/bin',
  source_dir => '/opt'
}


## Ruby/Rails #################################

# Nokogiri dependencies
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  creates => "${home}/.rvm/bin/rvm",
  require => Package['curl'],
  unless => "test -e ${home}/.rvm/bin/rvm"
}

exec { 'install_ruby':
  # We run the rvm executable directly because the shell function assumes an
  # interactive environment, in particular to display messages or ask questions.
  # The rvm executable is more suitable for automated installs.
  #
  # use a ruby patch level known to have a binary
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install ruby-2.0.0-p353 --binary --autolibs=enabled && rvm alias create default 2.0'",
  creates => "${home}/.rvm/bin/ruby",
  require => Exec['install_rvm'],
  unless => "test -e ${home}/.rvm/bin/ruby"
}

exec { "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'":
  creates => "${home}/.rvm/bin/bundle",
  require => Exec['install_ruby']
}
