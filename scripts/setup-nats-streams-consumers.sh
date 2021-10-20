#!/usr/bin/env bash

# Cluster CA

# Create Stream
kubectl exec --context=kind-cluster-ca1 -it deploy/nats-box -- nats stream create CAFPSPAYMENTS \
    --tlskey=/etc/nats-certs/ca/tls.key \
    --tlscert=/etc/nats-certs/ca/tls.crt \
    --tlsca=/etc/nats-certs/ca/ca.crt \
    --subjects=CA.FPS.payments \
    --storage=file \
    --retention=limits \
    --discard=old \
    --max-msgs=-1 \
    --max-msgs-per-subject=-1 \
    --max-msg-size=-1 \
    --max-bytes=-1 \
    --dupe-window=2m \
    --max-age=-1 \
    --replicas=1

# Create Pull Consumer
kubectl exec --context=kind-cluster-ca1 -it deploy/nats-box -- nats con add CAFPSPAYMENTS CAFPSPAYMENTSPULLCONSUMER \
    --tlskey=/etc/nats-certs/ca/tls.key \
    --tlscert=/etc/nats-certs/ca/tls.crt \
    --tlsca=/etc/nats-certs/ca/ca.crt \
    --filter '' \
    --ack explicit \
    --pull \
    --deliver all \
    --max-deliver=-1 \
    --sample 100

# Create Push Consumer
kubectl exec --context=kind-cluster-ca1 -it deploy/nats-box -- nats con add CAFPSPAYMENTS CAFPSPAYMENTSPUSHCONSUMER \
    --tlskey=/etc/nats-certs/ca/tls.key \
    --tlscert=/etc/nats-certs/ca/tls.crt \
    --tlsca=/etc/nats-certs/ca/ca.crt \
    --filter '' \
    --ack none \
    --target CA.FPS.paymentsstreamresult \
    --deliver last \
    --replay instant

# Cluster FPS

# Create Stream
kubectl exec --context=kind-cluster-fps1 -it deploy/nats-box -- nats stream create FPSPAYMENTS \
    --tlskey=/etc/nats-certs/fps/tls.key \
    --tlscert=/etc/nats-certs/fps/tls.crt \
    --tlsca=/etc/nats-certs/fps/ca.crt \
    --subjects=FPS.payments \
    --storage=file \
    --retention=limits \
    --discard=old \
    --max-msgs=-1 \
    --max-msgs-per-subject=-1 \
    --max-msg-size=-1 \
    --max-bytes=-1 \
    --dupe-window=2m \
    --max-age=-1 \
    --replicas=1

# Create Push Consumer
kubectl exec --context=kind-cluster-fps1 -it deploy/nats-box -- nats con add FPSPAYMENTS FPSPAYMENTSPUSHCONSUMER \
    --tlskey=/etc/nats-certs/fps/tls.key \
    --tlscert=/etc/nats-certs/fps/tls.crt \
    --tlsca=/etc/nats-certs/fps/ca.crt \
    --filter '' \
    --ack none \
    --target FPS.paymentsstreamresult \
    --deliver last \
    --replay instant
