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

DIR_SASCHA=$HOME'/git/sascha/'
URL_GIT_BASE='https://github.com/'
URL_GIT_MASTER='https://github.com/SaschaNutric/'
USER_NAME=''

function main(){
clear
config
while true; do
		case "$@" in
			"update-system" )
		 		upgradeSystem
		 	break;;
			"init" ) initSascha
			break;;
			"pull" ) pullSascha
			break;;
			"push" ) pushSascha
			break;;
			"--help" ) help
			break;;
			* ) help 
			 break;;
		esac
	done				
}

function config(){
	echo -e $verde"Agregar tu Repositorio de Trabajo github"$rescolor
	echo -n "username github: "
	read USER_NAME
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
			echo -e $verde"Tu directorio de Trabajo es:"$magenta"$DIR_SASCHA"$rescolor
			cloneSascha		
		fi
	fi
}

function cloneSascha(){
	cloneApiSascha
	cloneAppSaschaWeb
	cloneAppSaschaWebDesktop
	cloneAppSaschaMovil
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

function pullSascha(){
	cloneSascha
	actualizarPadre
	addMenu
}

function actualizarPadre(){

	while true; do	
		echo -e $amarillo"Actualizar Cambios desde Repositorio Padre"$magenta"$URL_GIT_MASTER"$rescolor
		echo "                                                      "
		echo -e "      "$verde"1)"$rescolor" api-sascha             "
		echo -e "      "$verde"2)"$rescolor" app-sascha-web         "
		echo -e "      "$verde"3)"$rescolor" app-sascha-web-desktop "
		echo -e "      "$verde"4)"$rescolor" app-sascha-movil       "
		echo "                                        "
		echo -n "      #> "
		read yn
		echo ""
		case $yn in
			1 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'api-sascha' 
				bash -ic "git remote add upstream "$URL_GIT_BASE$USER_NAME"/api-sascha.git"
				padreGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			2 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'app-sascha-web' 
				bash -ic "git remote add upstream "$URL_GIT_BASE$USER_NAME"/app-sascha-web.git"
				padreGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			3 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'app-sascha-web-desktop' 
				bash -ic "git remote add upstream "$URL_GIT_BASE$USER_NAME"/app-sascha-web-desktop.git"
				padreGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			4 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'app-sascha-movil' 
				bash -ic "git remote add upstream "$URL_GIT_BASE$USER_NAME"/app-sascha-movil.git"
				padreGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			* ) clear;
		  esac
	done
	sleep 0.1
}

function padreGit(){
	git fetch upstream
	sudo chmod -r a+r+w '.git'
	git merge upstream/master
}

function addMenu(){
	while true; do	
		echo -e $amarillo"Agregar Cambios"
		echo "                                                      "
		echo -e "      "$verde"1)"$rescolor" api-sascha             "
		echo -e "      "$verde"2)"$rescolor" app-sascha-web         "
		echo -e "      "$verde"3)"$rescolor" app-sascha-web-desktop "
		echo -e "      "$verde"4)"$rescolor" app-sascha-movil       "
		echo -e "      "$verde"5)"$rescolor" Menu: COMMIT          "
		echo "                                        "
		echo -n "      #> "
		read yn
		echo ""
		case $yn in
			1 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'api-sascha' 
				addGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			2 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'app-sascha-web' 
				addGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			3 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'app-sascha-web-desktop' 
				addGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			4 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'app-sascha-movil' 
				addGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			5 ) commitMenu
			* ) clear;
		  esac
	done
	sleep 0.1
}

function commitMenu(){
while true; do	
		echo -e $amarillo"Crear Commit "
		echo "                                                      "
		echo -e "      "$verde"1)"$rescolor" api-sascha             "
		echo -e "      "$verde"2)"$rescolor" app-sascha-web         "
		echo -e "      "$verde"3)"$rescolor" app-sascha-web-desktop "
		echo -e "      "$verde"4)"$rescolor" app-sascha-movil       "
		echo -e "      "$verde"5)"$rescolor" Menu: PUSH            "
		echo "                                        "
		echo -n "      #> "
		read yn
		echo ""
		case $yn in
			1 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'api-sascha' 
				commitGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			2 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'app-sascha-web' 
				commitGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			3 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'app-sascha-web-desktop' 
				commitGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			4 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'app-sascha-movil' 
				commitGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			5 ) pushMenu
			* ) clear;
		  esac
	done
	sleep 0.1	
}

function pushMenu(){
while true; do	
		echo -e $amarillo"Crear Push "
		echo "                                                      "
		echo -e "      "$verde"1)"$rescolor" api-sascha             "
		echo -e "      "$verde"2)"$rescolor" app-sascha-web         "
		echo -e "      "$verde"3)"$rescolor" app-sascha-web-desktop "
		echo -e "      "$verde"4)"$rescolor" app-sascha-movil       "
		echo "                                        "
		echo -n "      #> "
		read yn
		echo ""
		case $yn in
			1 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'api-sascha' 
				pushGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			2 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'app-sascha-web' 
				pushGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			3 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'app-sascha-web-desktop' 
				pushGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			4 ) 
				AUX_PWD=PWD
				cd $DIR_SASCHA'app-sascha-movil' 
				pushGit
				cd AUX_PWD
				echo -e $verde"HECHO..."$rescolor
				break ;;
			* ) clear;
		  esac
	done
	sleep 0.1	
}

function pushGit(){
	git checkout origin 
	echo -n "git push [ remote | origin | master ] #> "
	read remote
	git push $remote
}

function commitGit(){
	git status 
	echo -n "git commit -m [ mensage ] #> "
	read mensage
	git commit -m "$mensage"
}

function addGit(){
	git status 
	while true; do	
		echo -n "git add [ cambio | . ] #> "
		read cambio
		git add $cambio
		echo -n "Continuar  [ Y/n ] #> "
		read CND
		if "$CND"="Y" ; then
			addGit
		fi
	done
}

function pushSascha(){
	cloneSascha
	addMenu
}
main "$@"