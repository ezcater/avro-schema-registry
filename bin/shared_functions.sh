#!/usr/bin/env bash

yellow(){ printf "\033[33m${1}\033[0m\n"; }

error(){ printf "\033[91m${1}\033[0m\n"; }

check_for_kubectl(){
  if ! command -v kubectl &> /dev/null; then
    error "You need to install kubectl and ensure it's on \$PATH"
    exit 1;
  fi
}

get_web_pod(){
  web_pod=$(kubectl get pods | grep 'schema-registry-web' | cut -f 1 -d' ')
}

execute_command_against_web_pod(){
  check_for_kubectl
  get_web_pod
  if [ -z "$web_pod" ]; then
    echo
    error "I'm not seeing a running web pod, bub. You probably need to run 'tilt up' before running this."
    echo
    exit 1;
  fi

  # We've got a web pod
  if [ ! -z "$1" ]; then
    # And we want to emit a preflight message
    echo
    yellow "$1"
    echo
    tilt_time_now
  fi
  # The arg splat shouldn't be quoted or it looks like we want a specific command
  kubectl exec -it "$web_pod" -- ${@:2}
}

tilt_time_now(){
  echo '
               _~}                                 _      _
             _(<\_-~=.                          /\//_    _\\/\
         _=/`  `+--/\|                          `7/\/    \/\\|
_______~~  \ )-`\ 7 _____________________x___X___Z_\______/_T______
          `/ \  / >
           `   `
'
}

