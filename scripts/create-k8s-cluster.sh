#!/usr/bin/env bash

CLUSTER_NAME=$1
CLUSTER_NAME_PREFIX="$2"
INHERIT_CA_FROM_CLUSTER=$3
CILIUM_VERSION="v1.10.4"

CILIUM_CLUSTER_ID="${CLUSTER_NAME/${CLUSTER_NAME_PREFIX}/}"

# move into root folder
ROOT="$(git rev-parse --show-toplevel)"
pushd $ROOT > /dev/null

# create cluster
kind create cluster --name=$CLUSTER_NAME --config=./$CLUSTER_NAME/kind-cluster.yaml

# setup cni
if [ -z "$INHERIT_CA_FROM_CLUSTER" ]
then
    cilium install --cluster-name "${CLUSTER_NAME}" --cluster-id=$CILIUM_CLUSTER_ID --ipam kubernetes --version "${CILIUM_VERSION}"
else
    cilium install --cluster-name "${CLUSTER_NAME}" --cluster-id=$CILIUM_CLUSTER_ID --ipam kubernetes --version "${CILIUM_VERSION}" --inherit-ca "kind-${INHERIT_CA_FROM_CLUSTER}"
fi

cilium clustermesh enable --context "kind-${CLUSTER_NAME}" --service-type NodePort
cilium clustermesh status --context "kind-${CLUSTER_NAME}" --wait

# setup metallb
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/namespace.yaml --context=kind-$CLUSTER_NAME
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" --context=kind-$CLUSTER_NAME
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/metallb.yaml --context=kind-$CLUSTER_NAME
kubectl apply -f ./$CLUSTER_NAME/metallb-config-map.yaml --context=kind-$CLUSTER_NAME

# setup cert manager
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true \
  --set prometheus.enabled=false \
  --wait

kubectl apply -f ./common/ca-issuer.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./common/ca-key-pair.yaml \
   --namespace default \
   --context kind-$CLUSTER_NAME

# setup coredns
kubectl apply -f ./$CLUSTER_NAME/coredns-service.yaml \
   --namespace kube-system \
   --context kind-$CLUSTER_NAME

kubectl apply -f ./$CLUSTER_NAME/coredns-config.yaml \
   --namespace kube-system \
   --context kind-$CLUSTER_NAME

popd > /dev/null
