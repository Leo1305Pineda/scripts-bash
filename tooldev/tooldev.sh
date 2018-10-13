#!/bin/bash

###################################################
#                                                 #
	AUTOR='LEONARDO PINEDA'
	DEBUT=0 #  0-Desarrollo; 1-Distribucion
#                                                 #
###################################################

KEY_LICENSE_SUBLIMETEXT='----- BEGIN LICENSE -----
eldon
Single User License
EA7E-1122628
C0360740 20724B8A 30420C09 6D7E046F
3F5D5FBB 17EF95DA 2BA7BB27 CCB14947
27A316BE 8BCF4BC0 252FB8FF FD97DF71
B11A1DA9 F7119CA0 31984BB9 7D71700C
2C728BF8 B952E5F5 B941FF64 6D7979DA
B8EB32F8 8D415F8E F16FE657 A35381CC
290E2905 96E81236 63D2B06D E5F01A69
84174B79 7C467714 641A9013 94CA7162
------ END LICENSE ------'

DIR_LIB=$PWD/lib
NAME_SCRIPT='tooldev'

#Colores
blanco="\033[1;37m"
gris="\033[0;37m"
magenta="\033[0;35m"
rojo="\033[1;31m"
verde="\033[1;32m"
amarillo="\033[1;33m"
azul="\033[1;34m"
rescolor="\e[0m"

JAVA_HOME=$JAVA_HOME
DIR_TOMCAT='/usr/share/tomcat7'

# Si se cierra el script inesperadamente, ejecutar la funcion
trap exitmode SIGINT SIGHUP
function exitmode(){
	echo -e "Exit"
}

function main(){
clear
config
while true; do
		case "$@" in
			"update-system" )
		 		upgradeSystem
		 	break;;
		 	"update" )
		 		update
		 	break;;
			"install --all" ) 
				installgedit
				installGit
				installHeroku
	    		installPostgreSQL
	    		installpgAdmin3
	    	#	installWebStorm
		    	installSublimeText
		    #	installVisualStudioCode
		    	installNodeJs
			installIonic
			break;;
			"install gedit" ) installgedit
			break;;
			"install curl" ) installCurl
			break;;
			"install git" ) installGit
			break;;
			"install tomcat" ) installTomcat
			break;;
			"install apache" ) installApache
			break;;
			"install msql" ) installMsql
			break;;
			"install php" ) installPhp
			break;;
			"install jdk" ) installJdk
			break;;
			"install heroku" ) installHeroku
			break;;
			"install wordpress" ) installWordpress
			break;;
			"install laravel" ) installLaravel
			break;;
			"install composer" ) installComposer
			break;;
			"install node" ) installNodeJs
			break;;
			"install ionic" ) installIonic
			break;;
			"install postgresql" ) installPostgreSQL
			break;;
			"install pgadmin3" ) installpgAdmin3
			break;;
			"install webstorm" ) installWebStorm
			break;;
			"install visual-studio-code" ) installVisualStudioCode
			break;;
			"install sublime-text-installer" ) installSublimeText
			break;;
			"config variables" ) configVariableEntorno
			break;;
			"apache restart" ) apacheRestart
			break;;
			"update" ) update
			break;;
			"--help" ) help
			break;;
			* ) help 
			 break;;
		esac
	done				
		
}

function update(){
	echo -e $verde"Actualizando el Script "$NAME_SCRIPT$rescolor
	if [ -f /bin/run-$NAME_SCRIPT ]; then
		sudo rm /bin/run-$NAME_SCRIPT
	fi
	if [ -d /usr/share/$NAME_SCRIPT ]; then
		sudo rm -R /usr/share/$NAME_SCRIPT
	fi
	sudo curl -sL https://raw.githubusercontent.com/SaschaNutric/scripts-bash/master/dist/run-sascha -o /bin/sascha 
	sudo chmod a+x /bin/$NAME_SCRIPT 
	sudo $NAME_SCRIPT --help
	sleep 1
	echo -e $verde"Actualizado el Script "$NAME_SCRIPT$rescolor
	echo -e $verde"Ejecutar el script con: "$azul$NAME_SCRIPT$rescolor
}

function help(){
	echo "ejecutar el script "$NAME_SCRIPT" con argumento"
	echo -e $amarillo$NAME_SCRIPT $rescolor" [ opcion ]"$rescolor
	echo -e $magenta"   opcion:"$rescolor
	echo -e "	|	--help 			* Ayuda de "$NAME_SCRIPT$rescolor
	echo -e "	|	install 		* Instalacion de toda las herranientas"$rescolor
	echo -e "	|	update 			* Actualiza el script"$NAME_SCRIPT$rescolor
	echo -e $amarillo$NAME_SCRIPT" install "$rescolor"[ opcion ]"$rescolor
	echo -e $magenta"   opcion:"$rescolor
	echo -e "	|	gedit 			* Herranienta Gedit"$rescolor
	echo -e "	|	curl 			* Herranienta Curl"$rescolor
	echo -e "	|	tomcat 			* Herranienta Apache Tomcat 7"$rescolor
	echo -e "	|	jdk 			* Herranienta Java openjdk-8-jdk"$rescolor
	echo -e "	|	heroku 			* Herranienta Heroku"$rescolor
	echo -e "	|	apache 			* Herranienta Apache 2"$rescolor
	echo -e "	|	mysql 			* Herranienta MYSQL"$rescolor
	echo -e "	|	php 			* Herranienta Php5"$rescolor
	echo -e "	|	wordpress		* Herranienta Wordpress"$rescolor
	echo -e "	|	composer		* Herranienta Composer"$rescolor
	echo -e "	|	laravel			* Herranienta Laravel"$rescolor
	echo -e "	|	node 			* Herranienta Node"$rescolor
	echo -e "	|	ionic 			* Herranienta Ionic"$rescolor
	echo -e "	|	pgadmin3 		* Herranienta Pgadmin3"$rescolor
	echo -e "	|	postgresql 		* Herranienta PostgreSql"$rescolor
	echo -e "	|	webstorm 		* Herranienta WebStorm"$rescolor
	echo -e "	|	visual-studio-code 	* Herranienta VisualStudioCode"$rescolor
	echo -e "	|	sublime-text-installer 	* Herranienta SublimeText"$rescolor
	echo -e $amarillo$NAME_SCRIPT" config "$rescolor"[ opcion ]"$rescolor
	echo -e $magenta"   opcion:"$rescolor
	echo -e "	|	variables 		* Variables de Entorno"$rescolor
	echo -e $amarillo$NAME_SCRIPT" apache "$rescolor"[ opcion ]"$rescolor
	echo -e $magenta"   opcion:"$rescolor
	echo -e "	|	restart 		* Reiniciar Servidor Apache"$rescolor
	
}

function config(){

	if [ $DEBUT = 1 ] ; then
		echo "Modo 1-Distribucion"
	fi

	if [ $DEBUT = 0 ] ; then
		if [ -f $PWD/tooldev ] ; then
			echo -e $amarillo"Ubicate en el directorio del script:tooldev"$rescolor
			exit 1;
		else
			echo -e $amarillo"Iniciando script tooldev"$rescolor
		fi
	fi
}

function updateSystem(){
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG
	sudo apt-get update
	echo -e $verde"HECHO..."$rescolor
}

function upgradeSystem(){

	echo -e $verde"ESTAS A PUNTO DE APLICAR LA ACTUALIZACION DEL SISTEMA"$rescolor""
		while true; do
			echo -e $gris"Este proceso se demorara ( "$rojo"NO APAGAR EL EQUIPO"$rojo" )"
			echo -e $amarillo"Desea aplicar la actualizacion en el sistema"
			echo "                                    "
		echo -e "      "$verde"1)"$rescolor" SI       "
		echo -e "      "$verde"2)"$rescolor" NO       "
		echo -e "      "$verde"3)"$rescolor" CONTINUAR SIN APLICAR ACTUALIZACION"
		echo "                                        "
		echo -n "      #> "
		read yn
		echo ""
		case $yn in
			1 ) 
				echo -e $verde"Descargando PKG"$gris
				sudo apt-get update
				sudo apt-get upgrade
				echo -e $verde"HECHO..."$rescolor
				break ;;
			2 ) exit 1 ; break ;;  
			3 ) echo -e $verde"........>>>"; break ;;  
			* ) clear;
		  esac
	done
	sleep 0.1
}

function installIonic(){
	bash -ic "npm install -g ionic cordova"
}

function installNodeJs(){
	PKG='nodejs'
	VERSION='v8.9.4'
	if ! [ -d $HOME/.nvm ]; then
	    bash -ic "bash $PWD/lib/install_nvm.sh"
	    if ! [ -d $HOME'/.nvm/versions/node/'$VERSION ] ; then
	    	bash -ic "sudo bash $PWD/lib/install_nvm.sh"
	    fi
	    installNodeJs
	else	
		if ! [ -d $HOME'/.nvm/versions/node/'$VERSION ] ; then
	    	echo -e $verde"Instalando nueva Version node-"$VERSION"-linux-x64"$rescolor
	    	bash -ic "source $HOME/.bashrc && sudo nvm install $VERSION && sudo chmod a+x+w+r -R $HOME/.nvm && nvm ls "
	    	echo -e $verde"HECHO..."$rescolor
	    	echo -e $rojo"CERRAR Y ABRIR LA TERMINAL"$rescolor
		echo -n "Presione una tecla para continuar -->"
		read e;
	    else 
	    	echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
		fi
	fi
	sleep 0.1
}

function installSublimeText(){
PKG='sublime-text-installer'
echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo add-apt-repository ppa:webupd8team/sublime-text-3 -y && updateSystem
		sudo apt-get install $PKG -y 
		echo -e $amarillo"<-- AVISO -->"$rescolor
		echo -e $azul"INGRESAR KEY LICENSE"$rescolor
		echo -e $gris$KEY_LICENSE_SUBLIMETEXT$rescolor
		echo -e $verde"HECHO..."$rescolor	
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	sleep 0.1
}

function installPostgreSQL(){
	PKG='postgresql'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	sleep 0.1

}

function installpgAdmin3(){
	PKG='pgadmin3'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	sleep 0.1
}

function installgedit(){
	PKG='gedit'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	sleep 0.1
}

function installComposer(){
	PKG='composer'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	
		if [ $COMPOSER_HOME ]; then 
			echo "COMPOSER_HOME="$COMPOSER_HOME
		else
			sudo chmod 777 '/etc/environment'
			echo -e $azul"configurando variables entorno COMPOSER_HOME"$rescolor
			echo "$( cat '/etc/environment' | sed "1i export COMPOSER_HOME=$(echo $HOME)/.composer\nexport PATH=$(echo '$COMPOSER_HOME')/vendor/bin:$(echo '$PATH')\n" )">'/etc/environment'
			echo -e $verde"HECHO..."$rescolor	
			echo "COMPOSER_HOME="$COMPOSER_HOME
			source $HOME'/.bashrc'
		fi
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	sleep 0.1
}

function installLaravel(){
	installComposer	
	echo -e $verde"Instalando laravel"$rescolor
	if [ $COMPOSER_HOME ]; then 
		echo "COMPOSER_HOME="$COMPOSER_HOME
	else
		sudo chmod 777 '/etc/environment'
		echo -e $azul"configurando variables entorno COMPOSER_HOME"$rescolor
		echo "$( cat '/etc/environment' | sed "1i export COMPOSER_HOME=$(echo $HOME)/.composer\nexport PATH=$(echo '$COMPOSER_HOME')/vendor/bin:$(echo '$PATH')\n" )">'/etc/environment'
		echo -e $verde"HECHO..."$rescolor	
		source $HOME'/.bashrc'
	fi

	if ! [ -f $COMPOSER_HOME'/bin/laravel' ]; then
		echo -e $verde"composer global require laravel/installer=~1.1"$rescolor
		sudo composer global require 'laravel/installer=~1.1'
		echo -e $verde"HECHO..."$rescolor	
		sudo chown -R $USER:$USER $HOME/.composer
		sudo chmod 777 -R $HOME/.composer

		PKG='php7.0-zip'
		echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

		if ! dpkg -l $PKG  &> /dev/null ;then
			echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
			echo -e $verde"Instalando $PKG"$rescolor
			sudo apt-get install $PKG -y 
			echo -e $verde"HECHO..."$rescolor	
		else
			echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
		fi
		sleep 0.05

		PKG='php7.0-xml'
		echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

		if ! dpkg -l $PKG  &> /dev/null ;then

			echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
			echo -e $verde"Instalando $PKG"$rescolor
			sudo apt-get install $PKG -y 
			echo -e $verde"HECHO..."$rescolor	
		else
			echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
		fi
		sleep 0.05
		yesLaravel
	else			
		yesLaravel
	fi
}


function yesLaravel(){
	echo -e $verde"HECHO..."$rescolor
	echo -e $verde"Ya puedes crear tu primer projecto laravel con: "$rescolor 
	echo
	echo -e $azul"composer create-project --prefer-dist laravel/laravel blog \"5.5.*\""$rescolor
	echo
	echo "O Usear"
	echo
	echo "laravel new tu_projecto"
	echo
	echo "cd tu_projecto"
	echo "compose install"
	echo "npm install"
	echo "Iniciar el servidor con php artisan server"
	echo
	echo -e "laravel"$verde" Esta Instalado?................SI"$rescolor""
}

function installCurl(){
	PKG='curl'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	sleep 0.1
}

function installHeroku(){
	PKG='heroku'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	sleep 0.1
}

function installGit(){
	PKG='git'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	sleep 0.1
}

function installMsql(){
	PKG='mysql-server'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor
		echo "Listo para la configuracion"
		echo -n "Ingrese la contrasena de mysql >"
		read password
		mysql -u root --password=$password -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD($( echo "'"$password"'"));"
		echo -e $verde"HECHO..."$rescolor
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi

	PKG='libapache2-mod-auth-mysql'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi


	sleep 0.1
}


function installJdk(){
	PKG='openjdk-8-jdk'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		echo -e $amarillo"Buscando repositorio disponibles para el jdk"$rescolor
		sudo apt-cache search jdk
		sudo add-apt-repository ppa:openjdk-r/ppa  # only Ubuntu 17.4 and earlier
		sudo apt-get update
		sudo apt-get install $PKG -y 
		sudo apt-get install openjdk-8-source #this is optional, the jdk source code
		javac -version
		#sudo update-alternatives --config java
		installJdk
		echo -e $verde"HECHO..."$rescolor	
	else
		if [ $JAVA_HOME ]; then 
			echo -e "JAVA_HOME="$gris$JAVA_HOME$rescolor
		else
			echo -e $azul"configurando variables entorno JAVA_HOME"$rescolor
			echo "$( cat '/etc/environment' | sed "1i export JAVA_HOME='/usr/lib/jvm/java-8-oracle'\nexport PATH=$(echo '$JAVA_HOME')/bin:$(echo '$PATH')\n" )">'/etc/environment'		
			echo -e $verde"HECHO..."$rescolor	
		fi
		if [ $JRE_HOME ]; then 
			echo -e "JRE_HOME="$gris$JRE_HOME$rescolor
		else
			echo -e $azul"configurando variables entorno JRE_HOME"$rescolor
			echo "$( cat '/etc/environment' | sed "1i export JRE_HOME='/usr/lib/jvm/java-8-oracle/jre'\nexport PATH=$(echo '$JRE_HOME')/bin:$(echo '$PATH')\n" )">'/etc/environment'
			echo -e $verde"HECHO..."$rescolor	
		fi
		source '/etc/environment'
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	sleep 0.1	
}

function configVariableEntorno(){
	echo -e $version"Configurando variable de entorno"$rescolor
	echo 
	echo "Estas a punto de configurar tus variables de entorno,"
	echo "ver como existe el fichero /etc/environment y ocupa 0 bytes," 
	echo "pero al existir,"
	echo "significa que el sistema lo procesará al inicio,"
	echo "por lo tanto si lo editamos y situamos las variables de entorno allí," 
	echo "serán procesadas."
	echo
	echo "Esta es la forma más limpia de configurar nuestras variables de entorno permanentes a nivel de equipo,"
	echo "ya que la definición de las mismas quedará separada del resto de configuración 
	definida en los scripts de inicio."
	echo 
	echo "Dicho esto se abrira el editor de texto Gedit para editar estas variables"
	installGit
	echo -e $verde"Abriendo Gedit"$rescolor
	JDK='/usr/lib/jvm/java-8-oracle'
	echo -e $gris"Agregar al archivo "$azul"/etc/environment"$gris" las siguientes lineas "$rescolor
	if [ -d  $JDK ]; then
		echo -e $magenta"VARIABLES PARA JAVA"$rescolor
		echo
		echo -e $rojo"export "$rescolor"JAVA_HOME="$gris$JDK$rescolor
		echo -e $rojo"export "$rescolor"PATH="$amarillo"$"$rescolor"PATH"$azul":"$amarillo"$"$rescolor'JAVA_HOME'$gris'/bin'$rescolor
		echo
		echo -e $rojo"export "$rescolor"JRE_HOME="$gris$JDK"/jre"$rescolor
		echo -e $rojo"export "$rescolor"PATH="$amarillo"$"$rescolor"PATH"$azul":"$amarillo"$"$rescolor'JRE_HOME'$gris'/bin'$rescolor
		echo

	fi
	echo -e 
	sudo gedit /etc/environment && source /etc/environment
}

function installApache(){
	PKG='apache2'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	
		echo -e $rojo"Configurar elpuerto a 8080"
		echo "Editar el puerto en /etc/apache2/ports.conf"
		sudo gedit '/etc/apache2/ports.conf'
		echo -e $verde"HECHO..."$rescolor	
		installApache
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	echo -e $verde"Presione ctrl+click en el link: "$gris"http://localhost:8080"$rescolor
	sleep 0.1
}

function installPhp(){
	installApache

	PKG='php7.0'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		sudo aptitude purge `dpkg -l | grep php| awk '{print $2}' |tr "\n" " "`
		sudo add-apt-repository ppa:ondrej/php
		sudo apt-get update
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	

		PKG='php7.0-mcrypt'
		echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG

	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi

	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi

	PKG='php7.0-mysql'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG
	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi

	PKG='php7.0-mbstring'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG
	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor	
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi

	PKG='phpmyadmin'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG
	if ! dpkg -l $PKG  &> /dev/null ;then
		echo -e "\e[1;31m$PKG No Esta Instalado"$rescolor""
		echo -e $verde"Instalando $PKG"$rescolor
		sudo apt-get install $PKG -y 
		echo -e $verde"HECHO..."$rescolor
		echo "$( cat '/etc/php/7.0/apache2/php.ini' | sed "862i extension=msql.so \n" )">'/etc/php/7.0/apache2/php.ini'
		echo "$( cat '/etc/apache2/apache2.conf' | sed "220i Include /etc/phpmyadmin/apache.conf \n" )">'/etc/apache2/apache2.conf'
		apacheRestart
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor
	fi

	sudo php -v

	apacheRestart

	echo -e $verde"Listo para probar php en el servidor apache"$rescolor
	echo "Creando testphp.php en el directrio /var/www/html"
	echo "Escribiendo <?php phpinfo(); ?>"
	echo "<?php phpinfo(); ?>">'/var/www/html/test.php'
	echo -e $verde"HECHO..."$rescolor	
	echo 
	echo -e $verde"Presione ctrl+click en el link: "$gris"http://localhost:8080/test.php"$rescolor
	echo
	sleep 0.1
}

function apacheRestart(){
	echo -e $amarillo"Reiniciando Servidor Apache"
	sudo /etc/init.d/apache2 restart
	echo -e $verde"HECHO..."$rescolor	
}

function installWordpress(){
	echo -e $azul"Pagina oficial de descarga"$gris": "$amarillo"https://es.wordpress.org/download/"$rescolor

	PKG='wordpress'
	RES='wordpress'
	LIB='wordpress-4.9.7-es_ES.tar.gz'
	DIR_LIB='/opt'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG
	
	if ! [ -d /var/www/html/$RES ]; then
		if ! [ -d $DIR_LIB/$RES ]; then
			if ! [ -f $DIR_LIB/$LIB ]; then
				echo -e $rojo$LIB" no encontrado en: "$verde""$DIR_LIB""$rescolor
				echo -e $amarillo"Se Descargara: "$LIB$gris" Y se ubicara en: "$DIR_LIB$rescolor
				AUX_PWD=$PWD 
				cd $DIR_LIB
				if [ $( curl -sL https://es.wordpress.org/$LIB -o $LIB )  &> /dev/null] ; then
					descomprimirWordpress	
					echo -e $verde"HECHO..."$rescolor		
				else
					echo -e $rojo"Fallo de Descarga.........................."$rescolor	
					while true; do
						clear
						echo "Desea intentar nuevamente la descarga"
						echo "                                   "
						echo -e "      "$verde"1)"$rescolor" SI "
						echo -e "      "$verde"2)"$rescolor" NO "
						echo "                                       "
						echo -n "      #> "
						read yn
						echo ""
						case $yn in
							1 ) 
								installWordpress
								break ;;
							2 ) 
								echo -e $verde"CONTINUANDO..."$rescolor	
								$NAME_SCRIPT --help	
								break ;;  
							* ) echo "Opción desconocida. Elige de nuevo";
	  					esac
					done
				fi 
				cd $AUX_PWD
				sleep 1;
			else
				descomprimirWordpress
				installWordpress
			fi
		else
			echo -e $PKG$verde" Archivos descomprimidos?................SI"$rescolor
			installPhp
			echo
			if [ -d $DIR_LIB/$RES ]; then
			  	cp -r $DIR_LIB/$RES/ /var/www/html
				rm -R $DIR_LIB/$RES
			fi  
			apacheRestart
			installWordpress
		fi
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
		echo -e $verde"Listo para probar wordpress en el servidor apache"$rescolor
		echo "Creando wordpress en el directrio /var/www/html"
		echo -e $verde"HECHO..."$rescolor	
		echo 
		echo -e $verde"Presione ctrl+click en el link: "$gris"http://localhost:8080/wordpress/wp-admin/install.php"$rescolor
		echo
	fi
	sleep 0.1
}

function descomprimirWordpress(){
	DIR_LIB='/opt'
	LIB='wordpress-4.9.7-es_ES.tar.gz'
	sudo cp $DIR_LIB/$LIB /opt
	AUX=$PWD 	
	cd $DIR_LIB && sudo tar -xvf $LIB && cd $AUX
}

function installTomcat(){
	echo -e $azul"Pagina oficial de descarga"$gris": "$amarillo"http://tomcat.apache.org/download-70.cgi"$rescolor

	PKG='apache tomcat 7'
	RES='apache-tomcat-7.0.90'
	LIB='apache-tomcat-7.0.90.tar.gz'
	DIR_LIB='/opt'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG
	
	if ! [ -d $DIR_TOMCAT ]; then
		if ! [ -d $DIR_LIB/$RES ]; then
			if ! [ -f $DIR_LIB/$LIB ]; then
				echo -e $rojo$LIB" no encontrado en: "$verde""$DIR_LIB""$rescolor
				echo -e $amarillo"Se Descargara: "$LIB$gris" Y se ubicara en: "$DIR_LIB$rescolor
				AUX_PWD=$PWD 
				cd $DIR_LIB
				if [ $( curl -sL http://www-eu.apache.org/dist/tomcat/tomcat-7/v7.0.90/bin/$LIB -o $LIB )  &> /dev/null] ; then
					descomprimirTomcat	
					echo -e $verde"HECHO..."$rescolor		
				else
					echo -e $rojo"Fallo de Descarga.........................."$rescolor	
					while true; do
						clear
						echo "Desea intentar nuevamente la descarga"
						echo "                                   "
						echo -e "      "$verde"1)"$rescolor" SI "
						echo -e "      "$verde"2)"$rescolor" NO "
						echo "                                       "
						echo -n "      #> "
						read yn
						echo ""
						case $yn in
							1 ) 
								installTomcat
								break ;;
							2 ) 
								echo -e $verde"CONTINUANDO..."$rescolor	
								$NAME_SCRIPT --help	
								break ;;  
							* ) echo "Opción desconocida. Elige de nuevo";
	  					esac
					done
				fi 
				cd $AUX_PWD
				sleep 1;
			else
				descomprimirTomcat
				installTomcat
			fi
		else
			echo -e $PKG$verde" Archivos descomprimidos?................SI"$rescolor""
			cp -r $DIR_LIB/$RES/ /usr/share
			mv /usr/share/$RES $DIR_TOMCAT
			rm -R $DIR_LIB/$RES
			installTomcat
			configTomcat
		fi
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	sleep 0.1
}

function configTomcat(){
	installJdk
	echo
	echo "Ahora agregamos al fichero de arranque del sistema "
	echo -e $verde"Abriendo"$gris$DIR_TOMCAT'/bin/catalina.sh'$rescolor
	echo
	echo -e "JAVA_HOME="$gris$JAVA_HOME$rescolor
	echo -e "JRE_HOME="$gris$JRE_HOME$rescolor
	echo
	#gedit $DIR_TOMCAT'/bin/catalina.sh'
	sudo chmod 777 $DIR_TOMCAT'/bin/catalina.sh'
	echo "$( cat $DIR_TOMCAT'/bin/catalina.sh' | sed "2i JAVA_HOME=$JAVA_HOME\nJRE_HOME=$JRE_HOME" )">$DIR_TOMCAT'/bin/catalina.sh'
	echo -e $verde"HECHO..."$rescolor	
	echo

	if [ $CATALINA_BASE ]; then 
		echo -e "CATALINA_BASE="$gris$CATALINA_BASE$rescolor
	else
		echo -e $azul"configurando variables entorno CATALINA_BASE"$rescolor
		echo "$( cat '/etc/environment' | sed "1i export CATALINA_BASE='/usr/share/tomcat7'\nexport PATH=$(echo '$CATALINA_BASE')/bin:$(echo '$PATH')\n" )">'/etc/environment'		
		echo -e $verde"HECHO..."$rescolor	
	fi
	if [ $CATALINA_HOME ]; then 
		echo -e "CATALINA_HOME="$gris$CATALINA_HOME$rescolor
	else
		echo -e $azul"configurando variables entorno CATALINA_HOME"$rescolor
		echo "$( cat '/etc/environment' | sed "1i export CATALINA_HOME='/usr/share/tomcat7'\nexport PATH=$(echo '$CATALINA_HOME')/bin:$(echo '$PATH')\n" )">'/etc/environment'		
		echo -e $verde"HECHO..."$rescolor	
	fi
	if [ $CATALINA_TMPDIR ]; then 
		echo -e "CATALINA_TMPDIR="$gris$CATALINA_TMPDIR$rescolor
	else
		echo -e $azul"configurando variables entorno CATALINA_TMPDIR"$rescolor
		echo "$( cat '/etc/environment' | sed "1i export CATALINA_TMPDIR='/usr/share/tomcat7'\nexport PATH=$(echo '$CATALINA_TMPDIR')/bin:$(echo '$PATH')\n" )">'/etc/environment'		
		echo -e $verde"HECHO..."$rescolor	
	fi
	source '/etc/environment'

	echo "Configuración de los usuarios"
	echo
	echo -e "Editamos ahora el fichero:"$gris" /usr/share/tomcat7/conf/tomcat-users.xml"$rescolor
	echo -e "para introducir un nuevo usuario que será el gestor de la administración web:"
	echo -n "Ingrese el nombre del usuario > "
	read username
	echo -n "Ingrese la contrasena para el usuario > "
	read password
	echo "&lt;?xml version='1.0' encoding='utf-8'?&gt;

&lt;tomcat-users&gt;
 &lt;role rolename=\"manager-gui\"/&gt;
 &lt;user username=\"$username\" password=\"$password\" roles=\"manager-gui\"/&gt;
&lt;/tomcat-users&gt;">$DIR_TOMCAT'/conf/tomcat-users.xml'
	echo -e $verde"HECHO..."$rescolor	
	echo -e $verde"Iniciando prueba de servidor"$rescolor
	echo -e "Ejecutando"$rojo" sudo $gris$DIR_TOMCAT/bin/startup.sh"$rescolor
	echo "Arranque: "
	sudo $DIR_TOMCAT/bin/startup.sh
	echo -e $verde"Presione Ctrl+click en el link: "$gris"http://localhost:8080"$rescolor
	echo
	echo "Parada: "
	while true; do
						echo "Desea detener el servidor"
						echo "                                   "
						echo -e "      "$verde"1)"$rescolor" SI "
						echo -e "      "$verde"2)"$rescolor" NO "
						echo "                                       "
						echo -n "      #> "
						read yn
						echo ""
						case $yn in
							1 ) 
								echo -e "Ejecutando"$rojo" sudo $gris$DIR_TOMCAT/bin/shutdown.sh"$rescolor
								sudo $DIR_TOMCAT/bin/shutdown.sh
								break ;;
							2 ) 
								echo -e $verde"CONTINUANDO..."$rescolor	
								echo -e "Parada de servidor con: "$rojo" sudo $gris$DIR_TOMCAT/bin/shutdown.sh"$rescolor
								$NAME_SCRIPT --help	
								break ;;  
							* ) echo "Opción desconocida. Elige de nuevo";
	  					esac
					done
}

function descomprimirTomcat(){
	DIR_LIB='/opt'
	LIB='apache-tomcat-7.0.90.tar.gz'
	PKG='apache tomcat 7'
	RES='apache-tomcat-7.0.90'
	sudo cp $DIR_LIB/$LIB /opt
	AUX=$PWD 	
	cd $DIR_LIB && sudo tar -xvf $LIB && cd $AUX
}

function installWebStorm(){
	PKG='WebStorm'
	RES='WebStorm-173.4548.30'
	LIB='WebStorm-2017.3.4.tar.gz'
	DIR_LIB='/opt'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG
		
	if ! [ -d $DIR_LIB/$RES ]; then
		if ! [ -f $DIR_LIB/$LIB ]; then
			echo -e $rojo$LIB" no encontrado en: "$verde""$DIR_LIB""$rescolor
			echo -e $amarillo"Se Descargara: "$LIB$gris" Y se ubicara en: "$DIR_LIB$rescolor
			
			AUX_PWD=$PWD 
			cd $DIR_LIB
			if [ $( curl -sL https://download.jetbrains.com/webstorm/$LIB -o $LIB )  &> /dev/null] ; then
				 descomprimirWebStorm	
				echo -e $verde"HECHO..."$rescolor		
			else
				echo -e $rojo"Fallo de Descarga.........................."$rescolor		
			fi 
			cd $AUX_PWD
			sleep 1;
		else
			descomprimirWebStorm
		fi
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	sleep 0.1
}

function descomprimirWebStorm(){
	DIR_LIB='/opt'
	LIB='WebStorm-2017.3.4.tar.gz'
	PKG='WebStorm'
	RES='WebStorm-173.4548.30'
	sudo cp $DIR_LIB/$LIB /opt
	AUX=$PWD 	
	cd /opt && sudo tar -xvf $LIB && cd $AUX
	WEBSTORM="/opt/"$RES
	sudo chmod +x $WEBSTORM/bin/webstorm.sh
	sudo bash -ic " echo '[Desktop Entry]
Version=1.0
Type=Application
Name=WebStorm
Icon=/opt/WebStorm-173.4548.30/bin/webstorm.svg
Exec="/opt/WebStorm-173.4548.30/bin/webstorm.sh" %f
Comment=The Drive to Develop
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-webstorm'>'/usr/share/applications/jetbrains-webstorm.desktop'
"
}

function installVisualStudioCode(){
	DIR_LIB='/opt'
	PKG='VisualStudioCode'
	URL='https://az764295.vo.msecnd.net/stable/f88bbf9137d24d36d968ea6b2911786bfe103002/'
	LIB='code-stable-code_1.20.1-1518535978_amd64.tar.gz'
	RES='VSCode-linux-x64'
	echo -e $azul"Tool"$gris"-"$amarillo"dev"$rescolor": "$PKG
		
	if ! [ -d $DIR_LIB/$RES ]; then
		if ! [ -f $DIR_LIB/$LIB ]; then
			echo -e $rojo$LIB" no encontrado en: "$verde""$DIR_LIB""$rescolor
			echo -e $amarillo"Se esta descargando: "$LIB$gris" ubicando recurso en: "$DIR_LIB$rescolor
			
			AUX_PWD=$PWD 
			cd $DIR_LIB
			if ! [ echo $( curl -sL $URL$LIB -o $LIB ) &> /dev/null ] ; then
				 descomprimirVisualStudioCode
				echo -e $verde"HECHO..."$rescolor		
			else
				echo -e $rojo"Fallo de Descarga.........................."$rescolor		
			fi 
			cd $AUX_PWD
			sleep 1;
		else
			descomprimirVisualStudioCode
		fi
	else
		echo -e $PKG$verde" Esta Instalado?................SI"$rescolor""
	fi
	sleep 0.1
}

function descomprimirVisualStudioCode(){
	DIR_LIB='/opt'
	PKG='VisualStudioCode'
	LIB='code-stable-code_1.20.1-1518535978_amd64.tar.gz'
	RES='VSCode-linux-x64'
	BIN='/bin/code'
	AUX=$PWD 	
	echo -e $amarillo"Descomprimiendo recurso...."$rescolor
	cd $DIR_LIB && sudo tar -xvf $LIB && cd $AUX
	echo -e $verde"HECHO..."$rescolor
	sudo chmod +x $DIR_LIB/$RES$BIN
	bash -ic "bash $DIR_LIB/$RES$BIN"
}

main "$@"
