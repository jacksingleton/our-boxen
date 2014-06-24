class my_jrnl {

  package { 'jrnl':
    provider => 'pip',
  }

  package { 'pycrypto':
    provider => 'pip',
  }
}
