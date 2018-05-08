#! /usr/bin/env bash

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get upgrade -y linux-gcp linux-headers-gcp linux-image-gcp

source /etc/lsb-release && echo "deb http://download.rethinkdb.com/apt $DISTRIB_CODENAME main" | sudo tee /etc/apt/sources.list.d/rethinkdb.list
wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y rethinkdb
sudo apt-get -y autoremove;
sudo apt-get -y autoclean;

sudo cp /etc/rethinkdb/default.conf.sample /etc/rethinkdb/instances.d/instance1.conf;
echo "bind=all" | sudo tee -a /etc/rethinkdb/instances.d/instance1.conf;
sudo /etc/init.d/rethinkdb restart;
