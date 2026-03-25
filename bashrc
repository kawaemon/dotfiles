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
alias speedtest='speedtest -s 48463'

if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
elif command -v vim >/dev/null 2>&1; then
  export EDITOR=vim
elif command -v vi >/dev/null 2>&1; then
  export EDITOR=vi
fi

export VISUAL=$EDITOR

alias v=$EDITOR
alias vi=$EDITOR
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

__prompt_shell=
__prompt_host_token=
__prompt_path_token=
__prompt_reset=
__prompt_host_color=
__prompt_path_color=
__prompt_git_color=
__prompt_git_flag_color=
__prompt_symbol_color=
__prompt_symbol_error_color=
__prompt_git_timeout_sec='0.1'
__prompt_git_timeout_cmd=
__prompt_has_rendered=
: "${__prompt_timeout_warned:=}"

if [[ -n $BASH_VERSION ]]; then
  __prompt_shell='bash'
  __prompt_host_token='\h'
  __prompt_path_token='\w'
  __prompt_reset='\[\e[0m\]'
  __prompt_host_color='\[\e[33m\]'
  __prompt_path_color='\[\e[36m\]'
  __prompt_git_color='\[\e[32m\]'
  __prompt_git_flag_color='\[\e[31m\]'
  __prompt_symbol_color='\[\e[34m\]'
  __prompt_symbol_error_color='\[\e[31m\]'
elif [[ -n $ZSH_VERSION ]]; then
  __prompt_shell='zsh'
  __prompt_host_token='%m'
  __prompt_path_token='%~'
  __prompt_reset=$'%{\e[0m%}'
  __prompt_host_color=$'%{\e[33m%}'
  __prompt_path_color=$'%{\e[36m%}'
  __prompt_git_color=$'%{\e[32m%}'
  __prompt_git_flag_color=$'%{\e[31m%}'
  __prompt_symbol_color=$'%{\e[34m%}'
  __prompt_symbol_error_color=$'%{\e[31m%}'
fi

# Use timeout when available so one bad repo cannot stall the prompt.
__prompt_git_run() {
  if [[ -n $__prompt_git_timeout_cmd ]]; then
    GIT_OPTIONAL_LOCKS=0 "$__prompt_git_timeout_cmd" "$__prompt_git_timeout_sec" "$@" 2>/dev/null
  else
    GIT_OPTIONAL_LOCKS=0 "$@" 2>/dev/null
  fi
}

# Normalize the porcelain header into a branch-like label for the prompt.
__prompt_git_branch_from_header() {
  local branch=$1

  branch=${branch#'## '}
  branch=${branch%%...*}

  case "$branch" in
    'No commits yet on '*)
      printf '%s\n' "${branch#'No commits yet on '}"
      ;;
    'Initial commit on '*)
      printf '%s\n' "${branch#'Initial commit on '}"
      ;;
    HEAD|'HEAD ('*')')
      printf '?\n'
      ;;
    *)
      printf '%s\n' "$branch"
      ;;
  esac
}

# Convert one porcelain status line into compact prompt flags.
__prompt_git_flags_from_line() {
  local line=$1
  local flags=
  local x y

  case "$line" in
    '?? '*)
      printf '?\n'
      return
      ;;
  esac

  x=${line:0:1}
  y=${line:1:1}

  if [[ $x == U || $y == U || ($x == A && $y == A) || ($x == D && $y == D) ]]; then
    flags+='*'
  fi
  if [[ $x != ' ' && $x != '?' && $x != U ]]; then
    flags+='+'
  fi
  if [[ $y != ' ' && $y != '?' && $y != U ]]; then
    flags+='!'
  fi

  printf '%s\n' "$flags"
}

# Build a compact git summary from porcelain output.
__prompt_git() {
  local line branch flags line_flags

  while IFS= read -r line; do
    case "$line" in
      '## '*)
        branch=$(__prompt_git_branch_from_header "$line") || return
        ;;
      *)
        line_flags=$(__prompt_git_flags_from_line "$line")
        [[ $line_flags == *+* && $flags != *+* ]] && flags+='+'
        [[ $line_flags == *'!'* && $flags != *'!'* ]] && flags+='!'
        [[ $line_flags == *\?* && $flags != *\?* ]] && flags+='?'
        [[ $line_flags == *\** && $flags != *\** ]] && flags+='*'
        ;;
    esac
  done < <(__prompt_git_run git status --porcelain --branch)

  [[ -n $branch ]] || return
  printf '%s\n' "$branch" "$flags"
}

# Rebuild PS1 on every prompt so git state and last exit status stay current.
__update_prompt() {
  local last_status=$?
  local git_part git_branch git_flags symbol_color

  # Add one blank line between command output and the next prompt, but not on first render.
  if [[ -n $__prompt_has_rendered ]]; then
    printf '\n'
  fi
  __prompt_has_rendered=1

  git_part="$(__prompt_git)"
  PS1="${__prompt_host_color}${__prompt_host_token}${__prompt_reset} ${__prompt_path_color}${__prompt_path_token}${__prompt_reset}"
  if [[ -n $git_part ]]; then
    if [[ $git_part == *$'\n'* ]]; then
      git_branch=${git_part%%$'\n'*}
      git_flags=${git_part#*$'\n'}
    else
      git_branch=$git_part
      git_flags=
    fi
    PS1+=" ${__prompt_git_color}git:${git_branch}${__prompt_reset}"
    if [[ -n $git_flags ]]; then
      PS1+="[${__prompt_git_flag_color}${git_flags}${__prompt_reset}]"
    else
      PS1+='[]'
    fi
  fi
  PS1+=$'\n'
  # Only the prompt symbol changes color on failure so the rest stays stable.
  symbol_color=$__prompt_symbol_color
  if [[ $last_status -ne 0 ]]; then
    symbol_color=$__prompt_symbol_error_color
  fi
  PS1+="${symbol_color}>${__prompt_reset} "

  if [[ $__prompt_shell == 'zsh' ]]; then
    PROMPT=$PS1
  fi
}

# Only interactive shells need prompt hooks.
if [[ $- == *i* && -n $__prompt_shell ]]; then
  __prompt_git_timeout_cmd=$(command -v timeout 2>/dev/null)
  if [[ -z $__prompt_git_timeout_cmd ]]; then
    __prompt_git_timeout_cmd=$(command -v gtimeout 2>/dev/null)
  fi
  if [[ -z $__prompt_git_timeout_cmd && -z $__prompt_timeout_warned ]]; then
    printf 'warning: timeout/gtimeout not found; git prompt timeout is disabled\n' >&2
    __prompt_timeout_warned=1
  fi

  if [[ $__prompt_shell == 'bash' ]]; then
    PROMPT_COMMAND=__update_prompt
  elif [[ $__prompt_shell == 'zsh' ]]; then
    if [[ ${precmd_functions[(Ie)__update_prompt]} -eq 0 ]]; then
      precmd_functions+=(__update_prompt)
    fi
    __update_prompt
  fi
fi
