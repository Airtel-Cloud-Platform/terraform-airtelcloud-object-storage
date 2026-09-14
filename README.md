# Storage Bucket Module

Terraform module for provisioning and managing Airtel Cloud object storage buckets.

The module manages S3-compatible object storage buckets with support for replication, versioning, object locking, and tags.

## Features

* Creates and manages an Airtel Cloud object storage bucket.
* Supports S3-compatible object storage.
* Supports local storage within an availability zone.
* Supports replication within the same region.
* Supports replication across regions.
* Supports object versioning.
* Supports object locking.
* Supports bucket tags.
* Validates bucket name length.
* Validates supported replication types.
* Validates supported availability zones.
* Exposes bucket ID, bucket name, S3 endpoint, public endpoint, and bucket state.
* Provides a complete bucket object as an output.

## Usage

### Basic Example

```hcl
module "storage_bucket" {
  source = "Airtel-Cloud-Platform/storage-bucket/airtelcloud"

  name              = "example-storage-bucket"
  replication_type  = "Local"
  replication_tag   = "south_S1"
  availability_zone = "S1"

  versioning     = true
  object_locking = false

  tags = {
    Environment = "production"
    Type        = "private"
  }
}
```

### Replicated Bucket Example

```hcl
module "storage_bucket" {
  source = "Airtel-Cloud-Platform/storage-bucket/airtelcloud"

  name              = "example-replicated-bucket"
  replication_type  = "Replicated within region"
  replication_tag   = "south_S1_S2"
  availability_zone = "S1"

  versioning     = true
  object_locking = true

  tags = {
    Environment = "production"
    Type        = "replicated"
  }
}
```

## Creating Multiple Storage Buckets

Use Terraform `for_each` to create multiple storage buckets using the same module.

```hcl
locals {
  buckets = {
    application = {
      replication_type  = "Local"
      replication_tag   = "south_S1"
      availability_zone = "S1"
    }

    backup = {
      replication_type  = "Replicated within region"
      replication_tag   = "south_S1_S2"
      availability_zone = "S1"
    }
  }
}

module "storage_bucket" {
  for_each = local.buckets

  source = "Airtel-Cloud-Platform/storage-bucket/airtelcloud"

  name              = "example-${each.key}-bucket"
  replication_type  = each.value.replication_type
  replication_tag   = each.value.replication_tag
  availability_zone = each.value.availability_zone

  versioning     = true
  object_locking = false

  tags = {
    Environment = "production"
    Type        = each.key
  }
}
```

## Replication Configuration

The `replication_type`, `replication_tag`, and `availability_zone` arguments work together.

The `replication_tag` must be compatible with the selected `replication_type`.

### Replication Types

| Replication Type           | Description                                                        |
| -------------------------- | ------------------------------------------------------------------ |
| `Local`                    | Stores data locally within a single availability zone.             |
| `Replicated within region` | Replicates data between availability zones within the same region. |
| `Replicated across region` | Replicates data between availability zones in different regions.   |

### Replication Type and Replication Tag Mapping

| `replication_type`         | Allowed `replication_tag` | Replication         |
| -------------------------- | ------------------------- | ------------------- |
| `Local`                    | `north_N1`                | North N1            |
| `Local`                    | `north_N2`                | North N2            |
| `Local`                    | `south_S1`                | South S1            |
| `Local`                    | `south_S2`                | South S2            |
| `Replicated within region` | `north_N1_N2`             | North N1 → North N2 |
| `Replicated within region` | `north_N2_N1`             | North N2 → North N1 |
| `Replicated within region` | `south_S1_S2`             | South S1 → South S2 |
| `Replicated within region` | `south_S2_S1`             | South S2 → South S1 |
| `Replicated across region` | `north_south_N1_S1`       | North N1 → South S1 |
| `Replicated across region` | `north_south_N2_S2`       | North N2 → South S2 |
| `Replicated across region` | `south_north_S1_N1`       | South S1 → North N1 |
| `Replicated across region` | `south_north_S2_N2`       | South S2 → North N2 |

### Choosing a Replication Configuration

Use the following guidelines:

* Use `Local` when storage should remain within a single availability zone.
* Use `Replicated within region` when data should be replicated between availability zones in the same region.
* Use `Replicated across region` when data should be replicated between availability zones in different regions.

### Local Replication

For local storage in North N1:

```hcl
replication_type  = "Local"
replication_tag   = "north_N1"
availability_zone = "N1"
```

For local storage in North N2:

```hcl
replication_type  = "Local"
replication_tag   = "north_N2"
availability_zone = "N2"
```

For local storage in South S1:

```hcl
replication_type  = "Local"
replication_tag   = "south_S1"
availability_zone = "S1"
```

For local storage in South S2:

```hcl
replication_type  = "Local"
replication_tag   = "south_S2"
availability_zone = "S2"
```

### Replication Within a Region

For replication from N1 to N2 within the North region:

```hcl
replication_type  = "Replicated within region"
replication_tag   = "north_N1_N2"
availability_zone = "N1"
```

For replication from N2 to N1 within the North region:

```hcl
replication_type  = "Replicated within region"
replication_tag   = "north_N2_N1"
availability_zone = "N2"
```

For replication from S1 to S2 within the South region:

```hcl
replication_type  = "Replicated within region"
replication_tag   = "south_S1_S2"
availability_zone = "S1"
```

For replication from S2 to S1 within the South region:

```hcl
replication_type  = "Replicated within region"
replication_tag   = "south_S2_S1"
availability_zone = "S2"
```

### Replication Across Regions

For replication from North N1 to South S1:

```hcl
replication_type  = "Replicated across region"
replication_tag   = "north_south_N1_S1"
availability_zone = "N1"
```

For replication from North N2 to South S2:

```hcl
replication_type  = "Replicated across region"
replication_tag   = "north_south_N2_S2"
availability_zone = "N2"
```

For replication from South S1 to North N1:

```hcl
replication_type  = "Replicated across region"
replication_tag   = "south_north_S1_N1"
availability_zone = "S1"
```

For replication from South S2 to North N2:

```hcl
replication_type  = "Replicated across region"
replication_tag   = "south_north_S2_N2"
availability_zone = "S2"
```

> **Important:** The `replication_tag` must match the selected `replication_type`. The `availability_zone` should correspond to the source availability zone represented by the selected replication tag.

## Availability Zone

The module supports the following availability zones:

* `N1`
* `N2`
* `S1`
* `S2`

Example:

```hcl
availability_zone = "N1"
```

The module validates availability zones case-insensitively.

For example:

```hcl
availability_zone = "n1"
```

is accepted and evaluated as `N1`.

## Versioning

The `versioning` argument controls whether object versioning is enabled.

Versioning is disabled by default.

To enable versioning:

```hcl
versioning = true
```

To explicitly disable versioning:

```hcl
versioning = false
```

## Object Locking

The `object_locking` argument controls whether object locking is enabled.

Object locking is disabled by default.

To enable object locking:

```hcl
object_locking = true
```

To disable object locking:

```hcl
object_locking = false
```

> **Note:** The module does not expose a separate `object_lock_validity_days` input.

## Tags

The `tags` argument accepts a map of strings that is assigned to the bucket.

Example:

```hcl
tags = {
  Environment = "production"
  Type        = "private"
}
```

Multiple tags can be configured:

```hcl
tags = {
  Environment = "production"
  Application = "example"
  Owner       = "team"
}
```

If no tags are specified, the module uses an empty map.

## Inputs

| Name                | Description                                                                                    | Type          | Required | Default |
| ------------------- | ---------------------------------------------------------------------------------------------- | ------------- | -------- | ------- |
| `name`              | Name of the bucket. Must contain at least 3 characters after trimming spaces.                  | `string`      | Yes      | -       |
| `replication_type`  | Replication type for the bucket.                                                               | `string`      | Yes      | -       |
| `replication_tag`   | Replication configuration tag. Required for replicated bucket types.                           | `string`      | No       | `null`  |
| `availability_zone` | Availability zone associated with the bucket. Supported values are `N1`, `N2`, `S1`, and `S2`. | `string`      | Yes      | -       |
| `versioning`        | Whether object versioning is enabled.                                                          | `bool`        | No       | `false` |
| `object_locking`    | Whether object locking is enabled.                                                             | `bool`        | No       | `false` |
| `tags`              | Map of tags to assign to the bucket.                                                           | `map(string)` | No       | `{}`    |

## Input Details

### `name`

The name of the object storage bucket.

The module validates that the bucket name contains at least 3 characters after trimming spaces.

Example:

```hcl
name = "example-storage-bucket"
```

### `replication_type`

Specifies how the bucket data is replicated.

Valid values are:

```text
Local
Replicated within region
Replicated across region
```

Example:

```hcl
replication_type = "Local"
```

### `replication_tag`

Specifies the replication configuration.

The module allows this input to be omitted for `Local` replication.

For replicated bucket types, the value must be provided and cannot be empty.

Example:

```hcl
replication_tag = "south_S1_S2"
```

Refer to the replication mapping table for supported values.

### `availability_zone`

Specifies the availability zone associated with the bucket.

Supported values are:

```text
N1
N2
S1
S2
```

Example:

```hcl
availability_zone = "S1"
```

The module validation is case-insensitive.

### `versioning`

Controls whether object versioning is enabled.

Default:

```hcl
versioning = false
```

### `object_locking`

Controls whether object locking is enabled.

Default:

```hcl
object_locking = false
```

### `tags`

A map of string key-value pairs assigned to the bucket.

Default:

```hcl
tags = {}
```

Example:

```hcl
tags = {
  Environment = "production"
  Type        = "private"
}
```

## Outputs

| Name              | Description                                                                          |
| ----------------- | ------------------------------------------------------------------------------------ |
| `bucket_id`       | Bucket ID.                                                                           |
| `bucket_name`     | Bucket name.                                                                         |
| `s3_endpoint`     | S3 endpoint for the bucket.                                                          |
| `public_endpoint` | Public endpoint for the bucket.                                                      |
| `bucket_state`    | Current state of the bucket.                                                         |
| `bucket`          | Complete bucket object containing ID, name, S3 endpoint, public endpoint, and state. |

### `bucket_id`

Returns the bucket ID.

```hcl
output "bucket_id" {
  value = module.storage_bucket.bucket_id
}
```

### `bucket_name`

Returns the bucket name.

```hcl
output "bucket_name" {
  value = module.storage_bucket.bucket_name
}
```

### `s3_endpoint`

Returns the S3 endpoint for the bucket.

```hcl
output "s3_endpoint" {
  value = module.storage_bucket.s3_endpoint
}
```

### `public_endpoint`

Returns the public endpoint for the bucket.

```hcl
output "public_endpoint" {
  value = module.storage_bucket.public_endpoint
}
```

### `bucket_state`

Returns the current state of the bucket.

```hcl
output "bucket_state" {
  value = module.storage_bucket.bucket_state
}
```

### `bucket`

Returns the complete bucket object.

The output contains:

* `id`
* `name`
* `s3_endpoint`
* `public_endpoint`
* `state`

Example:

```hcl
output "bucket" {
  value = module.storage_bucket.bucket
}
```

## Import

An existing Airtel Cloud storage bucket can be imported using its bucket ID.

```shell
terraform import airtelcloud_storage_bucket.this <bucket-id>
```

After importing the resource, run:

```shell
terraform plan
```

to verify that the Terraform configuration matches the existing bucket.

## Important Notes

* The bucket `name` must contain at least 3 characters after trimming spaces.
* The provider requires the bucket name to be globally unique.
* `replication_type` must be one of `Local`, `Replicated within region`, or `Replicated across region`.
* `replication_tag` is optional for `Local` replication.
* `replication_tag` is required for replicated bucket types and cannot be empty.
* The `replication_tag` must be compatible with the selected `replication_type`.
* The module supports availability zones `N1`, `N2`, `S1`, and `S2`.
* Availability zone validation is case-insensitive.
* `versioning` defaults to `false`.
* `object_locking` defaults to `false`.
* The module does not expose `object_lock_validity_days`.
* `tags` defaults to an empty map.
* The module provides individual bucket outputs as well as a complete `bucket` object.
* Existing buckets can be imported using their bucket ID.

## Requirements

| Name                  | Version  |
| --------------------- | -------- |
| Terraform             | >= 1.5   |
| Airtel Cloud Provider | >= 1.2.4 |

````

### Also change `variables.tf`

Since you said the module supports all four AZs, make this change before creating the PR:

```hcl
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
````

Then your commit can contain both the **README update** and the **AZ validation fix**:

```bash
git add README.md variables.tf
git commit -m "docs: update storage bucket module documentation"
git push --set-upstream origin docs/update-storage-bucket-module
```

For the PR:

**Title**

```text
docs: update storage bucket module documentation
```

**Summary**

```text
Updated the storage bucket module documentation to align with the
airtelcloud_storage_bucket provider resource.

Changes:
- Updated module usage examples.
- Documented replication types and replication tag mappings.
- Documented all supported availability zones.
- Updated module inputs and outputs.
- Documented versioning, object locking, and tags.
- Added multiple bucket usage example.
- Added import documentation.
- Updated availability_zone validation to support N1, N2, S1, and S2.
- Removed provider attributes that are not exposed by the module.
```
