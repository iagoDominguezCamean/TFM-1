#! /bin/sh

terraform -chdir=terraform apply --auto-approve

kubectl apply -f k8s/app1-pod.yaml
kubectl apply -f k8s/app1-svc.yaml

terraform -chdir=terraform apply --auto-approve -var="create_cilium_cluster=true"

kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/app1-pod-cilium.yaml
kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/app1-svc.yaml

sleep 30

terraform -chdir=terraform apply --auto-approve -var="create_cilium_cluster=true" -var="create_appgtw=true"