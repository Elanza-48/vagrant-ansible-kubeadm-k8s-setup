# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["LC_ALL"] = "en_US.UTF-8"
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.require_version ">= 2.3.2"


# variables
MASTER_NODE_COUNT = 1
WORKER_NODE_COUNT = 1

BOX_1 = "generic/ubuntu2204"
BOX_2 = "generic/alma9"

PRIVARE_IP="172.20.49."

Vagrant.configure("2") do |config|

  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.box_check_update = false
  config.vagrant.plugins = []

  
  # ------ K8S master(s) ------
  (1..MASTER_NODE_COUNT).each do |i|
    config.vm.define "master-#{i}", primary: true do |master|
      master.vm.box = BOX_1
      master.vm.hostname = "k8s-master-#{i}"
      master.vm.network :private_network, ip: PRIVARE_IP+ "#{10+i}", dhcp: true

      master.vm.provider :virtualbox do |vbox|
        vbox.gui= false
        vbox.check_guest_additions = true
        vbox.name="k8s-master-#{i}"
        vbox.cpus = 2
        vbox.memory = 2500

        vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vbox.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        vbox.customize ["modifyvm", :id, "--graphicscontroller", "vboxvga"]
      end

      # master.vm.provision :ansible do |ansible|
      #   ansible.limit = "all"
      #   ansible.playbook = "k8s-setup/master-playbook.yml"
      # end

    end
  end

  # ------ K8S workers ------
  (1..WORKER_NODE_COUNT).each do |i|
    config.vm.define "worker-#{i}"  do |worker|
      worker.vm.hostname = "k8s-worker-#{i}"
      worker.vm.box = i.even? ? BOX_2 : BOX_1
      worker.vm.network :private_network, ip: PRIVARE_IP+"#{20 + i}", dhcp: true

  
      worker.vm.provider :virtualbox do |vbox|
        vbox.gui= false
        vbox.check_guest_additions = true
        vbox.name="k8s-worker-#{i}"
        vbox.cpus = 2
        vbox.memory = 2048

        vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vbox.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        vbox.customize ["modifyvm", :id, "--graphicscontroller", "vboxvga"]
      end
    end
  end
end
