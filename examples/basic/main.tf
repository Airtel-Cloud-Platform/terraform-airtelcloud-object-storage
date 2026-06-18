module "object_storage" {
  source = "../../"

  name = "my-object-storage-bucket"

  replication_type = "Local"

  replication_tag = "south_S1"

  availability_zone = "S1"
}
