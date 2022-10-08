<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)
[![Tests](https://github.com/terraform-cisco-modules/terraform-intersight-policies-iscsi-boot/actions/workflows/terratest.yml/badge.svg)](https://github.com/terraform-cisco-modules/terraform-intersight-policies-iscsi-boot/actions/workflows/terratest.yml)

# Terraform Intersight Policies - iSCSI Boot
Manages Intersight iSCSI Boot Policies

Location in GUI:
`Policies` » `Create Policy` » `iSCSI Boot`

## Easy IMM

[*Easy IMM - Comprehensive Example*](https://github.com/terraform-cisco-modules/easy-imm-comprehensive-example) - A comprehensive example for policies, pools, and profiles.

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

provider "intersight" {
  apikey    = var.apikey
  endpoint  = var.endpoint
  secretkey = fileexists(var.secretkeyfile) ? file(var.secretkeyfile) : var.secretkey
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
  default     = ""
  description = "Intersight Secret Key Content."
  sensitive   = true
  type        = string
}

variable "secretkeyfile" {
  default     = "blah.txt"
  description = "Intersight Secret Key File Location."
  sensitive   = true
  type        = string
}
```

## Environment Variables

### Terraform Cloud/Enterprise - Workspace Variables
- Add variable apikey with the value of [your-api-key]
- Add variable secretkey with the value of [your-secret-file-content]

### Linux and Windows
```bash
export TF_VAR_apikey="<your-api-key>"
export TF_VAR_secretkeyfile="<secret-key-file-location>"
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.32 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | >=1.0.32 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authentication"></a> [authentication](#input\_authentication) | When using Authentication which type of authentication should be used.<br>* chap - perform CHAP Authentication<br>* mutual\_chap - Perform Mutual CHAP Authentication. | `string` | `"chap"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the Policy. | `string` | `""` | no |
| <a name="input_dhcp_vendor_id_iqn"></a> [dhcp\_vendor\_id\_iqn](#input\_dhcp\_vendor\_id\_iqn) | Auto target interface that is represented via the Initiator name or the DHCP vendor ID. The vendor ID can be up to 32 alphanumeric characters. | `string` | `""` | no |
| <a name="input_initiator_ip_pool"></a> [initiator\_ip\_pool](#input\_initiator\_ip\_pool) | The Name of an IP Pool. | `string` | `""` | no |
| <a name="input_initiator_ip_source"></a> [initiator\_ip\_source](#input\_initiator\_ip\_source) | Source Type of Initiator IP Address - DHCP/Static/Pool.<br>* DHCP - The IP address is assigned using DHCP, if available.<br>* Static - Static IPv4 address is assigned to the iSCSI boot interface based on the information entered in this area.<br>* Pool - An IPv4 address is assigned to the iSCSI boot interface from the management IP address pool. | `string` | `"Pool"` | no |
| <a name="input_initiator_static_ip_v4_config"></a> [initiator\_static\_ip\_v4\_config](#input\_initiator\_static\_ip\_v4\_config) | Object List of Initiator Static IPv4 Configuration<br>* default\_gateway - IP address of the default IPv4 gateway.<br>* ip\_address - Static IP address provided for iSCSI Initiator.<br>* primary\_dns - IP Address of the primary Domain Name System (DNS) server.<br>* secondary\_dns - IP Address of the secondary Domain Name System (DNS) server.<br>* subnet\_mask - A subnet mask is a 32-bit number that masks an IP address and divides the IP address into network address and host address. | <pre>object(<br>    {<br>      default_gateway = string<br>      ip_address      = string<br>      primary_dns     = optional(string, "208.67.220.220")<br>      secondary_dns   = optional(string, "")<br>      subnet_mask     = string<br>    }<br>  )</pre> | <pre>{<br>  "default_gateway": "**REQUIRED** if configuring static IP",<br>  "ip_address": "**REQUIRED** if configuring static IP",<br>  "primary_dns": "",<br>  "secondary_dns": "",<br>  "subnet_mask": "**REQUIRED** if configuring static IP"<br>}</pre> | no |
| <a name="input_iscsi_adapter_policy"></a> [iscsi\_adapter\_policy](#input\_iscsi\_adapter\_policy) | The Name of an iSCSI Adapter Policy. | `string` | `""` | no |
| <a name="input_iscsi_boot_password"></a> [iscsi\_boot\_password](#input\_iscsi\_boot\_password) | Password, if doing authentication. | `string` | `""` | no |
| <a name="input_moids"></a> [moids](#input\_moids) | Flag to Determine if pools and policies should be data sources or if they already defined as a moid. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the Policy. | `string` | `"default"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/. | `string` | `"default"` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | Map for Moid based Policies Sources. | `any` | `{}` | no |
| <a name="input_pools"></a> [pools](#input\_pools) | Map for Moid based Pool Sources. | `any` | `{}` | no |
| <a name="input_primary_target_policy"></a> [primary\_target\_policy](#input\_primary\_target\_policy) | The Name of the iSCSI Static Target Policy. | `string` | `""` | no |
| <a name="input_secondary_target_policy"></a> [secondary\_target\_policy](#input\_secondary\_target\_policy) | The Name of the iSCSI Static Target Policy. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of Tag Attributes to Assign to the Policy. | `list(map(string))` | `[]` | no |
| <a name="input_target_source_type"></a> [target\_source\_type](#input\_target\_source\_type) | Source Type of Targets - Auto/Static.<br>* Auto - Type indicates that the system selects the target interface automatically during iSCSI boot.<br>* Static - Type indicates that static target interface is assigned to iSCSI boot. | `string` | `"Auto"` | no |
| <a name="input_username"></a> [username](#input\_username) | Username, if doing authentication. | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_moid"></a> [moid](#output\_moid) | iSCSI Boot Policy Managed Object ID (moid). |
## Resources

| Name | Type |
|------|------|
| [intersight_vnic_iscsi_boot_policy.iscsi_boot](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_iscsi_boot_policy) | resource |
| [intersight_ippool_pool.ip](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/ippool_pool) | data source |
| [intersight_organization_organization.org_moid](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/organization_organization) | data source |
| [intersight_vnic_iscsi_adapter_policy.iscsi_adapter](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/vnic_iscsi_adapter_policy) | data source |
| [intersight_vnic_iscsi_static_target_policy.iscsi_static_target](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/vnic_iscsi_static_target_policy) | data source |
<!-- END_TF_DOCS -->