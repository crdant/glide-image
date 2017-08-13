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
  echo "USAGE: ${me} path/to/credentials.yml"
  exit 1
}


if [ -z "${stub}" ]; then
  stub="../credentials.yml"
fi
stub=$(realpath $stub)
if [ ! -f ${stub} ]; then
  usage
fi


pushd $DIR
  fly -t ${fly_target} login
  fly -t ${fly_target} set-pipeline -p serverless-resource --config ci/pipeline.yml --load-vars-from ci/properties.yml --load-vars-from ${stub} -n
  fly -t ${fly_target} unpause-pipeline --pipeline serverless-resource
popd
