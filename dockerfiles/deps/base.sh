#!/usr/bin/env bash

GPU_ENABLED="${GPU_ENABLED:-true}"

echo "GPU enabled: $GPU_ENABLED"

dnf -y update
dnf -y upgrade
dnf -y install poppler-utils xz-devel wget tar make which mailcap dnf-plugins-core compat-openssl11

ARCH=$(uname -m)

# Only install CUDA if GPU enabled
if [[ "$GPU_ENABLED" == "true" ]]; then
  echo "Installing CUDA dependencies"
  if [[ "$ARCH" == "x86_64" ]] || [[ "$ARCH" == "amd64" ]]; then
    dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo
    dnf -y install cuda-11-8
  else
    dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/cross-linux-sbsa/cuda-rhel9-cross-linux-sbsa.repo
    dnf -y install cuda-cross-sbsa-11-8
  fi
else
  echo "Skipping CUDA installation"
fi

dnf -y install epel-release

# This is a fix for an bug where config-manager tries to modify a repo file with the incorrect name
cp /etc/yum.repos.d/rocky-devel.repo /etc/yum.repos.d/Rocky-Devel.repo
dnf config-manager --enable crb

# Needed for LibreOffice to install base components on aarch64
sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/Rocky-Devel.repo
wget https://github.com/jgm/pandoc/releases/download/3.1.9/pandoc-3.1.9-linux-"$ARCH".tar.gz
tar xvzf pandoc-3.1.9-linux-"$ARCH".tar.gz --strip-components 1 -C '/usr/local'
rm -rf pandoc-3.1.9-linux-"$ARCH".tar.gz
dnf -y install libreoffice-writer libreoffice-base libreoffice-impress libreoffice-draw libreoffice-math libreoffice-core
sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/Rocky-Devel.repo

# General cleanup
rm -rf /var/cache/yum/*
rm -f /etc/yum.repos.d/Rocky-Devel.repo
dnf clean all
