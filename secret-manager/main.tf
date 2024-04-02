provider "google" {
  project = "deans-playground"
  region  = "me-west1"
  impersonate_service_account = "playground-devops@deans-playground.iam.gserviceaccount.com"
}

resource "google_secret_manager_secret" "my_secret" {
  project      = "deans-playground"
  secret_id    = "pub-key"
  replication {
   auto {}
  }
}

resource "google_secret_manager_secret_version" "my_secret_version" {
  secret      = google_secret_manager_secret.my_secret.id
  secret_data = filebase64("./ec_public.pem")
}
