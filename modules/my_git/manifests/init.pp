class my_git {

  include git

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
    value => '!sh -c \'git config --global user.name $0+$1 && git config --global user.email $0+$1@jacksingleton.com\''
  }

  git::config::global { 'alias.solo':
    value => '!sh -c \'git config --global user.name $0 && git config --global user.email $0@jacksingleton.com\''
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

}
