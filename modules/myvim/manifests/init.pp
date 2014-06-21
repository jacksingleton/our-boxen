class myvim {

  file { "${vim::vimrc}":
    ensure => present,
    source => "puppet:///modules/myvim/vimrc"
  }

}
