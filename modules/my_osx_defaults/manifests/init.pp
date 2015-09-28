class my_osx_defaults {

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

  boxen::env_script { 'history-profile':
    content => "shopt -s histappend; HISTSIZE=10000; PROMPT_COMMAND='history -a; history -n'"
  }

  boxen::env_script { 'colors-for-ls':
    content => "export CLICOLOR=1"
  }

  boxen::env_script { 'list-recent-files':
    content => "alias lsr=\"CLICOLOR_FORCE=1 ls -lt | head\""
  }

  boxen::env_script { 'httpdump':
    content => "alias httpdump=\"sudo tcpdump -A 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'\""
  }

  boxen::env_script { 'gw':
    content => "alias gw=./gradlew"
  }

  boxen::env_script { 'java-home':
    content => "export JAVA_HOME=$(/usr/libexec/java_home)"
  }
}
