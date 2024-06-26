#!/bin/bash

apk add tesseract git

git clone https://github.com/tesseract-ocr/tessdata.git
mkdir -p /usr/local/share/tessdata
cp tessdata/*.traineddata /usr/local/share/tessdata
rm -rf tessdata

git clone https://github.com/tesseract-ocr/tessconfigs
cp -r tessconfigs/configs /usr/local/share/tessdata
cp -r tessconfigs/tessconfigs /usr/local/share/tessdata
rm -rf tessconfigs

apk del git
