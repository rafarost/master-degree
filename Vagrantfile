# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|

  config.vm.hostname = 'alemao-master-degree'
  config.vm.box = 'ubuntu/trusty64'
  config.vm.guest = :ubuntu
  config.vm.provision(:shell, path: 'bootstrap.sh')
  config.vm.network(:public_network, bridge: 'eth0')

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--name', config.vm.hostname]
    vb.customize ['modifyvm', :id, '--memory', '4096']
    vb.customize ['modifyvm', :id, '--cpus', '1']
    vb.customize ['modifyvm', :id, '--ioapic', 'on']
  end
end
