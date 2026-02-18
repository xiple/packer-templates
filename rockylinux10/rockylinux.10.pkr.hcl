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
  iso_checksum            = "sha256:5aafc2c86e606428cd7c5802b0d28c220f34c181a57eefff2cc6f65214714499"
  iso_url                 = "/home/debian/Téléchargements/Rocky-10.1-x86_64-minimal.iso"
  memory                  = 1024
  shutdown_command        = "sudo systemctl poweroff"
  ssh_username            = "vagrant"
  ssh_password            = "vagrant"
  ssh_timeout             = "20m"
  output_filename         = "rockylinux10-pkr"
  vm_name                 = "rockylinux10-pkr"
}

build {
  sources = ["source.virtualbox-iso.vbox-iso"]

  post-processor "vagrant" {
    output                  = "builds/rockylinux10.box"
  }
}
