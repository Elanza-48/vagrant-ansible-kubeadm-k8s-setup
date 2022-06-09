# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["LC_ALL"] = "en_US.UTF-8"
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.require_version ">= 2.2.10"


# variables
UBUNTU = "generic/ubuntu2204"
CENTOS = "centos/8"

Vagrant.configure("2") do |config|

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
  config.vm.define "master-1", primary: true do |master|
    master.vm.box = UBUNTU
    master.vm.hostname="k8s-master-1"

    master.vm.provider :libvirt do |libvirt|
      libvirt.host = "k8s-master-1"
      libvirt.cpus = 2
      libvirt.memory = 2000
      libvirt.storage "file", size: '15G', type: 'qcow2'
    end

    master.vm.network :private_network, ip: "10.8.2.#{21}"
  end

  # K8S worker 1
  config.vm.define "node-1"  do |node1|
    node1.vm.hostname="k8s-node-1"
    node1.vm.box = CENTOS

    node1.vm.provider :libvirt do |libvirt|
      libvirt.host = "k8s-node-1"
      libvirt.cpus = 2
      libvirt.memory = 1000
      libvirt.storage "file", size: '12G', type: 'qcow2'
    end

    node1.vm.network :private_network, ip: "10.8.2.22"
  end

   # K8S worker 2
  config.vm.define "node-2" do |node2|
    node2.vm.hostname="k8s-node-2"
    node2.vm.box = UBUNTU

    node2.vm.provider :libvirt do |libvirt|
      libvirt.host = "k8s-node-2"
      libvirt.cpus = 2
      libvirt.memory = 1000
      libvirt.storage "file", size: '12G', type: 'qcow2'
    end
      
    node2.vm.network :private_network, ip: "10.8.2.23"
  end
end