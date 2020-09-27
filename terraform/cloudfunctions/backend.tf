terraform {
  backend gcs {
    bucket = "mintak-tfstate"
    prefix = "linebot/functions"
  }
}
