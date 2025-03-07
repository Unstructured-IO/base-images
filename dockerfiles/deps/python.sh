#!/usr/bin/env bash

set -ex

if [ "$DOCKERFILE_TYPE" == "ubi9.4" ]; then
  echo "UBI 9.4 Python installation path"

  # Install development tools needed for Python compilation
  # Rather than using the Development Tools group which isn't available,
  # install the necessary packages individually
  dnf -y install \
    bzip2-devel \
    libffi-devel \
    make \
    git \
    sqlite-devel \
    openssl-devel \
    gcc \
    gcc-c++ \
    patch \
    rpm-build \
    redhat-rpm-config \
    python3-devel

  # UBI 9.4 has python 3.6 and pip as python3-pip
  dnf -y install python3-pip

  # Upgrade pip using the Python 3.6 that comes with UBI 9.4
  pip3 install --upgrade setuptools pip

  # Download and compile Python 3.12.3
  curl -O https://www.python.org/ftp/python/3.12.3/Python-3.12.3.tgz
  tar -xzf Python-3.12.3.tgz
  cd Python-3.12.3/ || exit 1
  ./configure --disable-ipv6
  make altinstall
  cd ..
  rm -rf Python-3.12.3*

  # Update pip for the new Python version
  pip3.12 install --upgrade setuptools pip

  # Create symbolic link for convenience
  ln -sf /usr/local/bin/python3.12 /usr/local/bin/python3

  # Clean up but don't try to remove the Development Tools group
  # since we didn't install it as a group
  rm -rf /var/cache/yum/*
  dnf clean all

else
  dnf -y install bzip2-devel libffi-devel make git sqlite-devel openssl-devel
  dnf -y install python-pip
  pip3.9 install --upgrade setuptools pip
  dnf -y groupinstall "Development Tools"
  curl -O https://www.python.org/ftp/python/3.12.3/Python-3.12.3.tgz
  tar -xzf Python-3.12.3.tgz
  cd Python-3.12.3/ || exit 1
  ./configure --enable-optimizations
  make altinstall
  cd ..
  rm -rf Python-3.12.3*
  pip3.12 install --upgrade setuptools pip
  ln -s /usr/local/bin/python3.12 /usr/local/bin/python3
  dnf -y groupremove "Development Tools"
  rm -rf /var/cache/yum/*
  dnf clean all
fi
