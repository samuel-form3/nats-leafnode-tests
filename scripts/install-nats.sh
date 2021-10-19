#!/usr/bin/env bash

# move into root folder
ROOT="$(git rev-parse --show-toplevel)"
pushd $ROOT > /dev/null

CLUSTER_NAME=$1



kubectl apply -f ./$CLUSTER_NAME/nats-cert-secret.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./common/test1-user-cert.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./common/test2-user-cert.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./common/nats-client-cert.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./$CLUSTER_NAME/nats-leaf-cert-secret.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./$CLUSTER_NAME/nats-leaf-service.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

helm upgrade -i nats \
    ./nats-chart \
    --namespace default \
    --kube-context kind-$CLUSTER_NAME \
    -f ./$CLUSTER_NAME/nats-cluster-values.yaml

kubectl apply -f ./common/nats-box-deployment.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

popd > /dev/null
