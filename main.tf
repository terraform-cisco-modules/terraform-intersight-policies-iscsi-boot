#____________________________________________________________
#
# Intersight Organization Data Source
# GUI Location: Settings > Settings > Organizations > {Name}
#____________________________________________________________

data "intersight_organization_organization" "org_moid" {
  for_each = {
    for v in [var.organization] : v => v if length(
    regexall("[[:xdigit:]]{24}", var.organization)) == 0
  }
  name = each.value
}

data "intersight_ippool_pool" "ip" {
  for_each = {
    for v in compact([var.initiator_ip_pool]) : v => v if length(
    regexall("[[:xdigit:]]{24}", v)) == 0
  }
  name = each.value
}

data "intersight_vnic_iscsi_adapter_policy" "iscsi_adapter" {
  for_each = {
    for v in compact([var.iscsi_adapter_policy]) : v => v if length(
    regexall("[[:xdigit:]]{24}", v)) == 0
  }
  name = each.value
}

data "intersight_vnic_iscsi_static_target_policy" "iscsi_static_targets" {
  for_each = {
    for v in compact([var.primary_target_policy, var.secondary_target_policy]) : v => v if length(
    regexall("[[:xdigit:]]{24}", v)) == 0
  }
  name = each.value
}

#__________________________________________________________________
#
# Intersight iSCSI Boot Policy
# GUI Location: Policies > Create Policy > iSCSI Boot
#__________________________________________________________________

resource "intersight_vnic_iscsi_boot_policy" "iscsi_boot" {
  depends_on = [
    data.intersight_organization_organization.org_moid
  ]
  auto_targetvendor_name = var.dhcp_vendor_id_iqn
  chap = var.authentication == "chap" && var.target_source_type == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = var.iscsi_boot_password
      user_id               = var.username
    }
    ] : var.target_source_type == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = var.iscsi_boot_password
      user_id               = var.username
    }
  ] : null
  description         = var.description != "" ? var.description : "${var.name} iSCSI Boot Policy."
  initiator_ip_source = var.target_source_type == "Auto" ? "DHCP" : var.initiator_ip_source
  initiator_static_ip_v4_address = length(regexall("Static", var.initiator_ip_source)
  ) > 0 ? var.initiator_static_ip_v4_config.ip_address : ""
  initiator_static_ip_v4_config = var.target_source_type == "Static" ? [
    {
      additional_properties = ""
      class_id              = "ippool.IpV4Config"
      gateway = length(regexall("Static", var.initiator_ip_source)
      ) > 0 ? var.initiator_static_ip_v4_config.default_gateway : ""
      netmask = length(regexall("Static", var.initiator_ip_source)
      ) > 0 ? var.initiator_static_ip_v4_config.subnet_mask : ""
      object_type   = "ippool.IpV4Config"
      primary_dns   = var.initiator_static_ip_v4_config.primary_dns
      secondary_dns = var.initiator_static_ip_v4_config.secondary_dns
    }
  ] : null
  mutual_chap = var.authentication == "mutual_chap" && var.target_source_type == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = var.iscsi_boot_password
      user_id               = var.username
    }
    ] : var.target_source_type == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = ""
      user_id               = ""
    }
  ] : null
  name               = var.name
  target_source_type = var.target_source_type
  organization {
    moid = length(
      regexall("[[:xdigit:]]{24}", var.organization)
      ) > 0 ? var.organization : data.intersight_organization_organization.org_moid[
      var.organization].results[0
    ].moid
    object_type = "organization.Organization"
  }
  dynamic "initiator_ip_pool" {
    for_each = { for v in compact([var.initiator_ip_pool]) : v => v if var.target_source_type != "Auto" }
    content {
      moid = length(
        regexall("[[:xdigit:]]{24}", initiator_ip_pool.value)
      ) > 0 ? initiator_ip_pool.value : data.intersight_ippool_pool.ip[initiator_ip_pool.value].results[0].moid
    }
  }
  dynamic "iscsi_adapter_policy" {
    for_each = { for v in compact([var.iscsi_adapter_policy]) : v => v }
    content {
      moid = length(
        regexall("[[:xdigit:]]{24}", iscsi_adapter_policy.value)
        ) > 0 ? iscsi_adapter_policy.value : data.intersight_vnic_iscsi_adapter_policy.iscsi_adapter[
        iscsi_adapter_policy.value].results[0
      ].moid
    }
  }
  dynamic "primary_target_policy" {
    for_each = { for v in compact([var.primary_target_policy]) : v => v if var.target_source_type != "Auto" }
    content {
      moid = length(
        regexall("[[:xdigit:]]{24}", primary_target_policy.value)
        ) > 0 ? primary_target_policy.value : data.intersight_vnic_iscsi_static_target_policy.iscsi_static_targets[
        primary_target_policy.value].results[0
      ].moid
    }
  }
  dynamic "secondary_target_policy" {
    for_each = { for v in compact([var.secondary_target_policy]) : v => v if var.target_source_type != "Auto" }
    content {
      moid = length(
        regexall("[[:xdigit:]]{24}", secondary_target_policy.value)
        ) > 0 ? secondary_target_policy.value : data.intersight_vnic_iscsi_static_target_policy.iscsi_static_targets[
        secondary_target_policy.value].results[0
      ].moid
    }
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
