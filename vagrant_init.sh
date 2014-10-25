#!/bin/bash


echo 'Upgrade System.....'
sudo sed -i 's!archive.ubuntu!mirrors.aliyun!' /etc/apt/sources.list # 使用阿里云镜像，提供速度
sudo apt-get update
sudo apt-get -y upgrade

echo 'Install Some Software....'
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential libxslt-dev libxml2-dev zsh vim memcached git-core nodejs imagemagick postfix software-properties-common curl unzip ack-grep

echo 'Install MySQL....'
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
sudo apt-get install -y mysql-server  mysql-client libmysqlclient-dev
sudo sed -i 's/bind-address/#bind-address/g' /etc/mysql/my.cnf
service mysql restart

echo 'Install Ruby.....'
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.profile
rvm install ruby
 /bin/bash --login
rvm use ruby --default
gem sources --remove https://rubygems.org/
gem sources -a https://ruby.taobao.org/
gem install bundler rake

echo 'Init Project.....'

cd /vagrant/
cp config/project.yml.example config/project.yml
bundle install
rake db:create
rake db:migrate

echo 'Init Completed. Hello,World:)'