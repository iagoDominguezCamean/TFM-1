#! /bin/bash
: 'Params:
    1 - Cluster where to deploy the app
'
cluster=$1

if [ $cluster == "kubenet" ]; then
    echo "Deploying apps into Kubenet cluster..."
    kubectl --kubeconfig="/home/iagodc/.kube/config_kubenet" apply -f k8s/app01/cilium-deployment.yaml
elif [ $cluster == "cilium" ]; then
    echo "Deploying app insto Cilium cluster..."
    kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/app02/cilium-deployment.yaml
fi
