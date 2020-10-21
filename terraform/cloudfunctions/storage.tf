resource google_storage_bucket cloudfunctions_bucket {
  name          = "${var.project_id}_cloudfunctions"
  location      = "US-CENTRAL1"
  storage_class = "STANDARD"
  force_destroy = true

  versioning {
    enabled = false
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 90
    }
  }
}

data archive_file local_source_archive {
  type        = "zip"
  source_dir  = "../../example/python"
  output_path = "./tmp/${var.service_name}.zip"
}

resource google_storage_bucket_object source_archive {
  # オブジェクト名にアーカイブファイルのsha256を含めることで、cloudfunctions.source_archive_objectに変更として検知させ、デプロイするように工夫
  name                = "${var.service_name}_substr(${data.archive_file.local_source_archive.output_base64sha256}, 0, 32).zip"
  bucket              = google_storage_bucket.cloudfunctions_bucket.name
  source              = data.archive_file.local_source_archive.output_path
  content_disposition = "attachment"
  content_encoding    = "gzip"
  content_type        = "application/zip"
}
