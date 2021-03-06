#!/usr/bin/env bash

# move into root folder
ROOT="$(git rev-parse --show-toplevel)"
pushd $ROOT > /dev/null

CLUSTER_NAME=$1


# common
kubectl apply -f ./common/ca-user-cert.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./common/fps-user-cert.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./common/nats-client-cert.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME


# server certificates

kubectl apply -f ./$CLUSTER_NAME/nats-with-node-ips/nats-cert-secret.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./$CLUSTER_NAME/nats-with-node-ips/nats-leaf-cert-secret.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

# nats

kubectl apply -f ./$CLUSTER_NAME/nats-with-node-ips/nats-leaf-service.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

helm upgrade -i nats \
    ./nats-chart \
    --namespace default \
    --kube-context kind-$CLUSTER_NAME \
    -f ./$CLUSTER_NAME/nats-with-node-ips/nats-cluster-values.yaml

# nats-box

kubectl apply -f ./common/nats-box-deployment.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

popd > /dev/null
