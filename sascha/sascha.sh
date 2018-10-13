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

NAME_SCRIPT='sascha'
DIR_SCRIPT='/usr/share/sascha'

DIR_JSON="$DIR_SCRIPT/config.json"
JSON_CONFIG=$(cat $DIR_JSON)

WORKSPACE=$(node -pe 'JSON.parse(process.argv[1]).workspace' "$JSON_CONFIG")

URL_GIT_BASE=$(node -pe 'JSON.parse(process.argv[1]).urlBaseGit' "$JSON_CONFIG")
REPO_PADRE=$(node -pe 'JSON.parse(process.argv[1]).repoPadre' "$JSON_CONFIG")
USER_NAME=$(git config --global user.name)
USER_EMAIL=$(git config --global user.email)
URL_GIT_MASTER=$URL_GIT_BASE$USER_NAME/
PROJECTS_NAME=$(node -e 'var data = JSON.parse(process.argv[1]); for (let prj of data.projects) { console.log( prj.name ) };' "$JSON_CONFIG") 
PROJECTS_AUX=$(node -e 'var data = JSON.parse(process.argv[1]); for (let prj of data.projects) { console.log( prj.name ) };' "$JSON_CONFIG") 
declare -a ARRAY_PROJECTS=($PROJECTS_NAME);
declare -a ARRAY_AUX=($PROJECTS_NAME);

OBJS=''
AL_PROJECT=''
_ADD=false
_PUSH=false
_COMMIT=false
_FETCH=false

function main(){
clear
while true; do
		case "$@" in
			"update-system" )
		 		upgradeSystem
		 	break;;
			"init" ) init
			break;;
			"config" ) config
			break;;
			"push" ) push
			break;;
			"fetch" ) 
				_FETCH=true
				push
			break;;
			"tooldev" ) tooldev 
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

v=''
function validate(){
	case "$v" in
			"h" ) 
				echo -e $amarillo"->"$rescolor 
				break;;
			"c" )
				val="" 	
				if [ "$WORKSPACE" = "" ] ; then
					val=$rojo"+>"$rescolor 
				else
					if ! [ -d $WORKSPACE ] ; then
						val=$rojo"+>"$rescolor 
					fi
				fi
				if [ "$REPO_PADRE" = "" ] ; then
					val=$rojo"+>"$rescolor 

				else 
					val=$gris"<>"$rescolor 
					res="["$(curl -I $URL_GIT_BASE$REPO_PADRE 2>/dev/null | grep "Status:" | head -1 | cut -d":" -f2 | tr -d '\r')"]"
					if [ "$res" = "[ 200 OK]" ] ; then 
							val=$amarillo"->"$rescolor 
					fi
				fi
				if [ "$PROJECTS_NAME" = "" ] ; then
					val=$rojo"+>"$rescolor 
				fi
				if [ "$USER_NAME" = "" ] ; then
					val=$rojo"+>"$rescolor 
				fi
				if [ "$val" = "" ] ; then
				  echo -e $verde"x>"$rescolor 
				else
					echo -e $val
				fi
				break;;
			"i" ) 
				val=$verde"x>"$rescolor 
				for arg in "${ARRAY_PROJECTS[@]}"; do 
					if ! [ -d $WORKSPACE/$arg ] ; then
						val=$rojo"+>"$rescolor 
					fi
				done
				echo -e $val
				break;;		
			"p" ) 
				val=""
				for arg in "${ARRAY_PROJECTS[@]}"; do 
					AUX_PWD=$PWD
					cd $WORKSPACE/$arg
					declare -a ARRAY_STATUS=($(git status))
					for arr2 in "${ARRAY_STATUS[@]}"; do 
						if [ "$arr2" = "push\"" ]; then
							val=$rojo"+>"$rescolor 
							break;
						fi
						if [ "$arr2" = "add" ]; then
							val=$rojo"+>"$rescolor 
							break;
						fi
					done
					cd $AUX_PWD
				done
				if [ "$val" = "" ] ; then
				  echo -e $verde"x>"$rescolor 
				else
					echo -e $val
				fi
				break;;	
			"f" )
				echo -e $amarillo"->"$rescolor 
				break;;
			* ) 
				echo -e $amarillo"->"$rescolor
				break;;
	esac
}

function help(){
	echo -e $amarillo"ejecutar el script" $azul" "$NAME_SCRIPT" "$amarillo"con argumento"$rescolor
	echo -e $amarillo$NAME_SCRIPT$rescolor" [ opcion ]"
	echo -e $magenta"    opcion:"$rescolor
	echo -e "	"$(v=h && validate)"|	--help	  * Ayuda de "$NAME_SCRIPT
	echo -e "	"$(v=c && validate)"|	config	  * Configuracion del script "$azul"sascha"$rescolor
	echo -e "	"$(v=i && validate)"|	init  	  * Clonar: "$gris"[ "$(viewProjects)$gris" ]"$rescolor
	echo -e "	"$(v=p && validate)"|	push  	  * Subir a mi repositorio: "$URL_GIT_MASTER
	echo -e "	"$(v=f && validate)"|	fetch  	  * Actualizar con los cambios de: "$URL_GIT_BASE$REPO_PADRE
	echo -e "	"$(v=g && validate)"|	github    * Gestiona tu repositorio git"
	echo -e "	"$(v=t && validate)"|	tooldev   * Instala las herramientas de desarrollo"
	echo -e "	"$(v=u && validate)"|	update 	  * Actualiza tu script "$NAME_SCRIPT
	echo
	echo -e $verde"	x>"$rescolor"No ejecutar 	"$amarillo"->"$rescolor"Ejecucion opcional 	"$gris"<>"$rescolor"Sin Coneccion 	"$rojo"+>"$rescolor"Ejecutar 	"
	echo
}

function init(){
	if ! [ -d $WORKSPACE ]; then
		echo -e $verde"Creado Area de Trabajo: "$amarillo$WORKSPACE$rescolor
		mkdir -p $WORKSPACE
		init
	else
		clone
	fi	
}

function clone(){
	for projectName in "${ARRAY_PROJECTS[@]}"; do 
		echo -e $amarillo"Estas a punto de clonar el repositorio: "$magenta$URL_GIT_MASTER$projectName'.git'$rescolor
		if ! [ -d $WORKSPACE'/'$projectName ]	; then
			#git clone $URL_GIT_MASTER$projectName'.git'
			echo -e $verde" OK "$rescolor
		else
			echo -e $verde" Repositorio Existente "$rescolor
		fi
	done	
}

function push(){
	commit	

	AUX_PWD=$PWD 
	cd $WORKSPACE'/'$AL_PROJECT

	REMOTE=''
	EST='Push'
	if [ "$_FETCH" = "true" ]; then
		_PUSH=$_FETCH
		EST='Fetch'
		declare -a ARRAY_REMOTE=($(git remote));
		enc=false
		for remoteName in "${ARRAY_REMOTE[@]}"; do 
			if [ "$remoteName" = "upstream" ]; then
				enc=true
			fi		
		done
		if [ "$enc" = "false" ]; then
			echo -e $amarillo"Ejecutando: "$magenta"git remote add upstream $URL_GIT_BASE$REPO_PADRE/$AL_PROJECT.git"$rescolor
			git remote add upstream $URL_GIT_BASE$REPO_PADRE'/'$AL_PROJECT'.git'
			pause
		fi		
	fi

	if [ "$_PUSH" =  "true" ] ; then
	clear
	echo
	echo -e $amarillo"Paso 4:"$azul" Hacer $EST"$rescolor
	echo -e $amarillo"Repositorio: "$magenta$AL_PROJECT$rescolor
	while true; do	
		echo -e $amarillo"Menu $EST"$rescolor
		echo -e $amarillo"------------------------------------------------------------------------- "$rescolor
		echo -e $amarillo"|                         TUS REPOSITORIO REMOTO                        |"$rescolor
		viewRemotes
		echo -e $amarillo"|                                                                       |"$rescolor
		echo -e $amarillo"-------------------------------------------------------------------------"$rescolor
		echo -e "      "$verde"1)"$rescolor" Iniciar $EST "$rescolor
		echo -e "      "$verde"2)"$rescolor" Agregar Nuevo Repositorio Remoto  "$rescolor
		echo -e "      "$verde"3)"$rescolor" Remover Repositorio Remoto  "$rescolor
		echo -e "      "$verde"4)"$rescolor" Cancelar   "$rescolor
		echo
		echo -n "     #> "
		read yn
		echo 
		case $yn in
			1 ) 
				echo -e $azul"$EST: "$gris"Actualizar cambio"$rescolor
				echo -n "Al repositorio remoto: "$(viewRemotesName)
				read REMOTE;
				enc=false
				for projectName in "${ARRAY_PROJECTS[@]}"; do 
				if [ "$projectName" = "$AL_PROJECT" ] ; then
					declare -a ARRAY_REMOTE=($(git remote));
					for remoteName in "${ARRAY_REMOTE[@]}"; do 
						if [ "$remoteName" = "$REMOTE" ] ; then 
							declare -a ARRAY=($())
							for arr in "${ARRAY[@]}"; do 
								echo $arr
							done 
							if [ "$_FETCH" = "false" ] ; then
								echo -e $amarillo"Ejecutando: "$magenta"git push $REMOTE"$rescolor
							 	git push $REMOTE	
							 	echo -e $verde"Ok..."$rescolor
							else
								echo -e $amarillo"Ejecutando: "$magenta"git fetch $REMOTE"$rescolor
								git fetch $REMOTE
								echo -e $verde"Ok..."$rescolor
								echo -n "Desea Fusionar los Cambios [ Y/n ] #> "
								read CND
								if [ "$CND" = "Y" ] ; then
									echo -e $amarillo"Ejecutando: "$magenta"git merge upstream/master"$rescolor
									git merge upstream/master
									echo -e $verde"Ok..."$rescolor
								else
									if [ "$CND" = "y" ] ; then
										echo -e $amarillo"Ejecutando: "$magenta"git merge upstream/master"$rescolor
										git merge upstream/master
										echo -e $verde"Ok..."$rescolor
									fi
								fi
							fi
						enc=true
						fi
					done
				fi
				done
				if [ "$enc" = "false" ] ; then
					echo -e $azul"No se encontro la orden intente de nuevo"$rescolor
					pause
					push
				fi	
				break ;;
			2 )
				echo -e $amarillo"Agregar remote"$rescolor
				echo -n "nombre   #> "
				read nombre	
				echo -n "url      #> "
				read url	
				res="["$(curl -I $url 2>/dev/null | grep "Status:" | head -1 | cut -d":" -f2 | tr -d '\r')"]"
				if [ "$res" = "[ 200 OK]" ] ; then 
					echo -e $amarillo"Ejecutando: "$magenta"git add $nombre $url"$rescolor
					git remote add $nombre $url
					echo -e $verde"Ok..."$rescolor
				else
					echo -e $rojo"Error: "$amarillo" No se ha logrado conectar con: "$magenta$url$rescolor
					echo -e $rojo"Hacer: "$amarillo" Verificar coneccion a internet: "$rescolor
					echo
					pause
					exit
				fi
				break ;;
			3 )
				echo -e $amarillo"Remover remote"$rescolor
				echo -n "nombre   #> "
				read nombre	
				declare -a ARRAY_REMOTE=($(git remote));
				for remoteName in "${ARRAY_REMOTE[@]}"; do 
					if [ "$remoteName" = "$nombre" ] ; then 
						echo -e $amarillo"Ejecutando: "$magenta"git remote remove $nombre"$rescolor
						git remote remove $nombre
						echo -e $verde"Ok..."$rescolor
					fi
				done
				break ;;
			4 ) exit 1;
				break ;;
			* ) clear;
		  esac
	done
	sleep 0.1

	else
		echo -e $verde"No estas listo para hacer $EST"$rescolor
	fi
	cd $AUX_PWD 
}

function commit(){
	clear
	echo
	echo -e $amarillo"Paso 1:"$azul" Seleccionar Proyecto"$rescolor
	echo -e $amarillo"--------------------------------------------------- "$rescolor
	echo -e $amarillo"|                   TUS PROYECTOS                 |"$rescolor
	viewProjects
	echo -e $amarillo"|                                                 |"$rescolor
	echo -e $amarillo"--------------------------------------------------- "$rescolor
	echo -e "                                "$rescolor
	echo -e $verde"p>"$rescolor"Hacer push  "$rojo"a>"$rescolor"Agregar cambio  "$amarillo"c>"$rescolor"Hacer commit  "$rescolor$magenta"*>"$rescolor"Actualizado  "$rescolor
	echo -e "                                "$rescolor
	echo -n "     #> "
	echo -e ""
	echo -n "Al projecto: ";
	read AL_PROJECT;
	enc=false
	for projectName in "${ARRAY_PROJECTS[@]}"; do 
		if [ "$projectName" = "$AL_PROJECT" ] ; then
			commitGit		
			enc=true
		fi
	done
	if [ "$enc" = "false" ] ; then
		echo -e $azul"No se encontro la orden intente de nuevo"$rescolor
		pause
		commit
	fi
	sleep 0.1
}

function commitGit(){

	AUX_PWD=$PWD 
	cd $WORKSPACE'/'$AL_PROJECT
	
	declare -a ARRAY_STATUS=($(git status))
	for arr in "${ARRAY_STATUS[@]}"; do 
		if [ "$arr" = "push\"" ]; then
			clear
			_PUSH=true
			break;
		fi		
		if [ "$arr" = "add" ]; then
				clear
				echo 
				echo -e $amarillo"Repositorio: "$azul$AL_PROJECT$rescolor
				echo -e $amarillo"Estado del repositorio"$rescolor
				echo -e $amarillo"Ejecutando: "$magenta"git status"$rescolor
				git status
				addGit && cmm
				break;
		fi
		if [ "$arr" = "committed:" ]; then
				clear
				echo 
				echo -e $amarillo"Repositorio: "$azul$AL_PROJECT$rescolor
				echo -e $amarillo"Estado del repositorio"$rescolor
				echo -e $amarillo"Ejecutando: "$magenta"git status"$rescolor
				git status
				_ADD=true && cmm
				break;
		fi
	done	
	cd $AUX_PWD
}

function addGit(){
	clear
	echo
	echo -e $amarillo"Paso 2:"$azul" Agregar Cambios"$rescolor
	echo -e $amarillo"Repositorio: "$magenta$AL_PROJECT$rescolor
	echo -e $amarillo"Estado del repositorio"$rescolor
	echo -e $amarillo"Ejecutando: "$magenta"git status"$rescolor
	git status 
	while true; do	
		echo
		echo -e $verde"ok "$magenta"para continuar "$azul" . "$gris"para agregar todos los cambios"$rescolor
		echo -n "Agregar Cambio  #> "
		read cambio

		if [ "$cambio" = "." ] ; then
			echo -e $amarillo"Ejecutando: "$magenta"git add ."$rescolor
			git add .
			_ADD=true
			break
		fi

		if [ "$cambio" = "ok" ] ; then
			_ADD=true && break
		else
			if [ "$cambio" = "oK" ] ; then
				_ADD=true && break
				else
					if [ "$cambio" = "Ok" ] ; then
						_ADD=true && break
						else
							if [ "$cambio" = "OK" ] ; then
								_ADD=true && break
							fi			
					fi					
			fi			
		fi

		if [ -f $WORKSPACE'/'$AL_PROJECT/$cambio ] ; then
			echo -e $amarillo"Agregando Archivo"$rescolor
			AUX_PWD=$PWD 
			cd $WORKSPACE'/'$AL_PROJECT
			echo -e $amarillo"Ejecutando: "$magenta"git add $cambio "$rescolor
			git add $cambio
			cd $AUX_PWD 
			_ADD=true
			echo -e $verde"OK"$rescolor
		else
			echo -e $rojo"Error: Archivo No Encontrado"$rescolor
			echo -e $amarillo"Nota: "$magenta"Agragar todos los cambio con: ."$rescolor
		fi
		echo -n "Agregar Mas Archivo  [ Y/n ] #> "
		read CND
		if [ "$CND" = "Y" ] ; then
			addGit
			if [ "$CND" = "y" ] ; then
				addGit
			else
				break;
			fi
		fi
	done
}

function cmm(){
	clear
	echo
	echo -e $amarillo"Paso 3:"$azul" Hacer Commit"$rescolor
	while true; do	
		echo -e $gris"Estas a punto de hacer un commit"$rescolor
		echo -e $amarillo"--------------------------------------------------- "$rescolor
		echo -e $amarillo"|            TU USUARIO PARA EL COMMIT             |"$rescolor
		echo -e $magenta "   "$(git config --global user.name) $azul " - " $magenta $(git config --global user.email)$rescolor
		echo -e $amarillo"|                                                  |"$rescolor
		echo -e $amarillo"----------------------------------------------------"$rescolor
		echo -e "      "$verde"1)"$rescolor" Cambiar Usuario Git "$rescolor
		echo -e "      "$verde"2)"$rescolor" Hacer Commit "$rescolor
		echo -e "      "$verde"3)"$rescolor" Cancelar   "$rescolor
		echo -e "                                        "$rescolor
		echo -n "     #> "
		read yn
		echo 
		case $yn in
			1 ) 
				configUser
				echo -e $amarillo"Ejecutando: "$magenta"git config --global user.name $USER_NAME"$rescolor
				echo -e $amarillo"Ejecutando: "$magenta"git config --global user.email $USER_EMAIL"$rescolor
				git config --global user.name $USER_NAME
				git config --global user.email $USER_EMAIL
				cmm
				break ;;
			2 ) 
				AUX_PWD=$PWD  
				cd $WORKSPACE'/'$AL_PROJECT
				clear
				git status
				echo
				if [ "$_ADD" = "true" ] ; then
					echo -e $amarillo"Ingresar el mensaje para el commit"$rescolor
					echo -n "      #> "
					read MSG	
					echo -e $amarillo"Ejecutando: "$magenta"git commit -m $MSG"$rescolor
					git commit -m "$MSG" 
					_PUSH=true
					echo -e $verde"OK..."$rescolor
					pause
				else
					echo -e $verde"No Estas listo para hacer commit"$rescolor
				fi
				cd $AUX_PWD 
				break ;;
			3 ) exit 1;
				break ;;
			* ) clear;
		  esac
	done
	sleep 0.1
}

function configUser(){
	echo -n "Usuario Git: [ $(git config --global user.name) ]: ";
 	read d; 
 	if ! [ "$d" = "" ]; then 
 		echo -e $amarillo"Verificando usuario"$rescolor
		res="["$(curl -I $URL_GIT_BASE$d 2>/dev/null | grep "Status:" | head -1 | cut -d":" -f2 | tr -d '\r')"]"
		if [ "$res" = "[ 200 OK]" ] ; then 
			echo -e $verde"Ok..."$rescolor
			USER_NAME=$d;
		else
			echo -e $rojo"Error: "$amarillo" El usuario "$azul$d$amarillo" no es un usuario de github"$rescolor
			pause
			configUser
		fi
 	fi
 	echo -e $amarillo"Primary email address go: "$magenta$URL_GIT_BASE"settings/emails"
 	echo -n "Email Git: [ $(git config --global user.email) ]: ";
 	read d; 
 	if ! [ "$d" = "" ]; then 
 		USER_EMAIL=$d;
 	fi
}

function config(){
	isGithub

	echo -e $amarillo"Configurando Script "$magenta$NAME_SCRIPT$rescolor
	echo 

	configUser
 	
	echo -n "Repositorio Padre: [ $REPO_PADRE ]: ";
 	read d; 
 	if ! [ "$d" = "" ]; then 
 		res="["$(curl -I $URL_GIT_BASE$d 2>/dev/null | grep "Status:" | head -1 | cut -d":" -f2 | tr -d '\r')"]"
		if [ "$res" = "[ 200 OK]" ] ; then 
			echo -e $verde"Ok..."$rescolor
			REPO_PADRE=$d;
		else
			echo -e $rojo"Error: "$amarillo" El usuario "$azul$d$amarillo" no es un usuario de github"$rescolor
			pause
			config
		fi
 	fi 	

	echo -n "Area de Trabajo: [ $WORKSPACE ]: " ;
	read d;
	if ! [ "$d" = "" ] ; then
		WORKSPACE=$d;
	fi

	echo
	ARRAY_AUX=($PROJECTS_NAME)
	crearJSONObject
	echo -n "Desea Gestiona projectos Y/n: "
	read line;
	if [ "$line" = "Y" ]; then 
			gestorProjectos
			crearJSONObject
	else
		if [ "$line" = "y" ]; then 
			gestorProjectos
			crearJSONObject
		fi
	fi

	echo
	echo -e $amarillo$DIR_JSON$rescolor
	echo -e $magenta"{
	\"urlBaseGit\":\"$URL_GIT_BASE\",
	\"repoPadre\":\"$REPO_PADRE\",
	\"repo\":\"$USER_NAME\",
	\"workspace\":\"$WORKSPACE\",
	\"userEmail\":\"$USER_EMAIL\",
	\"projects\":$OBJS
}"$rescolor

	echo
	echo -n "Desea Guardar Y/n: "
	read line;

	if [ "$line" = "Y" ]; then 
		saveTemplate  && init	
	else
		if [ "$line" = "y" ]; then 
			saveTemplate && init
		fi
	fi
}

function isGithub(){
	clear
	echo -e $rojo"Repositorio: "$amarillo" Conectando con github: "$gris$URL_GIT_BASE$rescolor
	sleep 2
	res="["$(curl -I $URL_GIT_BASE 2>/dev/null | grep "Status:" | head -1 | cut -d":" -f2 | tr -d '\r')"]"
	if [ "$res" = "[ 200 OK]" ] ; then 
		echo -e $amarillo"Conectado a: "$magenta$URL_GIT_BASE$rescolor
	else
		echo -e $rojo"Error: "$amarillo" No se ha logrado conectar con: "$magenta$URL_GIT_BASE$rescolor
		echo -e $rojo"Hacer: "$amarillo" Verificar coneccion a internet: "$rescolor
		echo
		pause
		exit
	fi
}

function crearJSONObject(){
	OBJS=''
	CONT_A=0;
	for projectName in "${ARRAY_AUX[@]}"; do 
		CONT_A=$(node -e "var valor = $CONT_A + 1 ; console.log(valor) " );
	done

	CONT_B=0;
	for projectName in "${ARRAY_AUX[@]}"; do 
		CONT_B=$(node -e "var valor = $CONT_B + 1 ; console.log(valor) " );
		if ! [ "$CONT_A" = "$CONT_B" ] ; then
		OBJS=$OBJS"{
	 \"name:\":\"$projectName\"

	},";
		else
		OBJS=$OBJS"{
	 \"name:\":\"$projectName\"

	}"
		fi
	done

	OBJS='['$OBJS']'
}
function gestorProjectos(){
clear
	while true; do	
		echo -e $amarillo"Estas sobre el repositorio: "$magenta$URL_GIT_MASTER$rescolor
		echo -e $amarillo"Gestor de projectos"$rescolor
		echo -e $amarillo"--------------------------------------------------- "$rescolor
		echo -e $amarillo"|                   TUS PROJECTS                   |"$rescolor
		viewProjects
		echo -e $amarillo"|                                                  |"$rescolor
		echo -e $amarillo"----------------------------------------------------"$rescolor
		echo -e "      "$verde"1)"$rescolor" Agregar  "$rescolor
		echo -e "      "$verde"2)"$rescolor" Remover  "$rescolor
		echo -e "      "$verde"3)"$rescolor" Volver   "$rescolor
		echo -e "                                        "$rescolor
		echo -n "      #> "
		read yn
		echo 
		case $yn in
			1 ) 
				echo -e $azul"Listo para Agregar"$rescolor
				echo -n "Nombre del projecto: ";
				read d;
				echo -e $amarillo"Verificando proyecto"$rescolor
				res="["$(curl -I $URL_GIT_MASTER$d 2>/dev/null | grep "Status:" | head -1 | cut -d":" -f2 | tr -d '\r')"]"
				if [ "$res" = "[ 200 OK]" ] ; then 
					echo -e $verde"Ok..."$rescolor
					PROJECTS_AUX=$PROJECTS_AUX" $d"
					ARRAY_AUX=($PROJECTS_AUX)
					pause
					gestorProjectos
				else
					echo -e $rojo"Error: "$amarillo" El projecto "$azul$d$amarillo" no exite en $URL_GIT_BASE$USER_NAME/"$rescolor
					pause
					gestorProjectos
				fi
				break ;;
			2 ) 
				echo -e $azul"Listo para Remover"$rescolor
				echo -n "Nombre del projecto: ";
				read d;
				AUX=''
				for projectName in "${ARRAY_AUX[@]}"; do 
					echo "$projectName = $d"
					if ! [ "$projectName" = "$d" ] ; then
						AUX=$AUX" $projectName"
					fi
				done
				PROJECTS_AUX=$AUX
				ARRAY_AUX=($PROJECTS_AUX)
				gestorProjectos
				break ;;
			3 ) 
				echo -e $magenta"Procesando Cambios"$rescolor
				sleep 2
				break ;;
			* ) clear;
		  esac
	done
	sleep 0.1	
}

function viewProjects(){
	Data='';
	CONT=0;
	AUX_PWD=$PWD
	for projectName in "${ARRAY_AUX[@]}"; do 
		cd $WORKSPACE/$projectName
		declare -a ARRAY_STATUS=($(git status))
		val=$magenta"*>"$rescolor 
		for arr2 in "${ARRAY_STATUS[@]}"; do 
			if [ "$arr2" = "push\"" ]; then
				val=$verde"p>"$rescolor 
				break;
			fi		
			if [ "$arr2" = "add" ]; then
				val=$rojo"a>"$rescolor 
				break;
			fi
			if [ "$arr2" = "committed:" ]; then
				val=$amarillo"c>"$rescolor 
				break;
			fi
		done

		Data=$Data$azul" $val "$magenta$projectName$rescolor
		CONT=$(node -e "var valor = $CONT + 1 ; console.log(valor) " );
		if [ "$CONT" = "2" ] ; then
			echo -e $magenta"  "$Data$rescolor
			Data='';
			CONT=0;		
		fi
	done
	if [ "$CONT" = "1" ] ; then
		echo -e $magenta"  "$Data$rescolor
		CONT=0;		
	fi
	cd $AUX_PWD
}

function viewRemotes(){
	Data='';
	CONT=0;
	AUX_PWD=$PWD 
	cd $WORKSPACE'/'$AL_PROJECT 
	declare -a ARRAY_REMOTE=($(git remote));
	
	for remoteName in "${ARRAY_REMOTE[@]}"; do 
		Data=$Data$azul" -> "$magenta$remoteName": "$gris$(git remote get-url $remoteName)$rescolor
		CONT=$(node -e "var valor = $CONT + 1 ; console.log(valor) " );
		if [ "$CONT" = "1" ] ; then
			echo -e $magenta"  "$Data$rescolor
			Data='';
			CONT=0;		
		fi
	done
	if [ "$CONT" = "1" ] ; then
		echo -e $magenta"  "$Data$rescolor
		CONT=0;		
	fi
	cd $AUX_PWD
}

function viewRemotesName(){
	Data='';
	CONT=0;
	AUX_PWD=$PWD 
	cd $WORKSPACE'/'$AL_PROJECT 
	declare -a ARRAY_REMOTE=($(git remote));


	for remoteName in "${ARRAY_REMOTE[@]}"; do 
		Data=$Data" | "$remoteName
		CONT=$(node -e "var valor = $CONT + 1 ; console.log(valor) " );
		if [ "$CONT" = "1" ] ; then
			echo -n  $Data" | #>" 
			Data='';
			CONT=0;		
		fi
	done
	if [ "$CONT" = "1" ] ; then
		echo -e $magenta"  "$Data$rescolor
		CONT=0;		
	fi
	cd $AUX_PWD
}


function saveTemplate(){
	git config --global user.name "$USER_NAME";
	git config --global user.email "$USER_EMAIL";
	echo "{
	\"urlBaseGit\":\"$URL_GIT_BASE\",
	\"repoPadre\":\"$REPO_PADRE\",
	\"repo\":\"$USER_NAME\",
	\"workspace\":\"$WORKSPACE\",
	\"userEmail\":\"$USER_EMAIL\",
	\"projects\":$OBJS
}">$DIR_JSON
	echo -e $verde"Listo..."$rescolor
}

function update(){
	echo -e $verde"Actualizando el Script "$NAME_SCRIPT$rescolor
	if [ -f /bin/run-$NAME_SCRIPT ]; then
		sudo rm /bin/run-$NAME_SCRIPT
	fi
	if [ -d /usr/share/$NAME_SCRIPT ]; then
		sudo rm -R $DIR_SCRIPT
	fi
	sudo curl -sL https://raw.githubusercontent.com/SaschaNutric/scripts-bash/master/dist/run-sascha -o /bin/sascha 
	sudo chmod a+x /bin/$NAME_SCRIPT 
	sudo $NAME_SCRIPT --help
	sleep 1
	echo -e $verde"Actualizado el Script "$NAME_SCRIPT$rescolor
	echo -e $verde"Ejecutar el script con: "$azul$NAME_SCRIPT$rescolor
	exit 1;
}

function tooldev(){
	if ! [ -d '/usr/share/tooldev' ]; then
		sudo curl -sL https://raw.githubusercontent.com/SaschaNutric/scripts-bash/master/dist/run-tooldev -o /bin/tooldev 
		sudo chmod a+x /bin/tooldev 
	else
		bash -ic "$( echo $( echo "tooldev --help" ) )"
	fi
	exit 1;
}

function pause(){
	echo -n "Presione enter para continuar -->"
	read x;
}

main "$@"