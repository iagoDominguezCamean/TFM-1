locals {
  sa_velero = "savelerocilium"

  #   velero_values = {
  #     chart_name = "velero"
  #     namespace  = "velero-system"
  #     repository = ""
  #     set = {
  #       "iamge.repository"                                             = ""
  #       "iamge.tag"                                                    = ""
  #       "configuration.provider"                                       = "azure"
  #       "configuration.backupStorageLocation[0].name"                  = "azure"
  #       "configuration.backupStorageLocation[0].bucket"                = "velero"
  #       "configuration.backupStorageLocation[0].config.resourceGroup"  = var.resource_group_name
  #       "configuration.backupStorageLocation[0].config.storageAccount" = azurerm_storage_account.sa_velero.id
  #       "snapshotsEnabled"                                             = "true"
  #       "deployRestic"                                                 = "true"
  #       "configuration.volumeSnapshotLocation[0].name"                 = "azure"
  #       "initContainers[0].name"                                       = "velero-plugin-for-microsoft-azure"
  #       "initContainers[0].image"                                      = ""
  #       "initContainers[0].volumeMounts[0].mountPath"                  = "/target"
  #       "initContainers[0].volumeMounts[0].name"                       = "plugins"
  #       "hostnetwork"                                                  = "false"
  #       "kubectl.image.repository"                                     = ""
  #       "kubectl.image.tag"                                            = ""
  #       "nodeSelector.role"                                            = "system-node"
  #     }
  #   }
}
