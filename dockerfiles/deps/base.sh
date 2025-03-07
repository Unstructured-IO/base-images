#!/usr/bin/env bash

set -ex

GPU_ENABLED=${GPU_ENABLED:-"true"}
PANDOC_VERSION=${PANDOC_VERSION:-"3.1.9"}
LIBREOFFICE_VERSION="25.2.1"

echo "GPU enabled: $GPU_ENABLED"

dnf -y update && dnf -y upgrade

if [ "$DOCKERFILE" != "ubi9.4" ]; then
  dnf -y install epel-release
  REPO_NAME="Rocky-Devel"
  dnf -y install poppler-utils xz-devel wget tar make which mailcap dnf-plugins-core compat-openssl11
elif [ "$DOCKERFILE" == "ubi9.4" ]; then
  echo "UBI 9.4 build path"
  dnf -y install poppler-utils xz-devel wget tar make which mailcap dnf-plugins-core
else
  dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
  REPO_NAME="redhat"
  dnf -y install poppler-utils xz-devel wget tar make which mailcap dnf-plugins-core compat-openssl11
fi

ARCH=$(uname -m)

# Only install CUDA if GPU enabled
if [[ "$GPU_ENABLED" == "true" ]]; then
  echo "Installing CUDA dependencies"
  if [[ "$ARCH" == "x86_64" ]] || [[ "$ARCH" == "amd64" ]]; then
    dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo
    dnf -y install nvidia-driver nvidia-settings cuda-toolkit
  else
    dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/cross-linux-sbsa/cuda-rhel9-cross-linux-sbsa.repo
    dnf -y install cuda-cross-sbsa-11-8
  fi
else
  echo "Skipping CUDA installation"
fi

if [ "$DOCKERFILE" != "ubi9.4" ]; then
  cp /etc/yum.repos.d/rocky-devel.repo /etc/yum.repos.d/"$REPO_NAME".repo
  dnf config-manager --enable crb
else
  echo "UBI 9.4: Not enabling extra repos in final stage (using standard UBI repos)"
  #subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
  dnf config-manager --enable ubi-8-appstream-rpms
fi

# Needed for LibreOffice to install base components on aarch64
if [ "$ARCH" == "aarch64" ]; then
  PANDOC_ARCH="arm64"
else
  PANDOC_ARCH="amd64"
fi
pandoc_filename=pandoc-"$PANDOC_VERSION"-linux-"$PANDOC_ARCH".tar.gz
pandoc_url=https://github.com/jgm/pandoc/releases/download/"$PANDOC_VERSION"/"$pandoc_filename"
if [ -n "${REPO_NAME:-}" ]; then
  sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/"$REPO_NAME".repo
fi
wget "$pandoc_url"
tar xvzf "$pandoc_filename" --strip-components 1 -C '/usr/local'
rm -rf "$pandoc_filename"

if [ "$DOCKERFILE_TYPE" == "ubi9.4" ]; then
  echo "Installing LibreOffice for UBI 9.4 using Georgetown University mirror"

  # Install dependencies
  dnf -y install cairo cups-libs libSM libICE

  if [ "$ARCH" = "x86_64" ]; then
    # Use Georgetown University mirror for LibreOffice RPMs
    GEORGETOWN_MIRROR="https://mirror1.cs-georgetown.net/tdf/libreoffice/stable/${LIBREOFFICE_VERSION}/rpm/x86_64"
    echo "Using mirror: $GEORGETOWN_MIRROR"

    # Create a directory for the RPMs
    mkdir -p /tmp/libreoffice_rpms
    cd /tmp/libreoffice_rpms || exit 1

    # Download the main LibreOffice RPM package
    wget "$GEORGETOWN_MIRROR/LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_rpm.tar.gz"

    # Extract and install
    tar -xzf "LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_rpm.tar.gz"
    cd "LibreOffice_${LIBREOFFICE_VERSION}"*/RPMS || exit 1

    # Install the RPMs
    dnf -y localinstall ./*.rpm

    # Clean up
    cd / || exit 1
    rm -rf /tmp/libreoffice_rpms

  elif [ "$ARCH" = "aarch64" ]; then
    # Use Georgetown University mirror for LibreOffice ARM64 RPMs if available
    GEORGETOWN_MIRROR="https://mirror1.cs-georgetown.net/tdf/libreoffice/stable/${LIBREOFFICE_VERSION}/rpm/aarch64"
    echo "Using mirror: $GEORGETOWN_MIRROR"

    # Create a directory for the RPMs
    mkdir -p /tmp/libreoffice_rpms
    cd /tmp/libreoffice_rpms || exit 1

    # Download the main LibreOffice RPM package for ARM64
    wget "$GEORGETOWN_MIRROR/LibreOffice_${LIBREOFFICE_VERSION}_Linux_aarch64_rpm.tar.gz"

    # Extract and install
    tar -xzf "LibreOffice_${LIBREOFFICE_VERSION}_Linux_aarch64_rpm.tar.gz"
    cd "LibreOffice_${LIBREOFFICE_VERSION}"*/RPMS || exit 1

    # Install the RPMs
    dnf -y localinstall ./*.rpm

    # Clean up
    cd / || exit 1
    rm -rf /tmp/libreoffice_rpms
  fi
else
  dnf -y install libreoffice-writer libreoffice-base libreoffice-impress libreoffice-draw libreoffice-math libreoffice-core
fi

if [ -n "${REPO_NAME:-}" ]; then
  sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/"$REPO_NAME".repo
fi
# General cleanup
if [ "$DOCKERFILE_TYPE" != "ubi9.4" ]; then
  rm -rf /var/cache/yum/*
  rm -f /etc/yum.repos.d/"$REPO_NAME".repo
  dnf clean all
fi
