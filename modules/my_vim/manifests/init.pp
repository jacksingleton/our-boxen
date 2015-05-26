class my_vim {

  include vim

  vim::bundle { [
    'kien/ctrlp.vim',
    'Yggdroot/indentLine',
    'msanders/snipmate.vim',
    'airblade/vim-gitgutter',
    'Raimondi/delimitMate',
    'scrooloose/nerdtree',
    'guns/vim-clojure-static',
    'tpope/vim-fugitive',
    'tpope/vim-sensible',
    'jnurmine/Zenburn',
    'wting/rust.vim',
    'vimoutliner/vimoutliner',
    'vim-scripts/closetag.vim',
    'hallison/vim-markdown',
  ]: }

  file { "${vim::vimrc}":
    ensure => "present",
    source => "puppet:///modules/my_vim/vimrc"
  }

  file { "${vim::vimdir}/ftplugin/": ensure => "directory" }

  file { "${vim::vimdir}/ftplugin/votl.vim":
    ensure => "present",
    source => "puppet:///modules/my_vim/ftplugin/votl.vim"
  }

}
