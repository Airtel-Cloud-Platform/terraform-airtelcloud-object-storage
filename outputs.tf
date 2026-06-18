output "bucket_id" {
  description = "Bucket ID"

  value = airtelcloud_storage_bucket.this.id
}

output "bucket_name" {
  description = "Bucket Name"

  value = airtelcloud_storage_bucket.this.name
}

output "s3_endpoint" {
  description = "S3 Endpoint"

  value = airtelcloud_storage_bucket.this.s3_endpoint
}

output "public_endpoint" {
  description = "Public Endpoint"

  value = airtelcloud_storage_bucket.this.public_endpoint
}

output "bucket_state" {
  description = "Bucket State"

  value = airtelcloud_storage_bucket.this.state
}

output "bucket" {
  description = "Complete Bucket Object"

  value = {
    id              = airtelcloud_storage_bucket.this.id
    name            = airtelcloud_storage_bucket.this.name
    s3_endpoint     = airtelcloud_storage_bucket.this.s3_endpoint
    public_endpoint = airtelcloud_storage_bucket.this.public_endpoint
    state           = airtelcloud_storage_bucket.this.state
  }
}
