#!/bin/bash
set -e
#docker build -t kdvolder/lab-spring-boot-k8s-getting-started .
#docker push kdvolder/lab-spring-boot-k8s-getting-started
kubectl delete --namespace=lab-spring-boot-k8s-gs-w01 pods --all
kubectl delete -f resources/workshop.yaml
kubectl delete -f resources/training-portal.yaml
kubectl apply -f resources/workshop.yaml
kubectl apply -f resources/training-portal.yaml
watch kubectl get eduk8s
