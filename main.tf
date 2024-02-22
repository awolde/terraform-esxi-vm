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

variable "pass" {}
variable "name" {}

resource "esxi_guest" "vm1" {
  count              = 1
  provider           = esxi.vmw1
  guest_name         = "${var.name}-${count.index}"
  disk_store         = "datastore1"
  guestos            = "debian10-64"
  boot_disk_type     = "thin"
  boot_disk_size     = "16"
  ovf_source         = "vmst.ovf"
  memsize            = "512"
  numvcpus           = "1"
  resource_pool_name = "/"
  power              = "on"
  network_interfaces {
    virtual_network = "vlan1"
  }
}

resource "esxi_guest" "vm2" {
  count              = 1
  provider           = esxi.vmw2
  guest_name         = "${var.name}-${count.index+1}"
  disk_store         = "datastore1"
  guestos            = "debian10-64"
  boot_disk_type     = "thin"
  boot_disk_size     = "16"
  ovf_source         = "vmst.ovf"
  memsize            = "512"
  numvcpus           = "1"
  resource_pool_name = "/"
  power              = "on"
  network_interfaces {
    virtual_network = "vlan1"
  }
}

output "ip1" {
  value = esxi_guest.vm1.*.ip_address
}
output "ip2" {
  value = esxi_guest.vm2.*.ip_address
}
