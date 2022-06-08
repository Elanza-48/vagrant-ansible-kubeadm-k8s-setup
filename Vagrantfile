ENV["LC_ALL"] = "en_US.UTF-8"
Vagrant.require_version ">= 2.2.10"


# variables
NODE_COUNT = 3
UBUNTU = "ubuntu/jammy64"
CENTOS = "centos/8"

Vagrant.configure("2") do |config|

  config.vm.define :kubernetes do |k8s|

    k8s.vm.provider :libvirt, primary: true do |libvirt|
      libvirt.driver = "kvm"
      # libvirt.host = "qemu:///system"
      libvirt.machine_arch = "x86_64"
      libvirt.machine_virtual_size = 24
      libvirt.graphics_type = "spice"
      libvirt.video_vram = 200
      libvirt.video_type = "qxl"
      libvirt.sound_type = "ich9"
      libvirt.disk_bus = "virtio"
      libvirt.boot = "cdrom"
      libvirt.boot = "hd"
      libvirt.vm.network :private_network,
        :management_network_name => "k8s-nat"
        :libvirt__network_name => "k8s-nat",
        :libvirt__dhcp_start => 
        :type => "dhcp",
        :

      libvirt.username = "root"
      libvirt.keymap = "en-us"
    end

    (1..NODE_COUNT).each do |i|

      if i == 1
        k8s.vm.box = UBUNTU
        k8s.vm.hostname="master-#{i}"
      else
        if i == 2
          k8s.vm.box = UBUNTU
        else
          k8s.vm.box = CENTOS
        end
        k8s.vm.hostname="node-#{i - 1}"
      end

      k8s.vm.network :private_network,
         :type => "dhcp"
         :ip => "10.8.2.#{i + 20}"

      k8s.vm.provider :libvirt do |libvirt|
        libvirt.cpus = 2
        libvirt.memory = 1024
      end
    end

  end
end