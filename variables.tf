variable "name" {
  description = "Bucket name"

  type = string
  validation {
    condition     = length(trim(var.name, " ")) >= 3
    error_message = "Bucket name must be at least 3 characters."
  }
}

variable "replication_type" {
  description = "Replication type"

  type = string

  validation {
    condition = contains([
      "Local",
      "Replicated within region",
      "Replicated across region"
    ], var.replication_type)

    error_message = "Invalid replication_type."
  }
}

variable "replication_tag" {
  description = "Replication tag. Required by the provider for every replication_type."

  type = string

  validation {
    condition = contains([
      "north_N1", "north_N2", "north_N1_N2", "north_N2_N1",
      "north_south_N1_S1", "north_south_N2_S2",
      "south_S1", "south_S2", "south_S1_S2", "south_S2_S1",
      "south_north_S1_N1", "south_north_S2_N2",
    ], var.replication_tag)

    error_message = "Invalid replication_tag."
  }
}
variable "availability_zone" {
  description = "Availability zone"

  type = string

  validation {
    condition = contains(
      ["N1", "N2", "S1", "S2"],
      upper(var.availability_zone)
    )

    error_message = "availability_zone must be one of N1, N2, S1, or S2."
  }
}

variable "versioning" {
  description = "Enable versioning"

  type    = bool
  default = false
}

variable "object_locking" {
  description = "Enable object locking"

  type    = bool
  default = false
}

variable "object_lock_validity_days" {
  description = "Object lock retention in days (config.objLockValidityDays). Only sent when object_locking is true; the provider defaults to 30 when unset. Forces replacement."

  type    = number
  default = null

  validation {
    condition     = var.object_lock_validity_days == null || (var.object_lock_validity_days >= 1 && floor(var.object_lock_validity_days) == var.object_lock_validity_days)
    error_message = "object_lock_validity_days must be a whole number >= 1."
  }
}

variable "tags" {
  description = "Bucket tags"

  type    = map(string)
  default = {}
}
