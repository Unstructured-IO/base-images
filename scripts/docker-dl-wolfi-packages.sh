#!/bin/bash

if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
  files=(
    "openjpeg-2.5.0-r0-aarch64.apk"
    "poppler-23.09.0-r0-aarch64.apk"
    "leptonica-1.83.0-r0-aarch64.apk"
    "pandoc-3.1.8-r0-aarch64.apk"
    "tesseract-5.3.2-r0-aarch64.apk"
    "nltk_data.tgz"
  )
else
  files=(
    "libreoffice-7.6.5-r0.apk"
    "openjpeg-2.5.0-r0.apk"
    "poppler-23.09.0-r0.apk"
    "leptonica-1.83.0-r0.apk"
    "pandoc-3.1.8-r0.apk"
    "tesseract-5.3.2-r0.apk"
    "nltk_data.tgz"
  )
fi

directory="docker-packages"
mkdir -p "${directory}"

for file in "${files[@]}"; do
  echo "Downloading ${file}"
  wget "https://utic-public-cf.s3.amazonaws.com/$file" -P "$directory"
done

if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
  OLD_EXT="-aarch64.apk"
  NEW_EXT=".apk"
  for FILE in "$directory"/*"$OLD_EXT"; do
    BASE_NAME="${FILE%$OLD_EXT}"
    NEW_FILE="${BASE_NAME}${NEW_EXT}"
    mv "$FILE" "$NEW_FILE"
  done
fi

echo "Downloads complete."
