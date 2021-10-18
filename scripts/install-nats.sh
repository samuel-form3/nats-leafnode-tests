#!/usr/bin/env bash

# move into root folder
ROOT="$(git rev-parse --show-toplevel)"
pushd $ROOT > /dev/null

CLUSTER_NAME=$1

kubectl apply -f ./$CLUSTER_NAME/nats-cert-secret.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

helm upgrade -i nats \
    ./nats-chart \
    --namespace default \
    --kube-context kind-$CLUSTER_NAME \
    -f ./$CLUSTER_NAME/nats-cluster-values.yaml


popd > /dev/null
