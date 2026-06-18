# Airtel Cloud Object Storage Terraform Module

Terraform module for provisioning Airtel Cloud Object Storage Buckets.

## Features

- Creates S3-compatible Object Storage Buckets
- Supports Versioning
- Supports Object Locking
- Supports Bucket Tagging
- Supports Replication Configuration
- Exposes Bucket Endpoints and Metadata

## Usage

### Basic Example

```hcl
module "object_storage" {
  source = "Airtel-Cloud-Platform/object-storage/airtelcloud"

  name = "my-object-storage-bucket"

  replication_type = "Local"

  replication_tag = "south_S1"

  availability_zone = "S1"
}
```

### Complete Example

```hcl
module "object_storage" {
  source = "Airtel-Cloud-Platform/object-storage/airtelcloud"

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
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| name | Bucket Name | string | Yes |
| replication_type | Replication Type | string | Yes |
| replication_tag | Replication Tag | string | Yes |
| availability_zone | Availability Zone | string | Yes |
| versioning | Enable Versioning | bool | No |
| object_locking | Enable Object Locking | bool | No |
| tags | Bucket Tags | map(string) | No |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | Bucket ID |
| bucket_name | Bucket Name |
| s3_endpoint | S3 Endpoint |
| public_endpoint | Public Endpoint |
| bucket_state | Bucket State |
| bucket | Complete Bucket Object |

## Notes

Supported replication types:

- Local
- Replicated within region
- Replicated across region

Bucket names must be globally unique.

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.5 |
| airtelcloud Provider | >= 1.0.4 |
