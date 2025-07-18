variable "proxmox_endpoint" {
    type = string
    description = "proxmox endpoint"
}

variable "proxmox_api_token" {
    type = string
    description = "proxmox api token"
}

variable "ssh_pub_file" {
    type = string
    description = "path of the ssh key public file"
}

variable "lxc_pass" {
  type = string
  description = "container password"
}