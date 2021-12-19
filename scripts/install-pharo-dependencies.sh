#!/bin/bash

if [ -z "$VM_RELEASE" ]
then
	VM_RELEASE=201901172323
fi
if [ -z "$VM_FAMILY" ]
then
	VM_FAMILY=squeak
fi

VERSION=linux64x64


wget -O cogspur.tgz "https://github.com/OpenSmalltalk/opensmalltalk-vm/releases/download/${VM_RELEASE}/${VM_FAMILY}.cog.spur_${VERSION}_${VM_RELEASE}.tar.gz"
tar -zxvf cogspur.tgz
rm cogspur.tgz
sudo cp "./sqcogspur64linuxht/lib/squeak/5.0-${VM_RELEASE}/SqueakFFIPrims.so" /usr/local/lib/SqueakFFIPrims.so
