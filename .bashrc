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
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
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

export PATH=$PATH:$HOME/.local/bin:$HOME/.rvm/bin #:$HOME/.rbenv/bin
# Whenever displaying the prompt, write the previous line to disk.
export PROMPT_COMMAND="history -a"

# DotCloud management commands
alias dc='dotcloud'

function dcuse() {
  # For CLI >= 0.9
  export SETTINGS_FLAVOR=${1}

  # For CLI < 0.9
  export DOTCLOUD_CONFIG_FILE=${1}dotcloud.conf ;
}

# Command to create a spacial DB template for PostGIS 1.5
function mkspatialtemplate() {
  POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib/postgis-1.5
  # Creating the template spatial database.
  createdb -E UTF8 template_postgis
  createlang -d template_postgis plpgsql # Adding PLPGSQL language support.
  # Allows non-superusers the ability to create from this template
  psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';"
  # Loading the PostGIS SQL routines
  psql -d template_postgis -f $POSTGIS_SQL_PATH/postgis.sql
  psql -d template_postgis -f $POSTGIS_SQL_PATH/spatial_ref_sys.sql
  # Enabling users to alter spatial tables.
  psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
  psql -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"
  psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
}

# Load rvm if it exists in the $HOME dir.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Load rvm if it exists in /usr/local.
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"

function parse_git_deleted {
  [[ $(git status 2> /dev/null | grep deleted:) != "" ]] && echo "-"
}
function parse_git_added {
  [[ $(git status 2> /dev/null | grep "Untracked files:") != "" ]] && echo '+'
}
function parse_git_modified {
  [[ $(git status 2> /dev/null | grep modified:) != "" ]] && echo "*"
}
function parse_git_dirty {
  # [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "☠"
  echo "$(parse_git_added)$(parse_git_modified)$(parse_git_deleted)"
}
function parse_git_branch {
  echo "$(parse_git_dirty)$(__git_ps1 '%s')"
}

# Set up the command prompt
#BASE_PROMPT="\[$(tput bold)\]\[$(tput setaf 2)\]\u@\H \[$(tput setaf 4)\]\w\[$(tput setaf 3)\] \$(parse_git_branch)\[$(tput sgr0)\]\n\[$(tput bold)\]\[$(tput setaf 1)\]\$(rvm current) \[$(tput sgr0)\]> "
#PS1="\n$BASE_PROMPT"
#
BASE_PROMPT="\[$(tput bold)\]\[$(tput setaf 2)\]\u@\H \[$(tput setaf 4)\]\w\[$(tput setaf 3)\] \$(parse_git_branch)\[$(tput sgr0)\]\n$ "
PS1="\n$BASE_PROMPT"

# Python virtual environment commands
alias venv='virtualenv env'
function activate() {
  source $1/bin/activate ;
  PS1="\n\[$(tput bold)\]\[$(tput setaf 1)\](py:`basename \"$VIRTUAL_ENV\"`) $BASE_PROMPT"
}

# Command line tools

function rgrep() {
  # Recursively grep, excluding gedit temporary files
  grep -r -n "$1" * --exclude="*~" --exclude-dir=env
}

function clean() {
  # Remove gedit temporary files and python compiled files from a folder
  find . -name \*.pyc -delete
  find . -name \*~ -delete
}

# Git
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gau='git add -u'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git pull; git push'

# Desktop stuff
alias open='nautilus'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
