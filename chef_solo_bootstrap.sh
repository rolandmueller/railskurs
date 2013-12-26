#!/usr/bin/env bash
apt-get -y update
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline5-dev libyaml-dev
cd /tmp
wget ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.0.tar.gz
tar -xvzf ruby-2.1.0.tar.gz
cd ruby-2.1.0/
./configure --prefix=/usr/local
make
make install
gem install chef ruby-shadow --no-ri --no-rdoc
