#! /bin/sh

terraform -chdir="terraform/appgtw" destroy --auto-approve
terraform -chdir="terraform/cilium" destroy --auto-approve
terraform -chdir="terraform/kubenet" destroy --auto-approve
terraform -chdir="terraform/acr" destroy --auto-approve