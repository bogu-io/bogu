#!/usr/bin/bash
VERSION="0.0.5"
echo "Beginning bogu installation..."
echo "Move bogu to /usr/local/bin..."
mv bogu-${VERSION} /usr/local/bin/bogu
echo "Adding bogu to PATH..."
echo "export PATH=$PATH:/usr/local/bin/bogu/bin" >> $HOME/.profile
source $HOME/.profile
rm bogu-${VERSION}-linux-x64.zip
echo "Installation complete!"
/usr/local/bin/bogu/bin/bogu --version
