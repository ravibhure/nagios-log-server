#!/bin/bash
# Install nagios log server

export PATH=$PATH:/usr/bin
sudo yum -y update
sudo yum -y install epel-release
sudo yum -y update
sudo yum -y install wget git
cd /tmp ; wget http://assets.nagios.com/downloads/nagios-log-server/nagioslogserver-latest.tar.gz
cd /tmp/ ; tar xzf nagioslogserver-latest.tar.gz
cd /tmp/nagioslogserver ; ./fullinstall

# Disable iptables
iptables -F
service iptables stop
# Disable selinux
setenforce 0
