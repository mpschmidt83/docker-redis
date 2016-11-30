#!/usr/bin/env bash



function create() {

  kubectl create namespace redis-standalone
  kubectl --namespace=redis-standalone create -f redis-srv.yaml
  kubectl --namespace=redis-standalone create -f redis-rc.yaml
}



function delete() {

  kubectl --namespace=redis-standalone delete rc redis-node
  kubectl --namespace=redis-standalone delete svc redis-node
  kubectl delete namespace redis-standalone

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
