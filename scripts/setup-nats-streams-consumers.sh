#!/usr/bin/env bash




```
# CLUSTER A1: Setup pull consumer
nats con add t1t2test t1t2testpullconsumer --filter '' --ack explicit --pull --deliver all --max-deliver=-1 --sample 100 --tlskey=tls.key --tlscert=tls.crt --tlsca=ca.crt

# CLUSTER A2: Setup push consumer that pipes messages to an out subject
nats con add t1t2test t1t2testconsumer --filter '' --ack none --target t1t2result --deliver last --replay instant --tlskey=tls.key --tlscert=tls.crt --tlsca=ca.crt

# CLUSTER B1: Setup push consumer that pipes messages to an out subject
nats con add t2test t2testconsumer --filter '' --ack none --target t2result --deliver last --replay instant --tlskey=tls.key --tlscert=tls.crt --tlsca=ca.crt
```

Message pub/sub and consumer commands:

```
# Subscribe to subject messages
nats sub t1t2result --tlskey=tls.key --tlscert=tls.crt --tlsca=ca.crt

# Publish message to subject.
nats pub TEST2.test --tlskey=tls.key --tlscert=tls.crt --tlsca=ca.crt miracle

# Pull message from consumer
nats consumer next t1t2test t1t2testpullconsumer --tlskey=tls.key --tlscert=tls.crt --tlsca=ca.crt
```

# cluster a1

kubectl exec --kube-context=kind-cluster-a1 -it nats-box -- znats stream create --tlskey=tls.key --tlscert=tls.crt --tlsca=ca.crt 

kubectl exec --kube-context=kind-cluster-a1 -it nats-box -- nats con add t1t2test t1t2testpullconsumer --filter '' --ack explicit --pull --deliver all --max-deliver=-1 --sample 100 --tlskey=/etc/nats-certs/test1/tls.key --tlscert=tls.crt --tlsca=ca.crt 
