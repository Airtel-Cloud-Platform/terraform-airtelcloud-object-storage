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
  description = "Replication tag"

  type    = string
  default = null
  validation {
    condition = (
      var.replication_type == "Local" ||
      (var.replication_tag != null && trim(var.replication_tag, " ") != "")
    )

    error_message = "replication_tag is required for replicated bucket types."
  }
}
variable "availability_zone" {
  description = "Availability zone"

  type = string
  validation {
    condition = contains(
      ["S1", "S2"],
      upper(var.availability_zone)
    )

    error_message = "availability_zone must be S1 or S2."
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

variable "tags" {
  description = "Bucket tags"

  type    = map(string)
  default = {}
}
