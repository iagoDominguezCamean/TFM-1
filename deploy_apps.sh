#! /bin/bash
: 'Params:
    1 - Cluster where to deploy the app
'
cluster=$1

if [[ $cluster == "kubenet" ]]; then
    echo "Deploying apps into Kubenet cluster..."
    kubectl apply -f k8s/app1-pod.yaml
    kubectl apply -f k8s/app1-svc.yaml
elif [[ $cluster == "cilium" ]]; then
    echo "Deploying app insto Cilium cluster..."
    kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/app1-pod-cilium.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/app1-svc.yaml
fi