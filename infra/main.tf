provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.eks_cluster_certificate)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

resource "kubernetes_namespace" "fastfood_namespace" {
  metadata {
    name = var.app_name
  }
}

resource "kubernetes_deployment" "fastfood_api" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.fastfood_namespace.metadata[0].name
  }

  spec {
    replicas = var.qty_replica

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          image = "${var.image_repo}/${var.app_name}:${var.image_version}" # Imagem Docker publicada
          name  = var.app_name
          ports {
            container_port = 8080
          }

          env {
            name  = "DB_HOST"
            value = data.terraform_remote_state.rds.outputs.rds_endpoint
          }

          env {
            name  = "DB_NAME"
            value = "fastfood"
          }

          env {
            name  = "DB_USER"
            value = "admin"
          }

          env {
            name  = "DB_PASSWORD"
            value = data.terraform_remote_state.rds.outputs.db_password
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "fastfood_service" {
  metadata {
    name      = "${var.app_name}-service"
    namespace = kubernetes_namespace.fastfood_namespace.metadata[0].name
  }

  spec {
    selector = {
      app = var.app_name
    }

    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 8080
    }
  }
}
