# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


resource "google_storage_bucket" "data_lakehouse_bucket" {
  name          = "${var.project_id}-ridership-lakehouse"
  location      = var.region
  force_destroy = true
  project       = var.project_id

  uniform_bucket_level_access = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
}

resource "google_storage_bucket" "iceberg_bq_catalog" {
  name          = "${var.project_id}-iceberg-bq-catalog"
  location      = var.region
  force_destroy = true
  project       = var.project_id

  uniform_bucket_level_access = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
}

resource "google_storage_bucket" "iceberg_rest_catalog" {
  name          = "${var.project_id}-iceberg-rest-catalog"
  location      = var.region
  force_destroy = true
  project       = var.project_id

  uniform_bucket_level_access = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
}

resource "google_storage_bucket" "spark_bucket" {
  name          = "${var.project_id}-dataproc-serverless"
  location      = var.region
  force_destroy = true
  project       = var.project_id

  uniform_bucket_level_access = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 2
    }
  }
}

resource "google_storage_bucket_object" "code_assets" {
  for_each       = fileset("${path.module}/../notebooks_and_code", "**")
  bucket         = google_storage_bucket.data_lakehouse_bucket.name
  name           = "notebooks_and_code/${each.value}"
  source         = "${path.module}/../notebooks_and_code/${each.value}"
  source_md5hash = filemd5("${path.module}/../notebooks_and_code/${each.value}")
}


output "gcs_bucket" {
  value = google_storage_bucket.data_lakehouse_bucket.name
}

output "spark_bucket" {
  value = google_storage_bucket.spark_bucket.name
}

output "iceberg_rest_catalog" {
  value = google_storage_bucket.iceberg_rest_catalog.name
}
