#!/usr/bin/env bash

CLUSTER_NAME=$1
DESTINATION_CLUSTER_NAME=$2

cilium clustermesh connect --context "kind-${CLUSTER_NAME}" --destination-context "kind-${DESTINATION_CLUSTER_NAME}"
cilium clustermesh status --context "kind-${CLUSTER_NAME}" --wait
