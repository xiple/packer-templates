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
  boot_command            = ["<wait><up><wait>e<wait><down><down><end><wait> inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg <leftCtrlOn>x<leftCtrlOff>"]
  boot_wait               = "3s"
  communicator            = "ssh"
  cpus                    = 2
  disk_size               = 50000
  guest_os_type           = "RedHat_64"
  headless                = false
  iso_checksum            = "file:https://download.fedoraproject.org/pub/fedora/linux/releases/43/Server/x86_64/iso/Fedora-Server-43-1.6-x86_64-CHECKSUM"
  iso_urls                = [
    "/data/work/iso/Fedora-Server-netinst-x86_64-43-1.6.iso",
    "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Server/x86_64/iso/Fedora-Server-netinst-x86_64-43-1.6.iso"
  ]
  memory                  = 1024
  shutdown_command        = "sudo systemctl poweroff"
  ssh_username            = "vagrant"
  ssh_password            = "vagrant"
  ssh_timeout             = "20m"
  output_filename         = "fedora43-pkr"
  vm_name                 = "fedora43-pkr"
}

build {
  sources = ["source.virtualbox-iso.vbox-iso"]

  post-processor "vagrant" {
    output                  = "builds/fedora43.box"
  }
}
