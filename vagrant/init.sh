#!/bin/bash

apt-get update
apt-get upgrade -y

cat /home/vagrant/.ssh/id_guest.pub >>/home/vagrant/.ssh/authorized_keys
mv /tmp/sudoers_vagrant /etc/sudoers.d/vagrant
chown root:root /etc/sudoers.d/vagrant
