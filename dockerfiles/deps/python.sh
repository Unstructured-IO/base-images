#!/usr/bin/env bash

set -ex

dnf -y install bzip2-devel libffi-devel make git sqlite-devel openssl-devel
dnf -y install python-pip
pip3.9 install --upgrade setuptools pip
dnf -y groupinstall "Development Tools"
curl -O https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz
tar -xzf Python-3.10.14.tgz
cd Python-3.10.14/ || exit 1
./configure --enable-optimizations
make altinstall
cd ..
rm -rf Python-3.10.14*
pip3.10 install --upgrade setuptools pip
ln -s /usr/local/bin/python3.10 /usr/local/bin/python3
dnf -y groupremove "Development Tools"
rm -rf /var/cache/yum/*
dnf clean all
