#!/bin/bash
set -e
docker build -t kdvolder/lab-spring-boot-k8s-gs-test .
docker push kdvolder/lab-spring-boot-k8s-gs-test
kubectl apply -f resources/workshop.yaml
kubectl apply -f resources/training-portal.yaml
kubectl delete --namespace=lab-spring-boot-k8s-gs-w01 pods --all
watch kubectl get eduk8s
