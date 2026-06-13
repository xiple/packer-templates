# Xiple's Packer Templates

This project contains Xiple's packer build configuration.

Each packer configuration builds a vagrant box by default. All boxes in this repository are hosted on [HashiCorp Cloud Platform](https://portal.cloud.hashicorp.com/vagrant/discover/xiple).

Also, you can build locally as a vagrant box or as a VirtualBox archive by removing the vagrant post-processor. See steps below.

Available distributions :

|Name           |Directory    |
|---------------|-------------|
|Arch Linux     |archlinux    |
|Fedora 43      |fedora43     |
|Rocky Linux 10 |rockylinux10 |

## Requirements

The following software must be installed/present on your local machine before you can use Packer to build :

- [Packer](http://www.packer.io/)
- [VirtualBox](https://www.virtualbox.org/)

If you build Vagrant box :

- [Vagrant](http://vagrantup.com/)

## Usage

Adapt the below example for the desired distribution (ie change "archlinux" with one of the available distribution listed above)

```sh
cd archlinux
packer build archlinux.pkr.hcl
```

Wait a few minutes ☕

Packer should tell you it generated a vagrant box file in builds directory.

## Testing builds

### Vagrant box testing

A basic Vagrantfile is included in each directory for quick testing.

Below an example for `archlinux` box

1) Import the built box with `vagrant box add --name archlinux builds/archlinux.box`.
2) Check the imported box with `vagrant box list`.
3) Run `vagrant up`, then connect and test the VM with `vagrant ssh`.
4) Run `vagrant destroy -f` to tear down the VM and `vagrant box remove archlinux` to remove the imported box.

## License

MIT

## Notes

Repository inspired from [geerlingguy/packer-boxes](https://github.com/geerlingguy/packer-boxes).

Feel free to fork and customize for you own needs.
