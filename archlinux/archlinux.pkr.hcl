packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
    vagrant = {
      version = "~> 1"
      source = "github.com/hashicorp/vagrant"
    }
  }
}

source "virtualbox-iso" "vbox-iso" {
  http_directory          = "${path.root}/http"
  #boot_command            = ["<wait><up><wait>e<wait><down><down><end><wait> inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg <leftCtrlOn>x<leftCtrlOff>"]
  boot_command            = [
    "<enter><wait40>",
    "curl http://{{ .HTTPIP }}:{{ .HTTPPort }}/install.sh -o /root/install.sh<enter>",
    "chmod +x /root/install.sh<enter>",
    "/root/install.sh<enter>"
  ]
  boot_wait               = "3s"
  communicator            = "ssh"
  cpus                    = 2
  disk_size               = 40000
  guest_os_type           = "ArchLinux_64"
  headless                = false
  iso_checksum            = "sha256:16502a7c18eed827ecead95c297d26f9f4bd57c4b3e4a8f4e2b88cf60e412d6f"
  iso_urls                = [
    "/data/work/iso/archlinux-2026.01.01-x86_64.iso"
  ]
  memory                  = 1024
  shutdown_command        = "sudo systemctl poweroff"
  ssh_username            = "vagrant"
  ssh_password            = "vagrant"
  ssh_timeout             = "20m"
  output_filename         = "archlinux-pkr"
  vm_name                 = "archlinux-pkr"
}

build {
  sources = ["source.virtualbox-iso.vbox-iso"]

  post-processor "vagrant" {
    output                  = "builds/archlinux.box"
  }
}
