#!/usr/bin/env bash
# Credit : Julien maury

# The script sets up Git configuration globally
# and backs up the existing Git configuration files

trap 'err=$?; echo >&2 -e "\e[1;31mThe script catched this unusual error\033[0m"; exit $err' ERR

function header() {
  echo '       _ _                   __ _             _'
  echo '  __ _(_) |_ ___ ___  _ __  / _(_) __ _   ___| |__'
  echo ' / _` | | __/ __/ _ \| `_ \| |_| |/ _` | / __| `_  \'
  echo '| (_| | | || (_| (_) | | | |  _| | (_| |_\__ \ | | |'
  echo ' \__, |_|\__\___\___/|_| |_|_| |_|\__, (_)___/_| |_|'
  echo ' |___/                            |___/'
}

function usage() {
    cat 1>&2 <<EOF
$(header)

USAGE:
    ./$(basename $0) [ -b "BRANCH_NAME" ] [ -e "EMAIL" ] [ -u "USER_NAME" ]
OPTIONS:
      -h  Usage
      -b  The default branch name (default is "main")
      -e  required: The email that will be associated with commits
      -u  required: The name that will be associated with commits (e.g, "Martin Scorcese")
EOF
}

function err() {
  echo -e "\e[1;31m$1\033[0m" >&2
}

maybe_install_git() {
  if ! [ -x "$(command -v git)" ]; then
    err "I need Git. Please install it on your system. For example 'sudo apt install -y git' on Debian"
    exit 1
  fi
}

function configure_git() {
  git config --global core.excludesFile "$HOME/.gitignore_global"
  git config --global init.defaultBranch "$1"
  git config --global user.email "$2"
  git config --global user.name "$3"
  git config --global pull.rebase true
  git config --global fetch.prune true
  git config --global alias.co checkout
  git config --global alias.cp cherry-pick
  git config --global alias.ci commit
  git config --global alias.st status
  git config --global alias.lg "log --color --graph --pretty=format:'%C(red)%h%Creset -%C(yellow)%d%Creset %s %C(green)(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
  git config --global alias.optimize "repack -a -d --depth=250"
  git config --global alias.grep '!git ls-files | grep -i'
}

BACKUP_FOLDER="$HOME/gitconfig-backups"

while getopts "hb:e:u:" opt; do
  case "$opt" in 
    b) 
      GIT_DEFAULT_BRANCH=${OPTARG}
      ;;
    e) 
      GIT_USER_EMAIL=${OPTARG}
      ;;
    u) 
      GIT_USER_NAME=${OPTARG}
      ;;
    h) 
      usage;
      exit 0
      ;;
    : )
      err "No parameter provided"
      usage;
      exit 1
    ;;
  esac
done

shift $((OPTIND-1)) # clear options

mkdir -p "$BACKUP_FOLDER"
cd "$PWD/files"
for entry in $(find . -type f -name '\.*' -print)
do
  if [ -f "$HOME/$entry" ]; then
    cp -n "$HOME/$entry" "$BACKUP_FOLDER"
  fi

  cp -n $entry $HOME
done

if [ -z "${GIT_USER_EMAIL-}" ] || [ -z "${GIT_USER_NAME-}" ]; then
  err "The script failed to set variables for user email and name"
  usage
  exit 1
fi

maybe_install_git

if [ -f "$HOME/.gitconfig" ]; then
  cp -n "$HOME/.gitconfig" "$BACKUP_FOLDER"
fi

configure_git "${GIT_DEFAULT_BRANCH-main}" "$GIT_USER_EMAIL" "$GIT_USER_NAME"

clear
cd -
echo -e "\033[32mdone:\033[0m"
git config --global --list
