resource "b2_bucket" "cdn_bken_io" {
  bucket_name = "cdn-bken-io"
  bucket_type = "allPrivate"

  lifecycle_rules {
    file_name_prefix              = ""
    days_from_hiding_to_deleting  = 1
    days_from_uploading_to_hiding = 0
  }

  cors_rules {
    max_age_seconds = 3600
    allowed_origins = ["*"]
    allowed_headers = ["range"]
    cors_rule_name  = "downloadFromAnyOriginWithUpload"
    expose_headers = [
      "authorization",
      "x-bz-file-name",
      "x-bz-content-sha1"
    ]
    allowed_operations = [
      "s3_put",
      "s3_get",
      "s3_head",
      "s3_post",
      "s3_delete",
      "b2_upload_file",
      "b2_upload_part",
      "b2_download_file_by_id",
      "b2_download_file_by_name",
    ]
  }
}

resource "b2_bucket" "dev_cdn_bken_io" {
  bucket_name = "dev-cdn-bken-io"
  bucket_type = "allPrivate"

  lifecycle_rules {
    file_name_prefix              = ""
    days_from_hiding_to_deleting  = 1
    days_from_uploading_to_hiding = 0
  }

  cors_rules {
    max_age_seconds = 3600
    allowed_origins = ["*"]
    allowed_headers = ["range"]
    cors_rule_name  = "downloadFromAnyOriginWithUpload"
    expose_headers = [
      "authorization",
      "x-bz-file-name",
      "x-bz-content-sha1"
    ]
    allowed_operations = [
      "s3_put",
      "s3_get",
      "s3_head",
      "s3_post",
      "s3_delete",
      "b2_upload_file",
      "b2_upload_part",
      "b2_download_file_by_id",
      "b2_download_file_by_name",
    ]
  }
}

resource "b2_bucket" "registry_bken_io" {
  bucket_name = "registry-bken-io"
  bucket_type = "allPrivate"

  default_server_side_encryption {
    algorithm = "AES256"
    mode      = "SSE-B2"
  }
}

resource "b2_bucket" "bken_tf_state" {
  bucket_name = "bken-tf-state"
  bucket_type = "allPrivate"
}