#!/bin/bash

function config(){

if [ -d $PWD/dist/tooldev ]; then
	rm -R $PWD/dist/tooldev
	config
else
	cp -R $PWD/tooldev $PWD/dist
	AUX=$PWD && cd dist && tar -czf tooldev-v0.0.1.tar.gz tooldev && cd $AUX
	rm -R $PWD/dist/tooldev
fi

cp $PWD/tooldev/run-tooldev $PWD/dist
sudo cp $PWD/dist/run-tooldev /bin/ && sudo chmod a+x /bin/run-tooldev

sudo cp -R $PWD/tooldev /usr/share

}

config 



