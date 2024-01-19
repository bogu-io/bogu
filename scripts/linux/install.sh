#!/usr/bin/bash
VERSION="0.0.4"
echo "Beginning bogu installation..."
echo "Move bogu to /usr/local..."
mv bogu-${VERSION} /usr/local/bogu
echo "Adding bogu to PATH..."
echo "export PATH=$PATH:/usr/local/bogu/bin" >> $HOME/.profile
source $HOME/.profile
rm bogu-${VERSION}-linux-x64.zip
echo "Installation complete!"
/usr/local/bogu/bin/bogu --version
