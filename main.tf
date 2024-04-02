provider "google" {
  project = "deans-playground"
  region  = "me-west1"
  impersonate_service_account = "playground-devops@deans-playground.iam.gserviceaccount.com"
}

module "cf-http" {
  source      = "git::ssh://dean.sorie@kyndryl.com@source.developers.google.com:2022/p/deans-playground/r/cloud-foundation-fabric//modules/cloud-function-v2"
  project_id  = "deans-playground"
  region      = "me-west1"
  prefix      = "my-prefix"
  name        = "test-cf-http"
  bucket_name = "test-cf-bundles"
  bucket_config = {
    lifecycle_delete_age_days = 1
  }
  bundle_config = {
    source_dir = "./hi"
  }
}

module "pubsub" {
  source      = "git::ssh://dean.sorie@kyndryl.com@source.developers.google.com:2022/p/deans-playground/r/cloud-foundation-fabric//modules/pubsub"
  project_id = "dean-playground"
  name       = "my-topic"
  subscriptions = {
    test-cloudstorage = {
      cloud_storage = {
        bucket          = "test-cf-bundles"
        filename_prefix = "test_prefix"
        filename_suffix = "test_suffix"
        max_duration    = "100s"
        max_bytes       = 1000
        avro_config = {
          write_metadata = true
        }
      }
    }
  }
}
