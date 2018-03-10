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

DIR_SASCHA=$HOME'/git/sascha'
URL_GIT_BASE='https://github.com/'
URL_GIT_MASTER='https://github.com/SaschaNutric/'
USER_NAME=''

function main(){
clear

while true; do
		case "$@" in
			"update-system" )
		 		upgradeSystem
		 	break;;
			"init" ) initSascha
			break;;
			"--help" ) help
			break;;
			* ) help 
			 break;;
		esac
	done				
}

function help(){
	echo -e $amarillo"ejecutar el script" $azul" sascha "$amarillo"con argumento"$rescolor
	echo "[ --help ]"
	echo "[ init ]"
}

function initSascha(){

	if ! [ -d $HOME/git ]; then
		mkdir $HOME'/git'
		echo -e $verde"Creado el Repositorio Local Git en: "$amarillo$HOME"/git"$rescolor
		initSascha
	else
		if ! [ -d $DIR_SASCHA ] ; then
			mkdir $DIR_SASCHA
			echo -e $verde"Creado el Directorio Desarrollo Sascha en: "$amarillo$DIR_SASCHA$rescolor
			initSascha
		else
			echo -e $verde"Verificando Estado del directorio del proyecto"$magenta" Sascha"$rescolor
			echo -e $verde"Verificando Repositorio github"$rescolor
			echo -n "username github: "
			read USER_NAME
			cloneApiSascha
			cloneAppSaschaWeb
			cloneAppSaschaWebDesktop
			cloneAppSaschaMovil
		fi
	fi
}

function cloneApiSascha(){
	REPO='/api-sascha'
	AUX_PWD=$PWD
	cd $DIR_SASCHA
	if ! [ -d $DIR_SASCHA$REPO ]; then
		git clone $URL_GIT_BASE$USER_NAME$REPO'.git'
		if [ -d api-sascha ] ; then
			echo -e $verde"HECHO..."
		else
			echo -e $rojo"Falla al clonar el repositorio no Existente "$rescolor
			echo -e $magenta"Ir a:"$azul$URL_GIT_MASTER$verde" y "$rescolor"Fork "$magenta$REPO$rescolor
		fi
	else
		if [ -d $DIR_SASCHA$REPO'/.git' ]; then
			echo -e $verde"Repositorio Existente"$rescolor
		else
			echo -e $verde"Ubicar el directorio: "$rojo"cd "$azul$DIR_SASCHA$REPO$rescolor
			echo -e $verde"Iniciar Un nuevo repositorio con: "$rojo"git "$azul"init"$rescolor
		fi
	fi	
	cd $AUX_PWD
}

function cloneAppSaschaWeb(){
	REPO='/app-sascha-web'
	AUX_PWD=$PWD
	cd $DIR_SASCHA
	if ! [ -d $DIR_SASCHA$REPO ]; then
		git clone $URL_GIT_BASE$USER_NAME$REPO'.git' 
		if [ -d app-sascha-web ] ; then
			echo -e $verde"HECHO..."
		else
			echo -e $rojo"Falla al clonar el repositorio no Existente "$rescolor
			echo -e $magenta"Ir a:"$azul$URL_GIT_MASTER$verde" y "$rescolor"Fork "$magenta$REPO$rescolor
		fi
	else
		if [ -d $DIR_SASCHA$REPO'/.git' ]; then
			echo -e $verde"Repositorio Existente"$rescolor
		else
			echo -e $verde"Ubicar el directorio: "$rojo"cd "$azul$DIR_SASCHA$REPO$rescolor
			echo -e $verde"Iniciar Un nuevo repositorio con: "$rojo"git "$azul"init"$rescolor
		fi
	fi	
	cd $AUX_PWD
}

function cloneAppSaschaWebDesktop(){
	REPO='/app-sascha-web-desktop'
	AUX_PWD=$PWD
	cd $DIR_SASCHA
	if ! [ -d $DIR_SASCHA$REPO ]; then
		git clone $URL_GIT_BASE$USER_NAME$REPO'.git'
		if [ -d app-sascha-web-desktop] ; then
			echo -e $verde"HECHO..."
		else
			echo -e $rojo"Falla al clonar el repositorio no Existente "$rescolor
			echo -e $magenta"Ir a:"$azul$URL_GIT_MASTER$verde" y "$rescolor"Fork "$magenta$REPO$rescolor
		fi
	else
		if [ -d $DIR_SASCHA$REPO'/.git' ]; then
			echo -e $verde"Repositorio Existente"$rescolor
		else
			echo -e $verde"Ubicar el directorio: "$rojo"cd "$azul$DIR_SASCHA$REPO$rescolor
			echo -e $verde"Iniciar Un nuevo repositorio con: "$rojo"git "$azul"init"$rescolor
		fi
	fi	
	cd $AUX_PWD
}

function cloneAppSaschaMovil(){
	REPO='/app-sascha-movil'
	AUX_PWD=$PWD
	cd $DIR_SASCHA
	if ! [ -d $DIR_SASCHA$REPO ]; then
		git clone $URL_GIT_BASE$USER_NAME$REPO'.git'
		if [ -d app-sascha-movil ] ; then
			echo -e $verde"HECHO..."
		else
			echo -e $rojo"Falla al clonar el repositorio no Existente "$rescolor
			echo -e $magenta"Ir a:"$azul$URL_GIT_MASTER$verde" y "$rescolor"Fork "$magenta$REPO$rescolor
		fi
	else
		if [ -d $DIR_SASCHA$REPO'/.git' ]; then
			echo -e $verde"Repositorio Existente"$rescolor
		else
			echo -e $verde"Ubicar el directorio: "$rojo"cd "$azul$DIR_SASCHA$REPO$rescolor
			echo -e $verde"Iniciar Un nuevo repositorio con: "$rojo"git "$azul"init"$rescolor
		fi
	fi	
	cd $AUX_PWD
}

main "$@"