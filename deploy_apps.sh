#! /bin/bash
: 'Params:
    1 - Cluster where to deploy the app
'
cluster=$1

echo "Import images from dockerhub"

EXISTS=$(az acr repository show --name acridomingc --image bitnami/mysql:9.3.0 || echo "Import")
if [ "$EXISTS" = "Import" ]; then
    echo "Importing MySQL image"
    az acr import -n acridomingc --source docker.io/bitnami/mysql:9.3.0 --force --username iagodc29 --password dckr_pat_mFOCHudTv8-75FGN4QoV3Nwmt-g
else
    echo "The MySQL image exists. Skipping."
fi

EXISTS=$(az acr repository show --name acridomingc --image bitnami/wordpress:6.8.1 || echo "Import")
if [ "$EXISTS" = "Import" ]; then
    echo "Importing Wordpress image"
    az acr import -n acridomingc --source docker.io/bitnami/wordpress:6.8.1 --force --username iagodc29 --password dckr_pat_mFOCHudTv8-75FGN4QoV3Nwmt-g
else
    echo "The Wordpress image exists. Skipping."
fi

if [ $cluster == "kubenet" ]; then
    echo "Deploying apps into Kubenet cluster..."
    kubectl --kubeconfig="/home/iagodc/.kube/config_kubenet" apply -f k8s/ingress.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_kubenet" apply -f k8s/app01/kubenet-deployment.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_kubenet" apply -f k8s/wordpress/wordpress-deployment.yaml
elif [ $cluster == "cilium" ]; then
    echo "Deploying app insto Cilium cluster..."
    kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/ingress.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/app01c/cilium-deployment.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/wordpress/wordpress-deployment.yaml
fi
