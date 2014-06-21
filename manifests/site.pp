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

  include dnsmasq
  include git
  include hub
  include macvim
  include firefox

  include osx::global::enable_keyboard_control_access
  include osx::global::enable_standard_function_keys
  include osx::global::disable_remote_control_ir_receiver
  include osx::global::tap_to_click
  class { 'osx::global::key_repeat_delay':
    delay => 12
  }
  include osx::global::key_repeat_rate
  class { 'osx::global::natural_mouse_scrolling':
    enabled => false
  }
  include osx::dock::autohide
  include osx::dock::2d
  include osx::dock::disable
  include osx::finder::empty_trash_securely
  include osx::universal_access::ctrl_mod_zoom
  include osx::keyboard::capslock_to_control
  boxen::osx_defaults { 'Startup Terminal Settings':
    ensure => present,
    domain => 'com.apple.Terminal',
    key => 'Startup Window Settings',
    value => 'Pro',
    type => string,
    user => $::boxen_user;
  }
  boxen::osx_defaults { 'Default Terminal Settings':
    ensure => present,
    domain => 'com.apple.Terminal',
    key => 'Default Window Settings',
    value => 'Pro',
    type => string,
    user => $::boxen_user;
  }

  class { "vagrant": }

  #include python

  include vim

  vim::bundle { [
    'kien/ctrlp.vim',
    'Yggdroot/indentLine',
    'msanders/snipmate.vim',
    'Lokaltog/vim-easymotion',
    'airblade/vim-gitgutter',
    'Raimondi/delimitMate',
    'scrooloose/nerdtree',
    'guns/vim-clojure-static',
    'tpope/vim-fugitive',
    'tpope/vim-sensible',
    'jnurmine/Zenburn',
  ]: }

  include myvim


  git::config::global { 'user.name':
    value  => 'Jack Singleton'
  }

  git::config::global { 'user.email':
    value  => 'git@jacksingleton.com'
  }

  git::config::global { 'color.ui':
    value => 'true'
  }

  git::config::global { 'push.default':
    value => 'current'
  }

  git::config::global { 'alias.st':
    value => 'status'
  }

  git::config::global { 'alias.ci':
    value => 'commit -v'
  }

  git::config::global { 'alias.br':
    value => 'branch'
  }

  git::config::global { 'alias.df':
    value => 'diff'
  }

  git::config::global { 'alias.lg':
    value => 'log -p'
  }

  git::config::global { 'alias.co':
    value => 'checkout'
  }

  git::config::global { 'alias.aa':
    value => 'add -A'
  }

  git::config::global { 'alias.dc':
    value => 'diff --cached'
  }

  git::config::global { 'alias.cm':
    value => 'commit -m'
  }

  git::config::global { 'alias.purr':
    value => 'pull --rebase'
  }

  git::config::global { 'alias.pair':
    value => '!sh -c \'git config --global user.name $0+$1 && git config --global user.email eng_green+$0+$1@loyal3.com\''
  }

  git::config::global { 'alias.solo':
    value => '!sh -c \'git config --global user.name $0 && git config --global user.email $0@loyal3.com\''
  }

  git::config::global { 'alias.who':
    value => '!sh -c \'echo \"`git config --global user.name` <`git config --global user.email`>\"\''
  }

  git::config::global { 'alias.set-ticket':
    value => '!sh -c \'git config ticket.current $0 && echo \"[$0]\" > \"$(git rev-parse --show-toplevel)/.git/commit.message\" && git config commit.template \"$(git rev-parse --show-toplevel)/.git/commit.message\"\''
  }

  git::config::global { 'alias.ticket':
    value => '!sh -c \'git config --get ticket.current\''
  }

  git::config::global { 'alias.local-branches':
    value => "for-each-ref refs/heads/ --format='%(refname)'",
  }

  git::config::global { 'alias.ticket-branch':
    value => "!git ticket && git local-branches | sed 's/refs\\\\/heads\\\\///g' | grep `git ticket`",
  }

  git::config::global { 'alias.push-ticket':
    value => "!git ticket && git push origin `git ticket-branch`",
  }

  git::config::global { 'alias.psh':
    value => '!sh -c \'git push -u ${1:-origin} $(git symbolic-ref HEAD)\''
  }

  git::config::global { 'alias.old-merged-branches':
    value => '"!for k in $(git branch -r --merged master | grep -v \'\\->\' | sed s/^..//);do echo $(git log -1 --pretty=format:\"%ci %cr\" \"$k\")\\\\t\"$k\";done | sort"'
  }


  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # default ruby versions
  ruby::version { '2.1.2': }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
