#!/bin/bash
VERSION="0.0.4"
echo "Beginning bogu installation..."
echo "Move bogu to /usr/local..."
mv bogu-${VERSION} /usr/local/bogu
echo "Adding bogu to PATH..."
echo "export PATH=$PATH:/usr/local/bogu/bin" >> $HOME/.zshrc
source $HOME/.zshrc
rm bogu-${VERSION}-darwin-arm64.zip
echo "Installation complete!"
/usr/local/bogu/bin/bogu --version
