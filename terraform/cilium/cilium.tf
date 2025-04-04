resource "helm_release" "cilium" {
  count = var.install_cilium ? 1 : 0
  
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
#   version    = "1.16.2"
  namespace  = "kube-system"

  set {
    name  = "aksbyocni.enabled"
    value = "true"
  }
  set {
    name  = "nodeinit.enabled"
    value = "true"
  }
  set {
    name  = "ipam.operator.clusterPoolIPv4PodCIDRList"
    value = "10.10.0.0/22"
  }
  set {
    name  = "hubble.relay.enabled"
    value = "false"
  }
}