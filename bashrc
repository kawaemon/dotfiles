alias ls='ls -h --color'
alias grep='grep --color'
alias sl=ls

alias lg='lazygit'
alias repo='__D=`ghq list | fzf` && cd "$HOME/repo/$__D"'
alias kubesw='__D=`ls -d ~/.kube/*config* | fzf` && eval "export KUBECONFIG=$__D"'
alias temp='mkdir -p /tmp/ktmp && __D=`mktemp -d /tmp/ktmp/XXX` && cd "$__D"'
alias npm='corepack npm'
alias yarn='corepack yarn'
alias pnpm='corepack pnpm'
alias ports='ss -tulnp'

if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
elif command -v vim >/dev/null 2>&1; then
  export EDITOR=vim
elif command -v vi >/dev/null 2>&1; then
  export EDITOR=vi
fi

alias v=$EDITOR
alias vim=$EDITOR
alias nvim=$EDITOR

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

export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH"
