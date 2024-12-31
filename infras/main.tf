### SERCICE ACCOUNT FOR CLOUD RUN INVOKER ###
resource "google_service_account" "cloud_run_invoker" {
  account_id   = "cloud-run-invoker"
  display_name = "Cloud Run Invoker Service Account"
}

resource "google_project_iam_binding" "cloud_run_invoker_role" {
  project = var.project_id
  role    = "roles/run.invoker"

  members = [
    "serviceAccount:${google_service_account.cloud_run_invoker.email}"
  ]
}

output "service_account_email" {
  value = google_service_account.cloud_run_invoker.email
}

### CLOUD RUN LLM SERVICE ###
resource "google_cloud_run_v2_service" "llm-service" {
  name                = "llm-service"
  location            = var.location
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"
  # invoker_iam_disabled = false

  template {
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"
    containers {
      image = "lnguyennb/node-llm-server"
      ports {
        container_port = 6969
      }
      resources {
        limits = {
          cpu    = "8"
          memory = "8Gi"
        }
      }
      startup_probe {
        initial_delay_seconds = 10
        timeout_seconds       = 3
        period_seconds        = 3
        failure_threshold     = 5
        tcp_socket {
          port = 6969
        }
      }
      liveness_probe {
        http_get {
          path = "/ping"
        }
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
  }
}
