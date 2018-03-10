#Script sascha

install el script sascha en tu computadora con:

~ $ sudo curl -sL https://raw.githubusercontent.com/SaschaNutric/scripts-bash/master/dist/run-sascha -o /bin/sascha && sudo chmod a+x /bin/sascha && sudo sascha

El script sascha facilita el trabajo en el desarrollo y control de version con github

ejecute sascha desde una terminal

comando basico:

~ $ sascha init		"inicia el repositorio local de trabajo y clona todos los proyectos de sascha"
~ $ sascha pull   	"Comienza actualizando tu repositorio local con los cambio en el repositorio padre"
~ $ sascha push		"Finaliza subiendo los cambio realizado de tu repositorio local a github"
