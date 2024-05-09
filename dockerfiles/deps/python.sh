#!/usr/bin/env bash

set -ex

dnf -y install bzip2-devel libffi-devel make git sqlite-devel openssl-devel
dnf -y install python-pip
pip3.9 install --upgrade setuptools pip
dnf -y groupinstall "Development Tools"

# Download SQLite source code
cd /tmp
curl -O https://www.sqlite.org/2024/sqlite-autoconf-3450300.tar.gz \
&& tar xvf sqlite-autoconf-3450300.tar.gz \
&& rm sqlite-autoconf-3450300.tar.gz

# Compile and install SQLite
cd /tmp/sqlite-autoconf-3450300
./configure \
&& make \
&& make install \
&& rm -rf /tmp/sqlite-autoconf-3450300

curl -O https://www.python.org/ftp/python/3.10.13/Python-3.10.13.tgz
tar -xzf Python-3.10.13.tgz
cd Python-3.10.13/ || exit 1
./configure --enable-optimizations
make altinstall
cd ..
rm -rf Python-3.10.13*
pip3.10 install --upgrade setuptools pip
ln -s /usr/local/bin/python3.10 /usr/local/bin/python3
# (Trevor) Setuptools for 3.9 has vulns, so we need to remove it
rpm --nodeps -e python3-setuptools-53.0.0-12.el9.noarch
rm -rf /usr/local/lib/python3.9/site-packages/setuptools
dnf -y groupremove "Development Tools"
rm -rf /var/cache/yum/*
dnf clean all