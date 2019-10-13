terraform {
  backend "gcs" {
    bucket = "storage-bucket-ttest"
    prefix = "prod"
  }
}

