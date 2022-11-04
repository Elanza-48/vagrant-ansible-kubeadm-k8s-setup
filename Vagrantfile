# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
spec = YAML.load_file(File.join(File.dirname(__FILE__), "spec.yml"))

ENV["LC_ALL"] = "en_US.UTF-8"
ENV['VAGRANT_NO_PARALLEL'] = true
ENV['VAGRANT_FORCE_COLOR'] = true


Vagrant.require_version ">= " + spec["vagrant-version"]
Vagrant.configure("2") do |config|

  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.box_check_update = false
  config.vagrant.plugins = []

  # ------ K8S master(s) ------
  (1..spec["master"]["node-count"]).each do |i|
    config.vm.define "master-#{i}", primary: true do |master|
      master.vm.box = spec["vm-boxes"][0]
      master.vm.hostname =  spec["master"]["network"]["hostname"]["prefix"] + "-#{i}"
      master.vm.network :private_network, 
        ip: spec["network"]["private"]["ip-octet-prefix"] + "." +
            spec["master"]["network"]["private"]["ip-octate-suffix"] + "#{i}",
        dhcp: true

      master.vm.provider :virtualbox do |vbox|
        vbox.gui = false
        vbox.check_guest_additions = true
        vbox.name = spec["master"]["box-name"] + "-#{i}"
        vbox.cpus = spec["master"]["cpus"]
        vbox.memory = spec["master"]["memory"]

        vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vbox.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        vbox.customize ["modifyvm", :id, "--graphicscontroller", "vboxvga"]
        vbox.customize ["modifyvm", :id, "--pae", "on"]
        # vbox.customize ["controlvm", :id, "--cpuexecutioncap", "75"]
        vbox.customize ["modifyvm", :id, "--groups", "/Vagrant-K8s-cluster"]
      end

      # master.vm.provision :ansible do |ansible|
      #   ansible.limit = "all"
      #   ansible.playbook = "k8s-setup/master-playbook.yml"
      # end

    end
  end

  # ------ K8S workers ------
  (1..spec["worker"]["node-count"]).each do |i|
    config.vm.define "worker-#{i}"  do |worker|
      worker.vm.hostname = spec["worker"]["network"]["hostname"]["prefix"] + "-#{i}"
      worker.vm.box = i.even? ? spec["vm-boxes"][1] : spec["vm-boxes"][0]
      worker.vm.network :private_network, 
        ip: spec["network"]["private"]["ip-octet-prefix"] + "." + 
            spec["worker"]["network"]["private"]["ip-octate-suffix"] + "#{i}",
        dhcp: true

      worker.vm.provider :virtualbox do |vbox|
        vbox.gui = false
        vbox.check_guest_additions = true
        vbox.name = spec["worker"]["box-name"] + "-#{i}"
        vbox.cpus = spec["worker"]["cpus"]
        vbox.memory = spec["worker"]["memory"]

        vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vbox.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        vbox.customize ["modifyvm", :id, "--graphicscontroller", "vboxvga"]
        vbox.customize ["modifyvm", :id, "--pae", "on"]
        # vbox.customize ["controlvm", :id, "--cpuexecutioncap", "75"]
        vbox.customize ["modifyvm", :id, "--groups", "/Vagrant-K8s-cluster"]
      end
    end

  end
end
