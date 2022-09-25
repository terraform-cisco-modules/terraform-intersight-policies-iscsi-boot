<!-- BEGIN_TF_DOCS -->
# Terraform Intersight Policies - iSCSI Boot
Manages Intersight iSCSI Boot Policies

Location in GUI:
`Policies` » `Create Policy` » `iSCSI Boot`

## Example

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

## Environment Variables

### Terraform Cloud/Enterprise - Workspace Variables
- Add variable apikey with value of [your-api-key]
- Add variable secretkey with value of [your-secret-file-content]

### Linux
```bash
export TF_VAR_apikey="<your-api-key>"
export TF_VAR_secretkey=`cat <secret-key-file-location>`
```

### Windows
```bash
$env:TF_VAR_apikey="<your-api-key>"
$env:TF_VAR_secretkey="<secret-key-file-location>""
```
<!-- END_TF_DOCS -->