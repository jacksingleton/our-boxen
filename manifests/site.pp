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
  include my_jrnl

  include dnsmasq
  include hub
  include macvim
  include vagrant
  include java
  include screenhero
  include transmission

  class { 'intellij':
    edition => 'ultimate',
    version => '12.1.6'
  }

  class { 'firefox':
    version => '31.0',
  }

  #package { 'GPGTools':
  #  name => 'Install.pkg',
  #  provider => 'pkgdmg',
  #  source => 'https://releases.gpgtools.org/GPG%20Suite%20-%202013.10.22.dmg',
  #}

  package { 'leiningen': }

  package { 'Colloquy':
    source => 'http://colloquy.info/downloads/colloquy-latest.zip',
    provider => 'compressed_app'
  }

  package { 'Virtualbox':
    source => 'http://download.virtualbox.org/virtualbox/4.3.12/VirtualBox-4.3.12-93733-OSX.dmg',
    provider => 'pkgdmg',
  }

  package { 'Dash':
    source => 'http://london.kapeli.com/Dash.zip',
    provider => 'compressed_app',
  }

  package { 'Rust':
    source => 'http://static.rust-lang.org/dist/rust-nightly-x86_64-apple-darwin.pkg',
    provider => 'pkgdmg',
  }

  package { 'Adium':
    source => 'http://downloads.sourceforge.net/project/adium/Adium_1.5.10.dmg?r=&ts=1421171902&use_mirror=softlayer-dal',
    provider => 'appdmg',
  }

  package { 'BitTorrent Sync':
    source => 'http://download.getsyncapp.com/endpoint/btsync/os/osx/track/stable',
    provider => 'appdmg',
  }

  #package { 'Kiwix':
  #  source => 'http://download.kiwix.org/bin/0.9/kiwix-0.9.dmg',
  #  provider => 'appdmg',
  #}

  package { 'sbt': }

  package { 'cvs': }

  package { 'youtube-dl': }

  package { [
    'ack',
    'findutils',
    'gnu-tar',
    'wget',
    'python3',
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
