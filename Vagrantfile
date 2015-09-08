# -*- mode: ruby -*-
# vi: set ft=ruby :

plugins = %w{ vagrant-triggers }

plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin)
      system("vagrant plugin install #{plugin}") || exit!
      exit system('vagrant', *ARGV)
  end
end

# Minimum vagrant version
Vagrant.require_version '>= 1.7.2'
#TODO: Can we stub in a plugin update?

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Build using the ubuntu 14.04 LTS box.
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |v, override|
    v.name = 'Linux Class Automation Assignment'
    v.memory = ENV['VAGRANT_MEMORY'] || 4096
    v.cpus = ENV['VAGRANT_CPUS'] || 4
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    override.vm.network :private_network, ip: "192.168.44.10"
  end

  if Vagrant.has_plugin?("vagrant-lxc")
    config.vm.provider :lxc do |lxc, override|
      override.vm.box = "fgrehm/precise64-lxc"
      override.vm.network :private_network, ip: "192.168.44.10", lxc__bridge_name: 'vlxcbr1'
      lxc.customize 'cgroup.memory.limit_in_bytes', '4096M'
    end
  end

  config.vm.provision "shell", path: 'bootstrap.sh'

end

