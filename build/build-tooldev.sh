#!/bin/bash

#Colores
blanco="\033[1;37m"
gris="\033[0;37m"
magenta="\033[0;35m"
rojo="\033[1;31m"
verde="\033[1;32m"
amarillo="\033[1;33m"
azul="\033[1;34m"
rescolor="\e[0m"

delay=2.5

function config(){

echo -e $verde"Iniciando construccion del Script"$rescolor
sleep $delay

if [ -d $PWD/dist/tooldev ]; then
	echo -e $rojo"Removiendo directorio de distribucion"$rescolor
	sleep $delay
	rm -R $PWD/dist/tooldev
	config
else
	echo -e $amarillo"Copiando directorio temporal tooldev en el directorio de distribucion"$rescolor
	sleep $delay
	cp -R $PWD/tooldev $PWD/dist
	AUX=$PWD && cd dist && tar -czf tooldev-v0.0.1.tar.gz tooldev && cd $AUX
	echo -e $amarillo"Generado Comprimido .tar.gz en el directorio de distribucion"$rescolor
	sleep $delay
	rm -R $PWD/dist/tooldev
	echo -e $amarillo"Limpiando archivo temporal"$rescolor
	sleep $delay
fi

echo -e $amarillo"Copiando enlazador del script en /bin"$rescolor
sleep $delay
cp $PWD/tooldev/run-tooldev $PWD/dist
sudo cp $PWD/dist/run-tooldev /bin/ && sudo chmod a+x /bin/run-tooldev

sudo cp -R $PWD/tooldev /usr/share

echo -e $verde"Construccion finalizada..."$rescolor
sleep $delay
echo "presione una tecla para continiar--> "
read d;
clear

}

config 



