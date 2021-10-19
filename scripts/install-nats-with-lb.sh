#!/usr/bin/env bash

# move into root folder
ROOT="$(git rev-parse --show-toplevel)"
pushd $ROOT > /dev/null

CLUSTER_NAME=$1


# common
kubectl apply -f ./common/test1-user-cert.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./common/test2-user-cert.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./common/nats-client-cert.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME


# server certificates

kubectl apply -f ./$CLUSTER_NAME/nats-with-lb/nats-cert-secret.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./$CLUSTER_NAME/nats-with-lb/nats-leaf-cert-secret.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

# nats

kubectl apply -f ./$CLUSTER_NAME/nats-with-lb/nats-leaf-service.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

helm upgrade -i nats \
    ./nats-chart \
    --namespace default \
    --kube-context kind-$CLUSTER_NAME \
    -f ./$CLUSTER_NAME/nats-with-lb/nats-cluster-values.yaml

# nats-box

kubectl apply -f ./common/nats-box-deployment.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

popd > /dev/null
