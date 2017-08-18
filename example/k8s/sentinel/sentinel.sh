#!/usr/bin/env bash



function create() {

  kubectl create namespace redis-sentinel


  kubectl --namespace=redis-sentinel create -f redis-node1-srv.yaml
  kubectl --namespace=redis-sentinel create -f redis-node2-srv.yaml
  kubectl --namespace=redis-sentinel create -f redis-node3-srv.yaml
  kubectl --namespace=redis-sentinel create -f redis-sentinel-srv.yaml

  kubectl --namespace=redis-sentinel create -f redis-node1-rc.yaml
  kubectl --namespace=redis-sentinel create -f redis-node2-rc.yaml
  kubectl --namespace=redis-sentinel create -f redis-node3-rc.yaml

  kubectl --namespace=redis-sentinel create -f redis-sentinel1-rc.yaml
  kubectl --namespace=redis-sentinel create -f redis-sentinel2-rc.yaml
  kubectl --namespace=redis-sentinel create -f redis-sentinel3-rc.yaml

  kubectl --namespace=redis-sentinel create -f sentinel-metrics-rc.yaml

}



function delete() {

  kubectl --namespace=redis-sentinel delete rc sentinel-metrics

  kubectl --namespace=redis-sentinel delete rc redis-sentinel-1
  kubectl --namespace=redis-sentinel delete rc redis-sentinel-2
  kubectl --namespace=redis-sentinel delete rc redis-sentinel-3

  kubectl --namespace=redis-sentinel delete rc redis-node-1
  kubectl --namespace=redis-sentinel delete rc redis-node-2
  kubectl --namespace=redis-sentinel delete rc redis-node-3


  kubectl --namespace=redis-sentinel delete svc redis-node-1
  kubectl --namespace=redis-sentinel delete svc redis-node-2
  kubectl --namespace=redis-sentinel delete svc redis-node-3
  kubectl --namespace=redis-sentinel delete svc redis-sentinel

  kubectl delete namespace redis-sentinel

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
