#! /bin/bash
: 'Params:
    1 - Cluster where to deploy the app
'
source .env

cluster=$1

echo "Import images from dockerhub"

EXISTS=$(az acr repository show --name $ACR --image bitnamilegacy/mysql:9.3.0 || echo "Import")
if [ "$EXISTS" = "Import" ]; then
    echo "Importing MySQL image"
    az acr import -n $ACR --source docker.io/bitnamilegacy/mysql:9.3.0 --force --username $DOCKER_HUB_USER --password $DOCKER_HUB_PAT
else
    echo "The MySQL image exists. Skipping."
fi

EXISTS=$(az acr repository show --name $ACR --image bitnamilegacy/wordpress:6.8.1 || echo "Import")
if [ "$EXISTS" = "Import" ]; then
    echo "Importing Wordpress image"
    az acr import -n $ACR --source docker.io/bitnamilegacy/wordpress:6.8.1 --force --username $DOCKER_HUB_USER --password $DOCKER_HUB_PAT
else
    echo "The Wordpress image exists. Skipping."
fi

EXISTS=$(az acr repository show --name $ACR --image networkstatic/iperf3:latest || echo "Import")
if [ "$EXISTS" = "Import" ]; then
    echo "Importing iperf3 image"
    az acr import -n $ACR --source docker.io/networkstatic/iperf3:latest --force --username $DOCKER_HUB_USER --password $DOCKER_HUB_PAT
else
    echo "The iperf3 image exists. Skipping."
fi

EXISTS=$(az acr repository show --name $ACR --image fortio/fortio:1.73.2 || echo "Import")
if [ "$EXISTS" = "Import" ]; then
    echo "Importing fortio image"
    az acr import -n $ACR --source docker.io/fortio/fortio:1.73.2 --force --username $DOCKER_HUB_USER --password $DOCKER_HUB_PAT
else
    echo "The fortio image exists. Skipping."
fi

EXISTS=$(az acr repository show --name $ACR --image library/nginx:stable || echo "Import")
if [ "$EXISTS" = "Import" ]; then
    echo "Importing nginx image"
    az acr import -n $ACR --source docker.io/library/nginx:stable --force --username $DOCKER_HUB_USER --password $DOCKER_HUB_PAT
else
    echo "The nginx image exists. Skipping."
fi

if [ $cluster == "kubenet" ]; then
    echo "Deploying apps into Kubenet cluster..."
    kubectl --kubeconfig="/home/iagodc/.kube/config_kubenet" apply -f k8s/ingress.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_kubenet" apply -f k8s/app01/kubenet-deployment.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_kubenet" apply -f k8s/wordpress/deployment-wordpress.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_kubenet" apply -f k8s/benchmark/fortio.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_kubenet" apply -f k8s/benchmark/iperf3.yaml
elif [ $cluster == "cilium" ]; then
    echo "Deploying app insto Cilium cluster..."
    kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/ingress.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/app01c/cilium-deployment.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/wordpress/deployment-wordpress.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/benchmark/fortio.yaml
    kubectl --kubeconfig="/home/iagodc/.kube/config_cilium" apply -f k8s/benchmark/iperf3.yaml
fi
