require boxen::environment
require homebrew
require gcc


Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {

  include my_vim
  include my_osx_defaults
  include my_git

  include dnsmasq
  include hub
  include macvim
  include firefox
  include vagrant
  include java
  include screenhero

  class { 'intellij':
    edition => 'ultimate',
    version => '12.1.6'
  }

  package { 'GPGTools':
    name => 'Install.pkg',
    provider => 'pkgdmg',
    source => 'https://releases.gpgtools.org/GPG%20Suite%20-%202013.10.22.dmg',
  }

  package { [
    'ack',
    'findutils',
    'gnu-tar',
    'gpg',
  ]: }

  # default ruby versions
  ruby::version { '2.1.2': }

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
