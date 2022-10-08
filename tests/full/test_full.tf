data "intersight_organization_organization" "org_moid" {
  name = "terratest"
}

module "ip_pool" {
  source  = "terraform-cisco-modules/pools-ip/intersight"
  version = ">=1.0.5"

  assignment_order = "sequential"
  description      = "${var.name} IP Pool"
  ipv4_blocks = [
    {
      from = "198.18.10.10"
      size = 240
    }
  ]
  ipv4_config = [
    {
      gateway       = "198.18.10.1"
      netmask       = "255.255.255.0"
      primary_dns   = "208.67.220.220"
      secondary_dns = "208.67.222.222"
    }
  ]
  name         = var.name
  organization = "terratest"
}


module "adapter" {
  source  = "terraform-cisco-modules/policies-iscsi-adapter/intersight"
  version = ">=1.0.2"

  name         = var.name
  organization = "terratest"
}

module "static_target" {
  source  = "terraform-cisco-modules/policies-iscsi-static-target/intersight"
  version = ">=1.0.2"

  ip_address = "198.18.32.60"
  lun = [
    {
      bootable = true
      lun_id   = 0
    }
  ]
  name         = var.name
  organization = "terratest"
  port         = 3260
  target_name  = "iqn.1992-08.com.ci:sn.e461ee9f190611ebb06300a0985b4a87:vs.3"
}

module "main" {
  source               = "../.."
  description          = "${var.name} iSCSI Boot Policy."
  dhcp_vendor_id_iqn   = "00:25:B5:0A:00:00"
  initiator_ip_pool    = var.name
  initiator_ip_source  = "DHCP"
  iscsi_adapter_policy = var.name
  moids                = true
  name                 = var.name
  organization         = data.intersight_organization_organization.org_moid.results[0].moid
  policies = {
    iscsi_adapter = {
      "${var.name}" = {
        moid = module.adapter.moid
      }
    }
    iscsi_static_target = {
      "${var.name}" = {
        moid = module.static_target.moid
      }
    }
  }
  pools = {
    ip = {
      "${var.name}" = {
        moid = module.ip_pool.moid
      }
    }
  }
  primary_target_policy = var.name
  target_source_type    = "Static"
  username              = "admin"
}

output "adapter" {
  value = module.adapter.moid
}

output "ip_pool" {
  value = module.ip_pool.moid
}

output "static_target" {
  value = module.static_target.moid
}
