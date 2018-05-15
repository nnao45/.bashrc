# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
#if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \e[$[32+$RANDOM % 5]m\]=> \[\033[01;36m\]\w\n\e[$[32+$RANDOM % 5]m\]>\e[$[32+$RANDOM % 5]m\]>\e[$[32+$RANDOM % 5]m\]>\[\e[0m\] '
else
    PS1='\u@\h:\W\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
     PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

if [ "$(uname)" = 'Darwin' ]; then
    alias ls='ls -G'
else
    #eval `dircolors ~/.colorrc`
    alias ls='ls --color=auto'
fi

alias ll='ls -l'
alias la='ls -la'
alias l='ls -CF'
alias t='tmux'

if [ "$(uname)" = 'Darwin' ]; then
	alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
	alias vim='env_LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
else
	alias vi='/usr/bin/vi'
	alias vim='/usr/bin/vim'
fi

alias nkf8='nkf -w --overwrite ./*'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

export LANGUAGE='ja_JP.UTF-8'
export LC_CTYPE='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'

if [ "$(uname)" = 'Darwin' ]; then
	export GOBIN=/Users/XXXX/go/bin
	export GOROOT=/Users/XXXX/go
	export GOPATH=/Users/XXXX/go-third-party
	export PATH=$PATH:/Users/XXXX/.nodebrew/current/bin
else
	export GOBIN=/usr/src/go/bin
	export GOROOT=/usr/src/go
	export GOPATH=/usr/src/go-third-party
fi

if [[ $TERM = screen ]] || [[ $TERM = screen-256color ]] ; then
    LOGDIR=$HOME/Documents/term_logs
    LOGFILE=$(hostname)_$(date +%Y-%m-%d_%H%M%S_%N.log)
    [ ! -d $LOGDIR ] && mkdir -p $LOGDIR
    tmux  set-option default-terminal "screen" \; \
        pipe-pane        "cat >> $LOGDIR/$LOGFILE" \; \
        display-message  "💾Started logging to $LOGDIR/$LOGFILE"
fi

function sk {
    mkdir "$1" ; touch "$1"/"$1.scala"
}

function reverse {
    if [ -p /dev/stdin ] ; then
        local input=$(cat -)

        echo "${input}" | while read line; do
            local array=()
            for e in ${line[@]}; do
                array=(${e} "${array[@]}") 
            done

            echo "${array[@]}"
        done
    else
        echo "no stdin."
    fi
}

function tkill {
    tmux kill-session -t "$1"
}

function tkillall {
    tmux kill-server
}

function who {
    tail -n +5 /etc/hosts | grep --color "$1"
}

function see {
    local HOST=`tail -n +5 /etc/hosts | peco | awk '{print $1}'`
    #commentout imple
    if echo "${HOST}" | grep '^#' > /dev/null; then
        echo "it's comment out"
    else
	    adssh ${HOST}
    fi
}

function pane {
    ## get options ##
    while getopts :s opt
    do
    case $opt in
	    "s" ) readonly FLG_S="TRUE" ;;
	    * ) usage; exit 1 ;;
    esac
    done

    shift `expr $OPTIND - 1`
    ## tmux pane split ##
    if [ $1 ]; then
    cnt_pane=1
    while [ $cnt_pane -lt $1 ]
    do
    if [ $(( $cnt_pane & 1 )) ]; then
 	    tmux split-window -h
    else
 	    tmux split-window -v
    fi
    tmux select-layout tiled 1>/dev/null
    cnt_pane=$(( $cnt_pane + 1 ))
    done
    fi
    
    #OPTION: start session with "synchronized-panes"
    if [ "$FLG_S" = "TRUE" ]; then
        tmux set-window-option synchronize-panes 1>/dev/null
    fi
}

export HISTCONTROL="ignoredups"
function peco-history {
    local NUM=$(history | wc -l)
    local FIRST=$((-1*(NUM-1)))

    if [ $FIRST -eq 0 ] ; then
        # Remove the last entry, "peco-history"
        history -d $((HISTCMD-1))
        echo "No history" >&2
        return
    fi

    local CMD=$(fc -l $FIRST | sort -k 2 -k 1nr | uniq -f 1 | sort -nr | sed -E 's/^[0-9]+[[:blank:]]+//' | peco | head -n 1)

    if [ -n "$CMD" ] ; then
    # Replace the last entry, "peco-history", with $CMD
    history -s $CMD

    if type osascript > /dev/null 2>&1 ; then
      # Send UP keystroke to console
        (osascript -e 'tell application "System Events" to keystroke (ASCII character 30)' &)
    fi

    else
        # Remove the last entry, "peco-history"
        history -d $((HISTCMD-1))
    fi
}
bind '"\C-r":"peco-history\n"'

export LSCOLORS=gxfxcxdxbxegedabagacad
tabs -4
export PATH=$GOPATH/bin:$PATH
export PATH=$GOROOT/bin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
