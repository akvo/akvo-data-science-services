#!/usr/bin/env bash

starttime=$(date +%s)
project_folder=$1

while [ $(( $(date +%s) - 300 )) -lt "${starttime}" ]; do

   new_pod_status=$(kubectl get pods -l "code-version=$TRAVIS_COMMIT,run=akvo-data-science-${project_folder}" -o jsonpath='{range .items[*].status.containerStatuses[*]}{@.name}{" ready="}{@.ready}{"\n"}{end}')
   old_pod_status=$(kubectl get pods -l "code-version!=$TRAVIS_COMMIT,run=akvo-data-science-${project_folder}" -o jsonpath='{range .items[*].status.containerStatuses[*]}{@.name}{" ready="}{@.ready}{"\n"}{end}')

    if [[ ${new_pod_status} =~ "ready=true" ]] && ! [[ ${new_pod_status} =~ "ready=false" ]] && ! [[ ${old_pod_status} =~ "ready" ]] ; then
        echo "all good!"
        exit 0
    else
        echo "Waiting for the containers to be ready"
        sleep 10
    fi
done

echo "Containers not ready after 5 minutes or old containers not stopped"

kubectl get pods -l "run=akvo-data-science-${project_folder}" -o jsonpath='{range .items[*].status.containerStatuses[*]}{@.name}{" ready="}{@.ready}{"\n"}{end}'

exit 1
