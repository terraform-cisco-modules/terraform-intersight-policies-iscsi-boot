<!-- BEGIN_TF_DOCS -->
# iSCSI Boot Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

### main.tf
```hcl
module "iscsi_boot_auto" {
  source  = "terraform-cisco-modules/policies-iscsi-boot/intersight"
  version = ">= 1.0.1"

  dhcp_vendor_id_iqn   = "00:80:E5:0A:12:34"
  iscsi_adapter_policy = "default"
  description          = "Auto iSCSI Boot Policy."
  name                 = "auto"
  organization         = "default"
  target_source_type   = "Auto"
}

module "iscsi_boot_pool" {
  source  = "terraform-cisco-modules/policies-iscsi-boot/intersight"
  version = ">= 1.0.1"

  initiator_ip_pool     = "default"
  initiator_ip_source   = "Pool"
  iscsi_adapter_policy  = "default"
  primary_target_policy = "default"
  description           = "Pool iSCSI Boot Policy."
  name                  = "pool"
  organization          = "default"
  target_source_type    = "Static"
}
```

### provider.tf
```hcl
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
  required_version = ">=1.3.0"
}
```

### variables.tf
```hcl
variable "apikey" {
  description = "Intersight API Key."
  sensitive   = true
  type        = string
}

variable "endpoint" {
  default     = "https://intersight.com"
  description = "Intersight URL."
  type        = string
}

variable "secretkey" {
  description = "Intersight Secret Key."
  sensitive   = true
  type        = string
}
```
<!-- END_TF_DOCS -->