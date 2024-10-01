provider "kubernetes" {
  host                   = data.terraform_remote_state.cloud-infra-api.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.cloud-infra-api.outputs.eks_cluster_certificate_authority_data)
  token                  = data.terraform_remote_state.cloud-infra-api.outputs.eks_cluster_token
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
          image = var.docker_image_url
          name  = var.app_name
          ports {
            container_port = var.app_port
          }

          env {
            name  = "APP_NAME"
            value = var.app_name
          }

          env {
            name  = "DDL_AUTO"
            value = var.ddl_auto
          }

          env {
            name  = "SHOW_SQL"
            value = var.show_sql
          }

          env {
            name  = "APP_PORT"
            value = var.app_port
          }

          env {
            name  = "URL_DATABASE"
            value = data.terraform_remote_state.cloud-infra-database.outputs.rds_endpoint
          }


          env {
            name  = "DB_NAME"
            value = data.terraform_remote_state.cloud-infra-database.outputs.db_name
          }

          env {
            name  = "USER_DATABASE"
            value = data.terraform_remote_state.cloud-infra-database.outputs.db_username
          }

          env {
            name  = "PASSWORD_DATABASE"
            value = data.terraform_remote_state.cloud-infra-database.outputs.db_password
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
      target_port = var.app_port
    }
  }
}
