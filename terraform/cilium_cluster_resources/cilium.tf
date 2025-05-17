resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  # version    = "1.16.2"
  namespace = "kube-system"

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
    value = var.pod_cidr_list
  }
  set {
    name  = "hubble.relay.enabled"
    value = var.hubble_relay_enabled
  }
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
}
