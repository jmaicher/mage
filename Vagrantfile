# -*- mode: ruby -*-
# vi: set ft=ruby :

box = 'precise32'
box_url = 'http://files.vagrantup.com/precise32.box'
hostname = 'mage.dev'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = box
  config.vm.box_url = box_url

  config.vm.hostname = hostname
  # mage-web
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  # mage-table
  config.vm.network :forwarded_port, guest: 4000, host: 4000
  config.vm.network :forwarded_port, guest: 4444, host: 4444

  # forward postgres port
  config.vm.network :forwarded_port, guest: 5432, host: 5432

  config.vm.synced_folder ".", "/mage" #, type: "rsync"

  config.vm.provision :puppet do |puppet|
   puppet.manifests_path = "mage-vm/puppet/manifests"
   puppet.module_path = "mage-vm/puppet/modules"
   puppet.manifest_file  = "base.pp"
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.
end
