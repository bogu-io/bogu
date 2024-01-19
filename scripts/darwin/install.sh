#!/bin/bash
VERSION="0.0.3"
echo "Beginning bogu installation..."
echo "Move bogu to /usr/local..."
sudo mv bogu /usr/local
echo "Adding bogu to PATH..."
echo "export PATH=$PATH:/usr/local/bogu" >> $HOME/.profile
source $HOME/.profile
rm bogu-${VERSION}-darwin-arm64.zip
echo "Installation complete!"
bogu --version
