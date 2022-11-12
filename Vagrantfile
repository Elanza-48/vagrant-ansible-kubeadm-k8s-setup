# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
spec = YAML.load_file(File.join(File.dirname(__FILE__), "spec.yml"))

ENV["LC_ALL"] = "en_US.UTF-8"
ENV['VAGRANT_NO_PARALLEL'] = 'yes'
ENV['VAGRANT_FORCE_COLOR'] = 'yes'


$copy_ssh = <<-SCRIPT
  echo $1 >> /home/vagrant/.ssh/authorized_keys
  echo $1 >> /root/.ssh/authorized_keys
SCRIPT

Vagrant.require_version ">= " + spec["vagrant-version"]
Vagrant.configure("2") do |config|

  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.box_check_update = false
  config.vagrant.plugins = []

  config.ssh.forward_agent=true
  config.ssh.keys_only=false

  # ------ K8S master(s) ------
  (1..spec["master"]["node-count"]).each do |i|
    private_ip = spec["network"]["private"]["ip-octet-prefix"] + "." +
    spec["master"]["network"]["private"]["ip-octet-suffix"] + "#{i}"

    config.vm.define "master-#{i}", primary: true do |master|
      master.vm.box = spec["vm-boxes"][0]
      master.vm.hostname =  spec["master"]["network"]["hostname"]["prefix"] + "-#{i}"
      master.vm.network :private_network, 
        ip: private_ip,
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

      (1..spec["master"]["node-count"]).each do |j|
          other_ip=spec["network"]["private"]["ip-octet-prefix"] + "." +
            spec["master"]["network"]["private"]["ip-octet-suffix"]

        unless i==j
          master.vm.provision :shell, 
            args: [
              "#{other_ip+j.to_s}",
              "#{spec["master"]["network"]["hostname"]["prefix"]}-#{j}"
            ],
            inline: <<-SHELL
              echo "$1 $2" >> /etc/hosts
            SHELL
        end
      end

      (1..spec["worker"]["node-count"]).each do |j|
        other_ip=spec["network"]["private"]["ip-octet-prefix"] + "." +
          spec["worker"]["network"]["private"]["ip-octet-suffix"]

        master.vm.provision :shell, 
          args: [
            "#{other_ip+j.to_s}",
            "#{spec["worker"]["network"]["hostname"]["prefix"]}-#{j}"
          ],
          inline: <<-SHELL
            echo "$1 $2" >> /etc/hosts
          SHELL
      end
      
      ssh_public_key_path="#{Dir.pwd}/#{spec["ssh"]["keypair"]["path"]}/master-#{i}/#{spec["ssh"]["keypair"]["name"]}.pub"
      master.vm.provision :shell, inline: $copy_ssh, args: ["#{File.readlines(ssh_public_key_path).first.strip}"]

      # master.vm.provision :ansible do |ansible|
      #   ansible.compatibility_mode = "2.0"
      #   ansible.limit = "all"
      #   ansible.verbose="v"
      #   ansible.playbook = "setup-playbook/common-playbook.yml"
      #   ansible.raw_arguments  = [
      #     "--private-key=/home/.../.vagrant/credentials/ssh/master-#{i}/ssh-keys",
      #     "--extra-vars='current_ip=#{private_ip}'"
      #   ]
      # end

    end
  end

  # ------ K8S workers ------
  (1..spec["worker"]["node-count"]).each do |i|
    private_ip = spec["network"]["private"]["ip-octet-prefix"] + "." + 
      spec["worker"]["network"]["private"]["ip-octet-suffix"] + "#{i}"

    config.vm.define "worker-#{i}"  do |worker|
      worker.vm.hostname = spec["worker"]["network"]["hostname"]["prefix"] + "-#{i}"
      worker.vm.box = i.even? ? spec["vm-boxes"][1] : spec["vm-boxes"][0]
      worker.vm.network :private_network, 
        ip: private_ip,
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

      (1..spec["worker"]["node-count"]).each do |j|
        other_ip=spec["network"]["private"]["ip-octet-prefix"] + "." +
          spec["worker"]["network"]["private"]["ip-octet-suffix"]

        unless i==j
          worker.vm.provision :shell, 
            args: [
              "#{other_ip+j.to_s}",
              "#{spec["worker"]["network"]["hostname"]["prefix"]}-#{j}"
            ],
            inline: <<-SHELL
              echo "$1 $2" >> /etc/hosts
            SHELL
        end
      end

      (1..spec["master"]["node-count"]).each do |j|
        other_ip=spec["network"]["private"]["ip-octet-prefix"] + "." +
          spec["master"]["network"]["private"]["ip-octet-suffix"]

        worker.vm.provision :shell, 
          args: [
            "#{other_ip+j.to_s}",
            "#{spec["master"]["network"]["hostname"]["prefix"]}-#{j}"
          ],
          inline: <<-SHELL
            echo "$1 $2" >> /etc/hosts
          SHELL
      end
    
      ssh_public_key_path="#{Dir.pwd}/#{spec["ssh"]["keypair"]["path"]}/worker-#{i}/#{spec["ssh"]["keypair"]["name"]}.pub"
      worker.vm.provision :shell, inline: $copy_ssh, args: ["#{File.readlines(ssh_public_key_path).first.strip}"]

      # worker.vm.provision :ansible do |ansible|
      #   ansible.limit = "all"
      #   ansible.verbose="v"
      #   # ansible.inventory_path="./setup-playbook/hosts.yml"
      #   ansible.playbook = "setup-playbook/common-playbook.yml"
      #   ansible.raw_arguments  = [
      #     "--private-key=/home/.../.vagrant/credentials/ssh/worker-#{i}/ssh-keys",
      #     "--extra-vars='current_ip=#{private_ip}'"
      #   ]
      # end
    end
  end
end
