# Python virtual environment commands
function get_venv_dir() {
  # Use 'env' as the default virtualenv directory name.
  if [[ $1 == "" ]]
    then echo "env"
    else echo "$1"
  fi
}

function activate() {
  if [[ $VIRTUAL_ENV != "" ]]
    then deactivate
  fi

  DIR=$(get_venv_dir "$1")
  source "$DIR/bin/activate" ;
  PS1=$VENV_PS1
}

function venv() {
  DIR=$(get_venv_dir "$1")
  virtualenv $@
  activate "$DIR"
}

alias cdvenv="cd $VIRTUAL_ENV"

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
alias gaw='git diff -w --no-color | git apply --cached --ignore-whitespace'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git pull; git push'

# Desktop stuff
alias open='nautilus'

# Copy stdout to the clipboard, excluding any trailing newlines
alias clip="perl -pe 'chomp if eof' | xclip -sel clip"
