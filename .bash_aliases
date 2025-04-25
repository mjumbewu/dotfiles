VENV_ROOT=$HOME/.virtualenvs

# Python virtual environment commands
function get_venv_dir() {
  # Use 'env' as the default virtualenv directory name.
  if [[ $1 == "" ]]
    then echo "${VENV_ROOT}$(pwd)"
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
  # Usage:
  # venv [env_name] [-p python_executable] [venv_args]
  #
  # env_name: The name of the folder to create the virtual environment in (optional).
  # -p python_executable: The python executable to use (optional, default "python3").
  # venv_args: Additional options to pass to the python3 -m venv command.

  # If the first argument does not start with a dash, use it as the directory name.
  if [[ $1 != -* ]]
    then
      DIR=$(get_venv_dir "$1")
      shift
    else
      DIR=$(get_venv_dir)
  fi

  PYTHON_EXECUTABLE="python3"
  VENV_ARGS=()

  while [[ $# -gt 0 ]]; do
    case $1 in
      -p|--python)
        PYTHON_EXECUTABLE="$2"
        shift # past argument
        shift # past value
        ;;
      *)
        VENV_ARGS+=("$1") # save positional arg
        shift # past argument
        ;;
    esac
  done

  mkdir -p $DIR
  "${PYTHON_EXECUTABLE}" -m venv $DIR $VENV_ARGS
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
alias open='xdg-open'

# Copy stdout to the clipboard, excluding any trailing newlines
alias clip="perl -pe 'chomp if eof' | xclip -sel clip"
