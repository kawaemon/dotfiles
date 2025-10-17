alias ls='ls -h --color'

if ! command -v nvim >/dev/null 2>&1; then
  alias nvim=vim
fi

alias sl=ls
alias v=nvim
alias sv=sudoedit
alias lg='lazygit'
alias repo='__D=`ghq list | fzf` && cd "$HOME/repo/$__D"'
alias temp='mkdir -p /tmp/ktmp && __D=`mktemp -d /tmp/ktmp/XXX` && cd "$__D"'
alias npm='corepack npm'
alias yarn='corepack yarn'
alias pnpm='corepack pnpm'

# 古いルータなど...
alias lssh='ssh \
    -o KexAlgorithms=+diffie-hellman-group14-sha1,diffie-hellman-group1-sha1 \
    -o Ciphers=+aes256-cbc,aes128-cbc \
    -o HostKeyAlgorithms=+ssh-rsa \
    -o SetEnv=TERM=xterm'

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

export NODE_OPTIONS="--stack-trace-limit=1000"
export RUST_BACKTRACE=1

export EDITOR="vim"
export VISUAL="vim"

