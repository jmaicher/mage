# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

box = 'precise64'
box_url = 'http://files.vagrantup.com/precise64.box'
hostname = 'mage.dev'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = box
  config.vm.box_url = box_url

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end

  # Use nfs!!
  config.vm.synced_folder ".", "/vagrant", :nfs => true
  # Private network necessary for nfs
  config.vm.network :private_network, ip: "10.11.12.13"


  # -- Networking ------------------------------------------

  config.vm.hostname = hostname

  config.vm.network :forwarded_port, guest: 8000, host: 8000
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.network :forwarded_port, guest: 5432, host: 5432


  # -- Provisioning ----------------------------------------
  vm_mage_home = "/vagrant"
  provision_dir = "mage/mage-env/provision"

  vm = config.vm
  vm.provision :shell, path: "#{provision_dir}/base_provision"
  vm.provision :shell, path: "#{provision_dir}/ruby_provision"
  vm.provision :shell, path: "#{provision_dir}/phantomjs_provision"
  vm.provision :shell, path: "#{provision_dir}/nodejs_provision"
  # Install nginx and copy config/sites
  vm.provision :shell, path: "#{provision_dir}/nginx_provision"
  vm.provision :shell, inline: "cp #{vm_mage_home}/#{provision_dir}/nginx/nginx.conf /etc/nginx/nginx.conf"
  vm.provision :shell, inline: "cp #{vm_mage_home}/#{provision_dir}/nginx/mage.prod /etc/nginx/sites-enabled"
  vm.provision :shell, inline: "cp #{vm_mage_home}/#{provision_dir}/nginx/mage.dev /etc/nginx/sites-enabled"
  # Restart nginx
  vm.provision :shell, inline: "service nginx restart"

  vm.provision :docker do |docker|
    docker.version = "0.10.0"
    docker.build_image "#{vm_mage_home}/db", args: "-t mage/db"
    docker.run "mage/db", args: "-d -p 5432:5432 --name mage_db"
  end

  vm.provision :shell, path: "#{provision_dir}/vagrant_provision"

end

# mage-web
# config.vm.network :forwarded_port, guest: 3000, host: 3000
# mage-table
# config.vm.network :forwarded_port, guest: 4000, host: 4000
# config.vm.network :forwarded_port, guest: 4444, host: 4444
# mage-mobile
# config.vm.network :forwarded_port, guest: 5000, host: 5000
# config.vm.network :forwarded_port, guest: 5555, host: 5555

