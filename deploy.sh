#! /bin/sh

terraform -chdir="terraform/kubenet" apply --auto-approve

kubectl apply -f k8s/app1-pod.yaml
kubectl apply -f k8s/app1-svc.yaml

terraform -chdir="terraform/cilium" apply --auto-approve
terraform -chdir="terraform/cilium" apply --auto-approve -var="install_cilium=true"

kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/app1-pod-cilium.yaml
kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/app1-svc.yaml

terraform -chdir="terraform/appgtw" apply --auto-approve