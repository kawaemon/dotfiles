if [[ -z "${TMUX}" ]]; then
    tmux
fi

alias ls=exa
alias cat=bat

alias sl=ls
alias v=nvim
alias lg='HUSKY=0 lazygit'
alias vimdiff="nvim -d"
alias repo='__D=`ghq list | fzf` && cd "$HOME/repo/$__D"'
alias temp='mkdir -p /tmp/ktmp && __D=`mktemp -d /tmp/ktmp/XXX` && cd "$__D"'
alias gitd='DFT_DISPLAY=inline GIT_EXTERNAL_DIFF=difft git'
alias airplane='rfkill block all'
alias unairplane='rfkill unblock all'
alias npm='corepack npm'
alias yarn='corepack yarn'
alias pnpm='corepack pnpm'

setopt nomatch \
       correct \
       automenu \
       list_packed \
       extendedglob \
       interactive_comments

unsetopt beep

zstyle ':completion:*' menu select=5 # highlight selection in menu

export BAT_THEME="Solarized (dark)"

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

export RUST_BACKTRACE=1

export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER='nvim +Man!'
export MANWIDTH=999

export RUSTC_WRAPPER="sccache"

export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

export NODE_OPTIONS="--stack-trace-limit=1000"
gpgconf --launch gpg-agent

if [[ ! -f ~/.zr.zsh ]] || [[ ~/.zshrc.shared -nt ~/.zr.zsh ]]; then
    zr kawaemon/zsh-vi-mode \
       zsh-users/zsh-autosuggestions \
       zsh-users/zsh-syntax-highlighting \
       junegunn/fzf.git/shell/key-bindings.zsh \
    > ~/.zr.zsh
    zcompile ~/.zr.zsh
fi

source ~/.zr.zsh

# automatically called by .zr.zsh
# autoload -U compinit && compinit

eval "$(starship init zsh)"
