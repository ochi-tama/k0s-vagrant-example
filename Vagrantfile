# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  $script = <<-'SCRIPT'
    apt update
    apt upgrade -y
  SCRIPT

  config.vm.box = "bento/ubuntu-22.04"
  config.vm.box_version = "202407.23.0"
  config.ssh.forward_agent = true
  config.vm.provision "file", source: "vagrant/sudoers", destination: "/tmp/sudoers_vagrant"

  replicas = 5

  (1..replicas).each do |i|
    config.vm.define "server-#{i}" do |node|
      node.vm.hostname = "server#{i}.internal"
      node.vm.provider "virtualbox" do |vb|
        vb.name = "server-#{i}"
        vb.memory = 2048
        vb.cpus = 1
        vb.check_guest_additions = false
      end

      node.vm.disk :disk, size: "50GB", primary: true

      node.vm.network "private_network", ip: "192.168.56.#{i + 1}", hostname: true
      node.vm.provision "shell", path: "vagrant/init.sh"
    end
  end
end
