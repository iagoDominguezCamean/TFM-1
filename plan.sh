terraform -chdir="terraform/acr" plan
terraform -chdir="terraform/kubenet" plan
terraform -chdir="terraform/cilium" plan
terraform -chdir="terraform/cilium" plan -var="install_cilium=true"
terraform -chdir="terraform/appgtw" plan