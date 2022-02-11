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

autoload -Uz compinit && compinit

export BAT_THEME="Solarized (dark)"

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER='nvim +Man!'

export RUSTC_WRAPPER="sccache"

export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

gpgconf --launch gpg-agent

source ~/.cargo/env

# Vim key bindings
# from: https://github.com/shun-shobon/dotfiles/blob/master/.config/zsh/rc/keybind.zsh
bindkey -d
bindkey -v

KEYTIMEOUT=1

bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

function zle-keymap-select() {
    case ${KEYMAP} in
        vicmd)
            print -n '\033[2 q'
            ;;
        viins|main)
            print -n '\033[6 q'
            ;;
    esac
    zle reset-prompt
    zle -R
}

function zle-line-init() {
    zle-keymap-select
}

function zle-line-finish() {
    print -n '\033[6 q'
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
