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

  kubectl --namespace=redis-cluster create -f cluster-metrics-rc.yaml

}



function delete() {

  kubectl --namespace=redis-cluster delete deployment cluster-metrics

  kubectl --namespace=redis-cluster delete deployment redis-101
  kubectl --namespace=redis-cluster delete deployment redis-102
  kubectl --namespace=redis-cluster delete deployment redis-201
  kubectl --namespace=redis-cluster delete deployment redis-202
  kubectl --namespace=redis-cluster delete deployment redis-301
  kubectl --namespace=redis-cluster delete deployment redis-302

  kubectl --namespace=redis-cluster delete svc redis-101
  kubectl --namespace=redis-cluster delete svc redis-102
  kubectl --namespace=redis-cluster delete svc redis-201
  kubectl --namespace=redis-cluster delete svc redis-202
  kubectl --namespace=redis-cluster delete svc redis-301
  kubectl --namespace=redis-cluster delete svc redis-302

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