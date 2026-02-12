#! /bin/bash
echo "Velero Installation"

source .env

helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts

echo "Import images from dockerhub"

EXISTS=$(az acr repository show --name $ACR --image velero/velero:v1.14.0 || echo "Import")
if [ "$EXISTS" = "Import" ]; then
    echo "Importing velero:v1.14.0 image"
    az acr import -n $ACR --source docker.io/velero/velero:v1.14.0 --force --username $DOCKER_HUB_USER --password $DOCKER_HUB_PAT
else
    echo "The velero image exists. Skipping."
fi

EXISTS=$(az acr repository show --name $ACR --image velero/velero-plugin-for-microsoft-azure:v1.10.0 || echo "Import")
if [ "$EXISTS" = "Import" ]; then
    echo "Importing velero-plugin-for-microsoft-azure:v1.10.0 image"
    az acr import -n $ACR --source docker.io/velero/velero-plugin-for-microsoft-azure:v1.10.0 --force --username $DOCKER_HUB_USER --password $DOCKER_HUB_PAT
else
    echo "The velero-plugin-for-microsoft-azure image exists. Skipping."
fi

EXISTS=$(az acr repository show --name $ACR --image bitnami/kubectl:1.31.4 || echo "Import")
if [ "$EXISTS" = "Import" ]; then
    echo "Importing kubectl:1.31.4 image"
    az acr import -n $ACR --source public.ecr.aws/bitnami/kubectl:1.31.4 --force #--username $DOCKER_HUB_USER --password $DOCKER_HUB_PAT
else
    echo "The kubectl image exists. Skipping."
fi

EXISTS=$(az acr repository show --name $ACR --image velero/velero-restore-helper:v1.14.0 || echo "Import")
if [ "$EXISTS" = "Import" ]; then
    echo "Importing velero-restore-helper:v1.14.0 image"
    az acr import -n $ACR --source docker.io/velero/velero-restore-helper:v1.14.0 --force --username $DOCKER_HUB_USER --password $DOCKER_HUB_PAT
else
    echo "The velero-restore-helper image exists. Skipping."
fi

envsubst < k8s/velero/credentials-velero > credentials-velero

envsubst < k8s/velero/velero-values.yaml > values.yaml

echo "------- Installing velero in AKS -------"
az aks get-credentials --name aks-cilium -g idomingc --admin --overwrite-existing
helm upgrade --install velero vmware-tanzu/velero --namespace velero --create-namespace -f ./values.yaml --set-file credentials.secretContents.cloud=./credentials-velero
echo "------- Velero installed in AKS -------"