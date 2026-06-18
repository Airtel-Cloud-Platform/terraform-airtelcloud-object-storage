resource "airtelcloud_storage_bucket" "this" {
  name = var.name

  replication_type = var.replication_type
  replication_tag  = var.replication_tag

  availability_zone = var.availability_zone

  versioning     = var.versioning
  object_locking = var.object_locking

  tags = var.tags
}
