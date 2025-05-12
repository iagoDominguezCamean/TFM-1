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
terraform -chdir="terraform/cilium" apply --auto-approve

if [ $? -eq 0 ]; then
    echo "Deployment successfull!"
else
    echo "[ERROR] Cilium cluster deployment failure."
fi

echo "Installing Cilium..."
terraform -chdir="terraform/cilium" apply --auto-approve -var="install_cilium=true"

if [ $? -eq 0 ]; then
    echo "Cilium installed successfully!"
else
    echo "[ERROR] Failure during Cilium installation!"
fi

echo "Deploying Application gateway..."
terraform -chdir="terraform/appgtw" apply --auto-approve

if [ $? -eq 0 ]; then
    echo "¡Deployment complete!"
else
    echo "[ERROR] Failure at Application gateway deployment."
fi