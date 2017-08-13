#!/bin/bash

stub=$1; shift
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
export ATC_URL=${ATC_URL:-"http://192.168.100.4:8080"}
export fly_target=${fly_target:-lite}
echo "Concourse API target ${fly_target}"
echo "Concourse API $ATC_URL"

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

usage() {
  me=$(basename ${0})
  echo "USAGE: ${me}"
  exit 1
}

pushd $DIR
  fly -t ${fly_target} login
  fly -t ${fly_target} trigger-job -j serverless-resource/publish
  fly -t ${fly_target} watch -j serverless-resource/publish
popd
