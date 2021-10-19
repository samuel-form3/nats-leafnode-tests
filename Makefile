create-clusters: create-cluster-a1 create-cluster-a2 create-cluster-b1 connect-clustermesh-a

create-cluster-a1:
	./scripts/create-k8s-cluster.sh cluster-a1 cluster-a

create-cluster-a2:
	./scripts/create-k8s-cluster.sh cluster-a2 cluster-a cluster-a1

create-cluster-b1:
	./scripts/create-k8s-cluster.sh cluster-b1 cluster-b

connect-clustermesh-a:
	./scripts/connect-clustermesh.sh cluster-a1 cluster-a2

install-nats-with-lb: install-nats-with-lb-a1 install-nats-with-lb-a2 install-nats-with-lb-b1

install-nats-with-lb-a1:
	./scripts/install-nats-with-lb.sh cluster-a1

install-nats-with-lb-a2:
	./scripts/install-nats-with-lb.sh cluster-a2

install-nats-with-lb-b1:
	./scripts/install-nats-with-lb.sh cluster-b1

install-nats-with-node-ips: install-nats-with-nodeips-a1 install-nats-with-nodeips-a2 install-nats-with-nodeips-b1

install-nats-with-nodeips-a1:
	./scripts/install-nats-with-node-ips.sh cluster-a1

install-nats-with-nodeips-a2:
	./scripts/install-nats-with-node-ips.sh cluster-a2

install-nats-with-nodeips-b1:
	./scripts/install-nats-with-node-ips.sh cluster-b1

destroy-test-clusters:
	kind delete cluster --name=cluster-a1
	kind delete cluster --name=cluster-a2
	kind delete cluster --name=cluster-b1

helm-dependencies:
	helm repo add nats https://nats-io.github.io/k8s/helm/charts/
	helm repo add cilium https://helm.cilium.io/
	helm repo add jetstack https://charts.jetstack.io
	helm repo update
