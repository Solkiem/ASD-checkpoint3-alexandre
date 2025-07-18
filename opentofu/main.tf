data "local_file" "ssh_public_key" {
  filename = var.ssh_pub_file
}

resource "proxmox_virtual_environment_container" "debian12-lxc" {
  description = "Managed by opentofu"

  node_name = "ns3065162"
  vm_id     = 244
  
  unprivileged = true

  features {
    nesting = true
  }

  initialization {
    hostname = "checkpoint3-alexandre"

    ip_config {
      ipv4 {
        address = "192.168.1.244/24" # Here 192.168.1.XXX - XXX needs to be same as vm_id, i tried to use a variable using ${var.vm_id} but got some errors, so replace XXX by the id of your vm
        gateway = "192.168.1.254"
      }
    }

    user_account {
      keys = [
        trimspace(data.local_file.ssh_public_key.content)
      ]
      password = var.lxc_pass
    }
  }

  network_interface {
    name = "eth0"
    bridge = "vmbr2"
  }

  disk {
    datastore_id = "local"
    size         = 4
  }
  
  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
    type             = "debian"
  }

  mount_point {
    # volume mount, a new volume will be created by PVE
    volume = "local"
    size   = "10G"
    path   = "/mnt/volume"
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }
}
