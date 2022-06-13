# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["LC_ALL"] = "en_US.UTF-8"
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.require_version ">= 2.2.10"


# variables
MASTER_COUNT = 1
NODE_COUNT = 2
LINUX_1 = "generic/ubuntu2204"
LINUX_2 = "generic/alma9"

Vagrant.configure("2") do |config|

  config.vagrant.plugins = [
    "vagrant-libvirt"
  ]

  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provider "libvirt" do |libvirt|
    libvirt.driver = "kvm"
    libvirt.graphics_type = "spice"
    libvirt.video_vram = 200
    libvirt.video_type = "qxl"
    libvirt.sound_type = "ich9"
    libvirt.disk_bus = "virtio"
    libvirt.qemu_use_session = false
    libvirt.uri = "qemu:///system"
    libvirt.cpu_mode = "host-passthrough"
    libvirt.forward_ssh_port = true
    libvirt.username = "root"
    libvirt.keymap = "en-us"
  end
  
  # K8S Master
  (1..MASTER_COUNT).each do |i|
    config.vm.define "master-#{i}", primary: true do |master|
      master.vm.box = LINUX_1
      master.vm.hostname = "k8s-master-#{i}"

      master.vm.provider :libvirt do |libvirt|
        libvirt.host = "k8s-master-#{i}"
        libvirt.cpus = 2
        libvirt.memory = 2500
        libvirt.storage "file", size: '15G', type: 'qcow2'
      end
      master.vm.network :private_network, ip: "10.8.2.2#{i}"
    end
  end

  # K8S worker
  (1..NODE_COUNT).each do |i|
    config.vm.define "node-#{i}"  do |node|
      node.vm.hostname = "k8s-node-#{i}"
      node.vm.box = i.even? ? LINUX_2 : LINUX_1
  
      node.vm.provider :libvirt do |libvirt|
        libvirt.host = "k8s-node-#{NODE_COUNT}"
        libvirt.cpus = 2
        libvirt.memory = 1500
        libvirt.storage "file", size: '12G', type: 'qcow2'
      end
      node.vm.network :private_network, ip: "10.8.2.2#{5 + i}"
    end
  end
end