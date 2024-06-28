#!/bin/bash

if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
  files=(
    "poppler-23.09.0-r0-aarch64.apk"
    "pandoc-3.1.8-r0-aarch64.apk"
    "nltk_data.tgz"
  )
else
  files=(
    "poppler-23.09.0-r0.apk"
    "pandoc-3.1.8-r0.apk"
    "libreoffice-7.6.5-r0.apk"
    "nltk_data.tgz"
  )
fi

directory="docker-packages"
mkdir -p "${directory}"

for file in "${files[@]}"; do
  echo "Downloading ${file}"
  wget "https://utic-public-cf.s3.amazonaws.com/$file" -P "$directory"
done

# NOTE(robinson) - renames the aarch64 specific APKs to replace -aarch.apk with .apk
# so the apk add steps in the Dockerfile are unchanged between arm64 and amd64
if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
  OLD_EXT="-aarch64.apk"
  NEW_EXT=".apk"
  for FILE in "$directory"/*"$OLD_EXT"; do
    # shellcheck disable=SC2295
    BASE_NAME="${FILE%$OLD_EXT}"
    NEW_FILE="${BASE_NAME}${NEW_EXT}"
    mv "$FILE" "$NEW_FILE"
  done
fi

echo "Downloads complete."
