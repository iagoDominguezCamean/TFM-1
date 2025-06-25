#! /bin/sh

terraform -chdir="terraform/acr" init
terraform -chdir="terraform/kubenet" init
terraform -chdir="terraform/cilium" init
terraform -chdir="terraform/appgtw" init

echo "Creating Azure Container registry."
terraform -chdir="terraform/acr" apply --auto-approve
if [ $? -eq 0 ]; then
    echo "ACR created successfully!"
else
    echo "[ERROR] Creating Azure Container registry. Exiting!"
    exit
fi

echo "Deploying kubenet cluster..."
terraform -chdir="terraform/kubenet" apply --auto-approve
if [ $? -eq 0 ]; then
    echo "Deployment successfull!"
else
    echo "[ERROR] Kubenet cluster deployment failure."
fi

echo "Deploying Cilium cluster..."
terraform -chdir="terraform/cilium_cluster" apply --auto-approve

if [ $? -eq 0 ]; then
    echo "Deployment successfull!"
else
    echo "[ERROR] Cilium cluster deployment failure."
fi

echo "Installing Cilium..."
terraform -chdir="terraform/cilium_cluster_resources" apply --auto-approve

if [ $? -eq 0 ]; then
    echo "Cilium and Nginx installed successfully!"
else
    echo "[ERROR] Failure during Cilium and Nginx installation!"
fi

echo "Installing Ingress Nginx controller in Kubenet cluster..."
az aks approuting enabled --resource-group idomingc --name aks-kubenet
if [ $? -eq 0 ]; then
    echo "Ingress Nginx controller installed successfully!"
else
    echo "[ERROR] Somethig went wrong during nginx installation in Kubenet cluster..."
fi

echo "Installing Ingress Nginx controller in Cilium cluster..."
az aks approuting enabled --resource-group idomingc --name aks-cilium
if [ $? -eq 0 ]; then
    echo "Ingress Nginx controller installed successfully!"
else
    echo "[ERROR] Somethig went wrong during nginx installation in Cilium cluster..."
fi

echo "Deploying Application gateway..."
terraform -chdir="terraform/appgtw" apply --auto-approve

if [ $? -eq 0 ]; then
    echo "¡Deployment complete!"
else
    echo "[ERROR] Failure at Application gateway deployment."
fi