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
  ]: }

  file { "${vim::vimrc}":
    ensure => present,
    source => "puppet:///modules/my_vim/vimrc"
  }

}
