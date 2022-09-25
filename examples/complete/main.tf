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
