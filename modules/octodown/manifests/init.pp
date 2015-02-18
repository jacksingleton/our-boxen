class octodown {

  package { [
    'icu4c',
    'cmake',
    'pkg-config'
  ]: }

  # Strange error when this is in boxen, fails on:
  # Debug: Executing '/opt/boxen/rbenv/shims/gem install --no-rdoc --no-ri octodown'
  # BUT `sudo /opt/boxen/rbenv/shims/gem install --no-rdoc --no-ri octodown` works from
  # the command line
  #package { 'octodown':
  #  ensure => 'latest',
  #  provider => 'gem',
  #}

}
