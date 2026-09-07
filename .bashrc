# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT="%F %T"
HISTIGNORE='ls:ll:la:l:cd:pwd:exit:clear:history'

shopt -s checkwinsize
shopt -s globstar

# lesspipe for non-text files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# color prompt
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ls alias
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

. "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#default editor
export EDITOR='nvim'
export VISUAL="nvim"

#neovim shortcut
alias nv='nvim'

#some quick edit configs
alias nvimrc='nvim ~/.config/nvim/init.lua'
alias bashrc='nvim ~/.bashrc'
alias kittyrc='nvim ~/.config/kitty/kitty.conf'

#Kitten alias, very very useful
alias diff="kitten diff" #diff 
alias ssh="kitten ssh" # convinient ssh
alias icat="kitten icat" # display images
alias dnd="kitten dnd" # drag and drop
alias download="kitten transfer" # transfer files from remote to local
alias upload="kitten transfer --direction=upload" # upload files from local to remote


# auto-activate .venv for the nearest project (walks up from $PWD)
_auto_venv() {
    local _ec=$? dir="$PWD" found=""

    while true; do
        if [[ -f "$dir/.venv/bin/activate" ]]; then
            found="$dir/.venv"
            break
        fi
        [[ "$dir" == "/" ]] && break
        dir="${dir%/*}"
        [[ -n "$dir" ]] || dir="/"
    done

    if [[ -n "$VIRTUAL_ENV" && "$VIRTUAL_ENV" != "$found" ]]; then
        deactivate >/dev/null 2>&1
   fi

    if [[ -n "$found" && "$VIRTUAL_ENV" != "$found" ]]; then
        source "$found/bin/activate"
    fi

    return "$_ec"
}

case "$PROMPT_COMMAND" in
    *_auto_venv*) ;;
    '') PROMPT_COMMAND=_auto_venv ;;
    *)  PROMPT_COMMAND="$PROMPT_COMMAND;_auto_venv" ;;
esac

#flutter 
export PATH=$HOME/develop/flutter/bin:$PATH

#nvidia tool kit 
export PATH=${PATH}:/usr/local/cuda-13.0/bin:$PATH
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda-13.0/lib64:$LD_LIBRARY_PATH

# rust cargo
. "$HOME/.cargo/env"

# go lang configs
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

# java
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"

# Android SDK (FTC Gradle / adb / jdtls import)
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/platform-tools:$PATH"

# Grok Build CLI
export PATH="$HOME/.grok/bin:$PATH"
[[ -r "$HOME/.grok/completions/bash/grok.bash" ]] && source "$HOME/.grok/completions/bash/grok.bash"

# Resolve Grok Build and Cursor CLI both using agent
# Grok Build uses Grok
# Cursor CLI uses cursor
[[ -L "$HOME/.grok/bin/agent" ]] && rm -f "$HOME/.grok/bin/agent"
if [[ -L "$HOME/.local/bin/agent" ]]; then
  _agent_target="$(readlink -f "$HOME/.local/bin/agent" 2>/dev/null || true)"
  case "$_agent_target" in
    *cursor-agent*|*grok*) rm -f "$HOME/.local/bin/agent" ;;
  esac
  unset _agent_target
fi
if [[ -x "$HOME/.local/bin/cursor-agent" ]]; then
  if [[ ! -e "$HOME/.local/bin/cursor" || -L "$HOME/.local/bin/cursor" ]]; then
    ln -sfn cursor-agent "$HOME/.local/bin/cursor"
  fi
fi
hash -d agent 2>/dev/null || true
alias cursor-app='/usr/bin/cursor'
