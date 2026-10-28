#!/bin/sh
set -eux

PRODUCT="$1"
VERSION="$2"

apk add --update --virtual .deps --no-cache gnupg curl unzip wget

cd /tmp

# Download binaries and verification assets
wget "https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_linux_amd64.zip"
wget "https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS"
wget "https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig"

# Import HashiCorp's public key and verify the SHA256SUMS file
wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import
gpg --verify "${PRODUCT}_${VERSION}_SHA256SUMS.sig" "${PRODUCT}_${VERSION}_SHA256SUMS"

# Validate the binary hash
grep "${PRODUCT}_${VERSION}_linux_amd64.zip" "${PRODUCT}_${VERSION}_SHA256SUMS" | sha256sum -c -

# Unzip and move binary to /usr/local/bin
unzip -q "${PRODUCT}_${VERSION}_linux_amd64.zip" -d /tmp
mv "/tmp/${PRODUCT}" /usr/local/bin/${PRODUCT}
chmod +x /usr/local/bin/${PRODUCT}

# Clean up
rm -f "${PRODUCT}_${VERSION}_linux_amd64.zip" \
      "${PRODUCT}_${VERSION}_SHA256SUMS" \
      "${PRODUCT}_${VERSION}_SHA256SUMS.sig"

apk del .deps
