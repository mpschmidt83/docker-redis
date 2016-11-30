#!/usr/bin/env bash



function create() {

  kubectl create namespace redis-cluster

  kubectl --namespace=redis-cluster create -f redis1-srv.yaml
  kubectl --namespace=redis-cluster create -f redis2-srv.yaml
  kubectl --namespace=redis-cluster create -f redis3-srv.yaml
  kubectl --namespace=redis-cluster create -f redis4-srv.yaml
  kubectl --namespace=redis-cluster create -f redis5-srv.yaml
  kubectl --namespace=redis-cluster create -f redis6-srv.yaml

  kubectl --namespace=redis-cluster create -f redis1-rc.yaml
  kubectl --namespace=redis-cluster create -f redis2-rc.yaml
  kubectl --namespace=redis-cluster create -f redis3-rc.yaml
  kubectl --namespace=redis-cluster create -f redis4-rc.yaml
  kubectl --namespace=redis-cluster create -f redis5-rc.yaml
  kubectl --namespace=redis-cluster create -f redis6-rc.yaml

}



function delete() {

  kubectl --namespace=redis-cluster delete rc redis-node-101
  kubectl --namespace=redis-cluster delete rc redis-node-102
  kubectl --namespace=redis-cluster delete rc redis-node-201
  kubectl --namespace=redis-cluster delete rc redis-node-202
  kubectl --namespace=redis-cluster delete rc redis-node-301
  kubectl --namespace=redis-cluster delete rc redis-node-302

  kubectl --namespace=redis-cluster delete svc redis-001-node-101
  kubectl --namespace=redis-cluster delete svc redis-001-node-102
  kubectl --namespace=redis-cluster delete svc redis-001-node-201
  kubectl --namespace=redis-cluster delete svc redis-001-node-202
  kubectl --namespace=redis-cluster delete svc redis-001-node-301
  kubectl --namespace=redis-cluster delete svc redis-001-node-302

  kubectl delete namespace redis-cluster

}



command=$1

if [[ "${command}" == "create" ]]; then
  create
elif [[ "${command}" == "delete" ]]; then
  delete
else
  echo "Command not supported ${command}"
  echo "Supported command [create, delete]"
fi