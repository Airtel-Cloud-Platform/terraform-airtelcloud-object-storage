module "object_storage" {
  source = "../../"

  name = "production-object-storage-bucket"

  replication_type = "Local"

  replication_tag = "south_S1"

  availability_zone = "S1"

  versioning = true

  object_locking = false

  tags = {
    Environment = "production"
    Team        = "platform"
    Purpose     = "artifacts"
  }
}
