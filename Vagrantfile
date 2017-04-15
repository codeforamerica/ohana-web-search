# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # forward rails requests, like there isn't even a vm!
  config.vm.network :forwarded_port, guest: 8080, host: 8080

  # this is the default shared directory.
  code_path = "/vagrant"

  # update apt, get necessary packages, get rails ready.
  config.vm.provision :shell, inline: <<SCRIPT
    set -e
    echo "updating apt, installing curl..."
    apt-get update > /dev/null
    apt-get install curl git nodejs -y > /dev/null
    echo "installing rvm..."
    curl -sL https://get.rvm.io | sudo -iu vagrant bash
    sudo -iu vagrant bash -c "rvm install `cat #{code_path}/.ruby-version` > /dev/null"
    echo "running bundle"
    sudo -iu vagrant bash -l -c "cd #{code_path}&&rvm use --default `cat .ruby-version`&&bundle"
SCRIPT
end
