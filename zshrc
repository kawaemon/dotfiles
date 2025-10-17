alias ls='ls -h --color'

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

function dockerawslogin() {
    local region=$(aws configure get region)
    local accountid=$(aws sts get-caller-identity --query Account --output text)
    aws ecr get-login-password --region $region | \
        docker login --username AWS --password-stdin $accountid.dkr.ecr.$region.amazonaws.com
}
function tm() {
    if [[ "$TERM_PROGRAM" != "vscode" && -z "$TMUX" ]]; then
        tmux
    fi
}

# man zshoptions
setopt nomatch \
       correct \
       automenu \
       list_packed \
       extendedglob \
       interactive_comments

export HISTFILE=$HOME/.zshhistory
export HISTSIZE=100000
export SAVEHIST=1000000
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt share_history    # share history between all zsh
setopt nonomatch        # useful when using curl or wget

unsetopt extended_history # add more information on history file
unsetopt beep

zstyle ':completion:*' menu select=5 # highlight selection in menu

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

export NODE_OPTIONS="--stack-trace-limit=1000"
export RUST_BACKTRACE=1

export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER='nvim +Man!'
export MANWIDTH=999

export RUSTC_WRAPPER="sccache"

export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH"

autoload -U compinit && compinit

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ ! -f ~/.zr.zsh ]] || [[ ~/.zshrc.shared -nt ~/.zr.zsh ]]; then
    zr kawaemon/zsh-vi-mode \
       zsh-users/zsh-syntax-highlighting \
       junegunn/fzf.git/shell/key-bindings.zsh \
    > ~/.zr.zsh
 # zsh-users/zsh-autosuggestions \
    zcompile ~/.zr.zsh
fi

source ~/.zr.zsh

eval "$(mise activate zsh)"
eval "$(starship init zsh)"

[[ /usr/bin/kubectl ]] && source <(kubectl completion zsh)

tm
