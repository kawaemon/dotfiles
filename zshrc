source ~/.bashrc.shared

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

export MANPAGER='nvim +Man!'
export MANWIDTH=999

export RUSTC_WRAPPER="sccache"


if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ ! -f ~/.zr.zsh ]] || [[ ~/.zshrc.shared -nt ~/.zr.zsh ]]; then
    zr zsh-users/zsh-syntax-highlighting \
    > ~/.zr.zsh
    zcompile ~/.zr.zsh
fi

source ~/.zr.zsh

autoload -U compinit && compinit

source <(mise activate zsh)
source <(starship init zsh)

if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi
if command -v rustup >/dev/null 2>&1; then
  source <(rustup completions zsh)
fi

# force use emacs mode
# zsh infers key mode by EDITOR
bindkey -e

tm
