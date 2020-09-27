terraform {
  # use Google Cloud Storage
  backend gcs {
    bucket = "mintak-tfstate"
    prefix = "linebot"
  }
}
