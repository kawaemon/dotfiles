if [[ -z "${TMUX}" ]]; then
    tmux
fi

alias ls=exa
alias cat=bat

alias sl=ls
alias v=nvim
alias lg=lazygit
alias vimdiff="nvim -d"
alias cz="nvm exec default cz"
alias repo='__D=`ghq list | fzf` && cd "$HOME/repo/$__D"'
alias f='__D=`fzf` && cd $__D'

setopt nomatch \
       correct \
       automenu \
       list_packed \
       extendedglob \
       interactive_comments

unsetopt beep

zstyle ':completion:*' menu select=5 # highlight selection in menu

autoload -Uz compinit && compinit

eval "$(zr jeffreytse/zsh-vi-mode \
       zsh-users/zsh-autosuggestions \
       zsh-users/zsh-syntax-highlighting \
       junegunn/fzf.git/shell/key-bindings.zsh)"

export BAT_THEME="Solarized (dark)"

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER='nvim +Man!'
export MANWIDTH=999

export RUSTC_WRAPPER="sccache"

export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

gpgconf --launch gpg-agent
