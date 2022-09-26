#____________________________________________________________
#
# Ethernet iSCSI Boot Policy Variables Section.
#____________________________________________________________

variable "authentication" {
  default     = "chap"
  description = <<-EOT
    When using Authentication which type of authentication should be used.
    * chap - perform CHAP Authentication
    * mutual_chap - Perform Mutual CHAP Authentication.
  EOT
  type        = string
}

variable "description" {
  default     = ""
  description = "Description for the Policy."
  type        = string
}

variable "dhcp_vendor_id_iqn" {
  default     = ""
  description = "Auto target interface that is represented via the Initiator name or the DHCP vendor ID. The vendor ID can be up to 32 alphanumeric characters."
  type        = string
}

variable "initiator_ip_pool" {
  default     = ""
  description = "The Name of an IP Pool."
  type        = string
}

variable "initiator_ip_source" {
  default     = "Pool"
  description = <<-EOT
    Source Type of Initiator IP Address - DHCP/Static/Pool.
    * DHCP - The IP address is assigned using DHCP, if available.
    * Static - Static IPv4 address is assigned to the iSCSI boot interface based on the information entered in this area.
    * Pool - An IPv4 address is assigned to the iSCSI boot interface from the management IP address pool.
  EOT
  type        = string
}

variable "initiator_static_ip_v4_config" {
  default = {
    default_gateway = "**REQUIRED** if configuring static IP"
    ip_address      = "**REQUIRED** if configuring static IP"
    primary_dns     = ""
    secondary_dns   = ""
    subnet_mask     = "**REQUIRED** if configuring static IP"
  }
  description = <<-EOT
    Object List of Initiator Static IPv4 Configuration
    * default_gateway - IP address of the default IPv4 gateway.
    * ip_address - Static IP address provided for iSCSI Initiator.
    * primary_dns - IP Address of the primary Domain Name System (DNS) server.
    * secondary_dns - IP Address of the secondary Domain Name System (DNS) server.
    * subnet_mask - A subnet mask is a 32-bit number that masks an IP address and divides the IP address into network address and host address.
  EOT
  type = object(
    {
      default_gateway = string
      ip_address      = string
      primary_dns     = optional(string, "208.67.220.220")
      secondary_dns   = optional(string, "")
      subnet_mask     = string
    }
  )
}

variable "iscsi_adapter_policy" {
  default     = ""
  description = "The Name of an iSCSI Adapter Policy."
  type        = string
}

variable "iscsi_boot_password" {
  default     = ""
  description = "Password, if doing authentication."
  sensitive   = true
  type        = string
}

variable "name" {
  default     = "default"
  description = "Name for the Policy."
  type        = string
}

variable "organization" {
  default     = "default"
  description = "Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/."
  type        = string
}

variable "primary_target_policy" {
  default     = ""
  description = "The Name of the iSCSI Static Target Policy."
  type        = string
}

variable "secondary_target_policy" {
  default     = ""
  description = "The Name of the iSCSI Static Target Policy."
  type        = string
}

variable "tags" {
  default     = []
  description = "List of Tag Attributes to Assign to the Policy."
  type        = list(map(string))
}

variable "target_source_type" {
  default     = "Auto"
  description = <<-EOT
    Source Type of Targets - Auto/Static.
    * Auto - Type indicates that the system selects the target interface automatically during iSCSI boot.
    * Static - Type indicates that static target interface is assigned to iSCSI boot.
  EOT
  type        = string
}

variable "username" {
  description = "Username, if doing authentication."
  type        = string
}
