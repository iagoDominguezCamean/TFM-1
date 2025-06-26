data "kubernetes_service" "kubenet_service" {
  provider = kubernetes.kubenet
  metadata {
    name      = "nginx"
    namespace = "app-routing-system"
  }
}

data "kubernetes_service" "cilium_service" {
  provider = kubernetes.cilium
  metadata {
    name      = "nginx"
    namespace = "app-routing-system"
  }
}
