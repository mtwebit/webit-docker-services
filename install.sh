#!/bin/bash

echo "Installing Webit Docker Services..."

if [ ! -f "config.txt" ]; then
  #cp mw.env.default mw.env
  echo "Review and edit the settings in mw.env then rerun this script."
  exit
fi

if [ ! -d "data" ]; then
  echo "Creating a data/ directory for persistent data storage."
  mkdir data/
fi

# Ask a question and provide a default answer
# Sets the variable to the answer or the default value
# 1:varname 2:question 3:default value
function ask() {
  echo -n ">> ${2}: [$3] "
  read pp
  if [ -z "$pp" ]; then
    export ${1}="${3}"
  else
    export ${1}="${pp}"
  fi
}

# Ask a yes/no question, returns true on answering y
# 1:question 2:default answer
function askif() {
  ask ypp "$1" "$2"
  [ "$ypp" == "y" ]
}

function fatal {
  echo -e "[\e[91mERROR\e[0m] $*"
  sleep 2
  exit 2
}

function warning {
  echo -e "[\e[33mWARNING\e[0m] $*"
  sleep 2
}

# Set up a component
#$1: Deploy/Uninstall|Remove
#$2: Component dir (without the .service ending)
function setup {
  SDIR=${2}.service
  SNAME=`head -1 ${SDIR}/info.txt`
  if askif "$1 ${SNAME}" y; then
    [ "$1" == "Deploy" ] && cmd="up -d" || cmd="down"
    cd ${SDIR}
    [ "$1" == "Deploy" -a -f "init.sh" ] && . init.sh
    docker-compose $cmd
    [ "$1" == "Deploy" -a -f "post.sh" ] && . post.sh
    cd ..
  fi
}

sname=`basename $0`

[ -x /usr/bin/which ] || fatal "This program requires 'which' to be installed."

which docker-compose 2>/dev/null >/dev/null || fatal "Docker Compose not found."
which docker 2>/dev/null >/dev/null || fatal "Docker not found."
docker ps 2>/dev/null >/dev/null || fatal "Docker is not running."

source config.txt

if [ "$sname" == "install.sh" ]; then
  setup Deploy traefik
  setup Deploy keycloak
else
  cmd="down"
  setup Uninstall keycloak
  setup Uninstall traefik
  docker volume prune
  docker image prune -a
fi

