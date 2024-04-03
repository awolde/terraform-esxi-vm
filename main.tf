terraform {
  required_version = ">= 0.13"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}


provider "esxi" {
  alias         = "vmw1"
  esxi_hostname = "10.3.161.99"
  esxi_hostport = "22"
  esxi_hostssl  = "443"
  esxi_username = "root"
  esxi_password = var.pass
}

provider "esxi" {
  alias         = "vmw2"
  esxi_hostname = "10.3.161.79"
  esxi_hostport = "22"
  esxi_hostssl  = "443"
  esxi_username = "root"
  esxi_password = var.pass
}

provider "esxi" {
  alias         = "vmw3"
  esxi_hostname = "10.3.161.195"
  esxi_hostport = "22"
  esxi_hostssl  = "443"
  esxi_username = "root"
  esxi_password = var.pass
}

variable "pass" {}
variable "name" {}

data "template_file" "default" {
  template = file("${path.module}/master.yaml")
  vars = {
    HOSTNAME = var.name
  }
}

resource "esxi_guest" "vm1" {
  count              = 0
  provider           = esxi.vmw2
  guest_name         = "${var.name}-${count.index + 1}"
  disk_store         = "datastore1"
  guestos            = "ubuntu-64"
  boot_disk_type     = "thin"
  boot_disk_size     = "16"
  ovf_source         = "ubuntu-180.ovf"
  memsize            = "640"
  numvcpus           = "2"
  resource_pool_name = "/"
  virthwver          = "15"
  power              = "on"
  network_interfaces {
    virtual_network = "vlan1"
  }
  guestinfo = {
    userdata = base64encode(templatefile("${path.module}/master.yaml", { HOSTNAME = "${var.name}-${count.index + 1}"}))
    "userdata.encoding" = "base64"
  }
}

resource "esxi_guest" "vm2" {
  count              = 1
  provider           = esxi.vmw2
  guest_name         = "${var.name}-0${count.index + 1}"
  disk_store         = "datastore1"
  guestos            = "ubuntu-64"
  boot_disk_type     = "thin"
  boot_disk_size     = "16"
  ovf_source         = "ubuntu-180.ovf"
  memsize            = "2024"
  numvcpus           = "2"
  resource_pool_name = "/"
  virthwver          = "15"
  power              = "on"
  network_interfaces {
    virtual_network = "vlan1"
  }
  guestinfo = {
    userdata = base64encode(templatefile("${path.module}/master.yaml", { HOSTNAME = "${var.name}-0${count.index + 1}"}))
    "userdata.encoding" = "base64"
  }
}

resource "esxi_guest" "vm3" {
  count              = 1
  provider           = esxi.vmw3
  guest_name         = "${var.name}-0${count.index + 2}"
  disk_store         = "datastore1"
  guestos            = "ubuntu-64"
  boot_disk_type     = "thin"
  boot_disk_size     = "16"
  ovf_source         = "ubuntu-180.ovf"
  memsize            = "2024"
  numvcpus           = "2"
  resource_pool_name = "/"
  virthwver          = "15"
  power              = "on"
  network_interfaces {
    virtual_network = "vlan1"
  }
  guestinfo = {
    userdata = base64encode(templatefile("${path.module}/master.yaml", { HOSTNAME = "${var.name}-0${count.index + 2}"}))
    "userdata.encoding" = "base64"
  }
}
output "ip1" {
  value = esxi_guest.vm1.*.ip_address
}
output "ip2" {
  value = esxi_guest.vm2.*.ip_address
}
output "ip3" {
  value = esxi_guest.vm3.*.ip_address
}
