#!/usr/bin/bash
VERSION="0.0.2"
echo "Beginning bogu installation..."
echo "Downloading bogu ${VERSION}..."
wget https://github.com/bogu-io/bogu/releases/download/${VERSION}/bogu-${VERSION}-linux-x64.zip
echo "Download complete."
echo "Unzipping bogu ${VERSION} to /usr/local..."
sudo unzip bogu-${VERSION}-linux-x64.zip -d /usr/local
echo "Unzip complete."
echo "Adding bogu to PATH..."
echo "export PATH=$PATH:/usr/local/bogu" >> $HOME/.profile
source $HOME/.profile
rm bogu-${VERSION}-linux-x64.zip
bogu --version
