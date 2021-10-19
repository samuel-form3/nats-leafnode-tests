create-clusters: create-cluster-ca1 create-cluster-ca2 create-cluster-fps1 connect-clustermesh-ca

create-cluster-ca1:
	./scripts/create-k8s-cluster.sh cluster-ca1 cluster-ca

create-cluster-ca2:
	./scripts/create-k8s-cluster.sh cluster-ca2 cluster-ca cluster-ca1

create-cluster-fps1:
	./scripts/create-k8s-cluster.sh cluster-fps1 cluster-fps

connect-clustermesh-ca:
	./scripts/connect-clustermesh.sh cluster-ca1 cluster-ca2

install-nats-with-lb: install-nats-with-lb-ca1 install-nats-with-lb-ca2 install-nats-with-lb-fps1

install-nats-with-lb-ca1:
	./scripts/install-nats-with-lb.sh cluster-ca1

install-nats-with-lb-ca2:
	./scripts/install-nats-with-lb.sh cluster-ca2

install-nats-with-lb-fps1:
	./scripts/install-nats-with-lb.sh cluster-fps1

install-nats-with-node-ips: install-nats-with-nodeips-ca1 install-nats-with-nodeips-ca2 install-nats-with-nodeips-fps1

install-nats-with-nodeips-ca1:
	./scripts/install-nats-with-node-ips.sh cluster-ca1

install-nats-with-nodeips-ca2:
	./scripts/install-nats-with-node-ips.sh cluster-ca2

install-nats-with-nodeips-fps1:
	./scripts/install-nats-with-node-ips.sh cluster-fps1

destroy-test-clusters:
	kind delete cluster --name=cluster-ca1
	kind delete cluster --name=cluster-ca2
	kind delete cluster --name=cluster-fps1

helm-dependencies:
	helm repo add nats https://nats-io.github.io/k8s/helm/charts/
	helm repo add cilium https://helm.cilium.io/
	helm repo add jetstack https://charts.jetstack.io
	helm repo update
