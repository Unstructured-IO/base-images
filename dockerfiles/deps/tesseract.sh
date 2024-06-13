#!/usr/bin/env bash

set -ex

if [ "$DOCKERFILE" != "ubi9.4" ]; then
  REPO_NAME="Rocky-Devel"
else
  REPO_NAME="redhat"
fi
sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/"$REPO_NAME".repo

dnf install -y opencv opencv* zlib zlib-devel perl-core clang libpng libpng-devel libtiff libtiff-devel libwebp libwebp-devel libjpeg libjpeg-devel libjpeg-turbo-devel git-core libtool pkgconfig xz
wget https://github.com/DanBloomberg/leptonica/releases/download/1.83.1/leptonica-1.83.1.tar.gz
tar -xzvf leptonica-1.83.1.tar.gz
cd leptonica-1.83.1 || exit
./configure && make && make install
cd ..
wget https://mirror.team-cymru.com/gnu/autoconf-archive/autoconf-archive-2017.09.28.tar.xz
tar -xvf autoconf-archive-2017.09.28.tar.xz
cd autoconf-archive-2017.09.28 || exit
./configure && make && make install
cp m4/* /usr/share/aclocal
cd ..
git clone --depth 1 --branch 5.3.3 https://github.com/tesseract-ocr/tesseract.git tesseract-ocr
cd tesseract-ocr || exit
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
./autogen.sh && ./configure --prefix=/usr/local --disable-shared --enable-static --with-extra-libraries=/usr/local/lib/ --with-extra-includes=/usr/local/lib/
make && make install
cd ..
git clone https://github.com/tesseract-ocr/tessdata.git
cp tessdata/*.traineddata /usr/local/share/tessdata
rm -rf /tesseract-ocr /tessdata /autoconf-archive-2017.09.28* /leptonica-1.83.1*
dnf -y remove opencv* perl-core clang libpng-devel libtiff-devel libwebp-devel libjpeg-devel libjpeg-turbo-devel git-core libtool xz

# General cleanup
rm -rf /var/cache/yum/*
rm -rf /tmp/*
dnf clean all

sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/"$REPO_NAME".repo
