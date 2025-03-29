#! /bin/sh

terraform -chdir=terraform apply --auto-approve

kubectl apply -f k8s/app1-pod.yaml
kubectl apply -f k8s/app1-svc.yaml

terraform -chdir= terraform apply --auto-aprove -var="create_cilium_cluster=true"