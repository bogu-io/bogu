#!/bin/bash
VERSION="0.0.5"
echo "Beginning bogu installation..."
echo "Move bogu to /usr/local/bin..."
mv bogu-${VERSION} /usr/local/bin/bogu
echo "Adding bogu to PATH..."
echo "export PATH=$PATH:/usr/local/bin/bogu/bin" >> $HOME/.zshrc
source $HOME/.zshrc
rm bogu-${VERSION}-darwin-arm64.zip
echo "Installation complete!"
/usr/local/bin/bogu/bin/bogu --version
