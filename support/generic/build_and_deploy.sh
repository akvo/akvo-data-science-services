#!/usr/bin/env bash
set -eu

function log {
   echo "$(date +"%T") - INFO - $*"
}

export PROJECT_NAME=akvo-lumen

if [ -z "$TRAVIS_COMMIT" ]; then
    export TRAVIS_COMMIT=local
fi

log Creating Production image

project_folder=$(echo $1 | cut -f 2 -d "/")

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd $1

docker build --rm=false -t eu.gcr.io/${PROJECT_NAME}/akvo-data-science-${project_folder}:${TRAVIS_COMMIT} .



if [[ "${TRAVIS_BRANCH}" != "master" && "${TRAVIS_BRANCH}" != "develop" ]]; then
    exit 0
fi

if [[ "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
    exit 0
fi

log Making sure gcloud and kubectl are installed and up to date
gcloud components install kubectl
gcloud components update
gcloud version
which gcloud kubectl

log Authentication with gcloud and kubectl
gcloud auth activate-service-account --key-file "${GCLOUD_ACCOUNT_FILE}"
gcloud config set project akvo-lumen
gcloud config set container/cluster europe-west1-d
gcloud config set compute/zone europe-west1-d
gcloud config set container/use_client_certificate True


K8S_CONFIG_FILE=../../support/generic/k8s/config-test.yaml

if [[ "${TRAVIS_BRANCH}" == "master" ]]; then
    log Environment is production
    K8S_CONFIG_FILE=../../support/generic/k8s/config-prod.yaml
    gcloud container clusters get-credentials production
else
    log Environement is test
    gcloud container clusters get-credentials test
fi

log Pushing images
gcloud auth configure-docker
docker push "eu.gcr.io/${PROJECT_NAME}/akvo-data-science-${project_folder}:$TRAVIS_COMMIT"

sed -e "s/\${TRAVIS_COMMIT}/$TRAVIS_COMMIT/" -e "s/\${project_folder}/$project_folder/" ${DIR}/generic-deployment.yaml > deployment.yaml.donotcommit

log "Deploying config $K8S_CONFIG_FILE"
kubectl apply -f ${K8S_CONFIG_FILE}

kubectl apply -f deployment.yaml.donotcommit

$DIR/wait-for-k8s-deployment-to-be-ready.sh ${project_folder}

popd

log Done
