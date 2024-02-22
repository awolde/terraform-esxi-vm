# terraform-esxi-vm

Creates vms on 2 esxi hosts without the need for vCenter.
Used for class to setup vms for students.

You will need a Vm that provides DHCP and routing traffic to the Internet.
I'm using shorewall and isc-dhcp to do that. Config will be shared here.

Esxi are setup with 1nic connected to two port Groups, 1 for vlan1 with vlan id 1 and one  is the default VM Network. vSwitch0 uplink is a single NIC to your lan.

When you create your router vm, it will have two nics. One to vlan1 port group, and one to the VM network. VMs created by this module will be connected to only vlan1, thereby traffic is segregated from your LAN.

