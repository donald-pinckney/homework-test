#!/bin/bash

# Install Swift Dependencies
# sudo apt-get -yq install clang libicu-dev

# Install Swift
mkdir ~/bin
swiftURL="https://swift.org/builds/swift-3.0-preview-4/ubuntu1510/swift-3.0-PREVIEW-4/swift-3.0-PREVIEW-4-ubuntu15.10.tar.gz"
swiftFile=$(basename $swiftURL)
swiftDir="${swiftFile/.tar.gz/}"
wget -nv $swiftURL
tar xzf $swiftFile --directory ~/bin
mv ~/bin/$swiftDir ~/bin/swift
rm -f $swiftFile
