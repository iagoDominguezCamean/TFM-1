# TFM
Migrate the applications in an AKS cluster that uses Kubenet as CNI to an AKS cluster that runs Cilium as CNI managed by the user. 

## Prerequisites
- Helm
- Kubectl
- Terraform
- Velero CLI
- Azure CLI
- An Azure subscription, with enough permissions to create, modify and manage resources
- A .env file with the following variables:
    ```sh
        ACR={ACR_NAME}
        DOCKER_HUB_USER={username_docker_hub}
        DOKCER_HUB_PAT={docket_hub_token}
    ```