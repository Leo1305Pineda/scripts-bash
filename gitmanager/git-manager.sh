#!/bin/bash

verde="\033[1;32m"
magenta="\033[0;35m"
rescolor="\e[0m"
amarillo="\033[1;33m"
azul="\033[1;34m"

function main(){
	while true; do
		case "$@" in
			"start" ) 
				addGit
				commitGit
				pushGit
			break;;
			"status" ) statusGit
			break;;
			"add" ) addGit
			break;;
			"commit" ) commitGit
			break;;
			"--help" ) help
			break;;
			* ) help 
			 break;;
		esac
	done				
}

function help(){
	echo "ejecutar el script con argumento"
	echo "[ --help ]"
	echo "[ start ] inicia todo " 
	echo "[ status | add | commit | push ]"

}


function pushGit(){
	echo -e $amarillo"Ejecutando push "$rescolor
	echo -e $azul"_"$magenta"__________________________________"$azul"_"$rescolor
	echo -e $azul"|"$magenta"                                  "$azul"|"$rescolor
	echo -e $azul"|"$magenta"      Tus Repositorio Remoto      "$azul"|"$rescolor
	echo -e $azul" "$verde"    "$(git remote )$rescolor
	echo -e $azul"|"$magenta"                                  "$azul"|"$rescolor
	echo -e $azul"-"$magenta"__________________________________"$azul"-"$rescolor

	echo -n "Ingresar tu romote -->"
	read RP

	clear 
	
	echo -e $amarillo"Ejecutando push "$rescolor
	echo -e $azul"_"$magenta"__________________________________"$azul"_"$rescolor
	echo -e $azul"|"$magenta"                                  "$azul"|"$rescolor
	echo -e $azul"|"$magenta"      Tus Repositorio Remoto      "$azul"|"$rescolor
	echo -e $azul" "$verde"    "$(git branch )$rescolor
	echo -e $azul"|"$magenta"                                  "$azul"|"$rescolor
	echo -e $azul"-"$magenta"__________________________________"$azul"-"$rescolor

	echo -n "Ingresar tu rama -->"
	read R
	git push $RP $R
	echo -e $verde"OK..."$rescolor
}

function statusGit(){
	git status
}

function commitGit(){
	echo -e $amarillo"Ingresar el mensaje del commit"$rescolor
	echo -n "      #> "
	read MSG
	git commit -m "$MSG"
	echo -e $verde"OK..."$rescolor
}

function addGit(){
	statusGit
	while true; do
		echo "Agregar cambios al repositorio local git"
		echo "                                   "
		echo -e "      "$verde"1)"$rescolor" Agregar todos los cambios "
		echo -e "      "$verde"2)"$rescolor" Seleccionar los cambios   "
		echo "                                       "
		echo -n "      #> "
		read yn
		echo ""
		case $yn in
			1 ) 
				git add .
				echo -e $verde"OK..."$rescolor
				break ;;
			2 ) 			
				addSelectGit			
				break ;;  
			* ) echo "Opción desconocida. Elige de nuevo";
	  	esac
	done
}

function addSelectGit(){
	statusGit
	echo -n "Ingresar el cambio #> "
	read CAMBIO
	git add $CAMBIO
	while true; do
		echo "Agregar mas cambios al repositorio local git"
		echo "                                   "
		echo -e "      "$verde"1)"$rescolor" SI "
		echo -e "      "$verde"2)"$rescolor" NO "
		echo "                                       "
		echo -n "      #> "
		read yn
		echo ""
		case $yn in
			1 ) 
				addSelectGit
				break ;;
			2 ) 
				echo -e $verde"CONTINUANDO..."$rescolor		
				break ;;  
			* ) echo "Opción desconocida. Elige de nuevo";
	  	esac
	done
}

main "$@"