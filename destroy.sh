#! /bin/sh

terraform -chdir="terraform/appgtw" destroy --auto-approve
terraform -chdir="terraform/cilium_cluster_resources" destroy --auto-approve
terraform -chdir="terraform/cilium_cluster" destroy --auto-approve
terraform -chdir="terraform/kubenet_resources" destroy --auto-approve
terraform -chdir="terraform/kubenet" destroy --auto-approve
terraform -chdir="terraform/acr" destroy --auto-approve