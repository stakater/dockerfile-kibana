#!/bin/bash
_kibana_version=$1
_kibana_tag=$2
_release_build=false

if [ -z "${_kibana_version}" ]; then
	source KIBANA_VERSION
	_kibana_version=$KIBANA_VERSION
	_kibana_tag=$KIBANA_VERSION
	_release_build=true
fi

echo "KIBANA_VERSION: ${_kibana_version}"
echo "DOCKER TAG: ${_kibana_tag}"
echo "RELEASE BUILD: ${_release_build}"

docker build --build-arg KIBANA_VERSION=${_kibana_version} --tag "stakater/kibana:${_kibana_tag}"  --no-cache=true .

if [ $_release_build == true ]; then
	docker build --build-arg KIBANA_VERSION=${_kibana_version} --tag "stakater/kibana:latest"  --no-cache=true .
fi