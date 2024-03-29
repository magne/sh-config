# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

[ -s "$HOME/.bash_local" ] && . "$HOME/.bash_local"

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
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -n "$DISPLAY" ]; then
    if [ "$COLORTERM" == "gnome-terminal" -o "$TERM" == "xterm" ]; then
        if [ "$TERM" != "screen-256color" ]; then
            export TERM='xterm-256color'
        fi
    fi
elif [[ "$TERM" =~ xterm.* ]]; then
    if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
    else
        export TERM='xterm-color'
    fi
elif [ "$TERM" == "linux" ]; then
    force_color_prompt=yes
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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
    if [[ -z "`which git 2> /dev/null`" || "`type -t __git_ps1`" != 'function' ]]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\e[32m\]\u@\h\[\e[00m\]:\[\e[34m\]\w\[\e[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\e[32m\]\u@\h\[\e[m\]:\[\e[m\]\w\[\e[31m\]$(__git_ps1 " (%s)")\[\e[m\]\$ '
    fi
else
    if [[ -z "`which git 2> /dev/null`" || "`type -t __git_ps1`" != 'function' ]]; then
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1 " (%s)")\$ '
    fi
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if [ -f ~/.bash_wrap_aliases ]; then
    . ~/.bash_wrap_aliases
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

export EDITOR=vim

if [ -f /usr/share/source-highlight/src-hilite-lesspipe.sh ]; then
    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
    export LESS=' -R '
fi

if [[ -z "$JAVA_HOME" && ! -z "`which java 2> /dev/null`" && -d /etc/alternatives ]]; then
    if [[ -z "`readlink /etc/alternatives/java | grep jre`" ]]; then
        export JAVA_HOME=$(dirname $(dirname $(readlink /etc/alternatives/java)))
    else
        export JAVA_HOME=$(dirname $(dirname $(dirname $(readlink /etc/alternatives/java))))
    fi
    export JDK_HOME=$JAVA_HOME
fi

if [[ -z "$M2_HOME" && -z "`which mvn 2> /dev/null`" ]]; then
    if [[ -d $HOME/opt/apache-maven || -d /opt/apache-maven ]]; then
        if [[ -d $HOME/opt/apache-maven ]]; then
            export M2_HOME=$HOME/opt/apache-maven
        else
            export M2_HOME=/opt/apache-maven
        fi
        export PATH=$PATH:$M2_HOME/bin
        export MAVEN_OPTS='-Xmx768M -XX:MaxPermSize=256m -XX:+UseCompressedOops'
    fi
fi

if [[ -z "$ANT_HOME" && -z "`which ant 2> /dev/null`" ]]; then
    if [[ -d $HOME/opt/apache-ant || -d /opt/apache-ant ]]; then
        if [[ -d $HOME/opt/apache-ant ]]; then
            export ANT_HOME=$HOME/opt/apache-ant
        else
            export ANT_HOME=/opt/apache-ant
        fi
        export PATH=$PATH:$ANT_HOME/bin
    fi
fi

if [[ -z "$GRADLE_HOME" && -z "`which gradle 2> /dev/null`" ]]; then
    if [[ -d $HOME/opt/gradle || -d /opt/gradle ]]; then
        if [[ -d $HOME/opt/gradle ]]; then
            export GRADLE_HOME=$HOME/opt/gradle
        else
            export GRADLE_HOME=/opt/gradle
        fi
        export PATH=$PATH:$GRADLE_HOME/bin
    fi
fi

if [[ `which aws_completer` != "" ]]; then
    complete -C aws_completer aws
fi

if [ -n "`which tmux`" ]; then
    if ! `tmux has 2> /dev/null`; then
        tmux attach
    fi
fi

# up & down map to history search once a command has been started.
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
