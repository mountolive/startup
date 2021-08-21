#! /bin/bash

require() {
    command -v "$1" >/dev/null 2>&1 || { echo >&2 "$1 program is required"; exit 1; }
}

check_response() {
    read -p "$1" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]
    then
      echo "please do"
      exit 1
    fi
}

setup_bashrc() {
   echo "if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi\n" > ~/.bashrc && echo "added support for aliases in bashrc"
   echo "if [ -f ~/.bash_envs ]; then . ~/.bash_envs; fi\n" > ~/.bashrc && echo "added support for envs in bashrc"
   echo "function rename-terminal() {
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}\n" > ~/.bashrc && echo "rename terminal func added"
}

add_alias() {
    echo "alias $1=$2\n" > ~/.bash_aliases && echo "alias added"
}

add_env_var() {
    echo "$1\n" > ~/.bash_envs && echo "env added"
}

