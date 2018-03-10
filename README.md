# scripts-bash
Projecto de desarrollo de script en base a lenguaje de consola Bash Shell

ToolDev es un script para la instalacion de herramienta de desarrollo como 
	Gedit
	Git
	NodeJs
	PostgreSQL
	pgAdmin3
	WebStorm
	SublimeText
	VisualStudioCode

instalar el script tooldev en tu computadora con:

~ $ sudo curl -sL https://raw.githubusercontent.com/SaschaNutric/scripts-bash/master/dist/run-tooldev -o /bin/tooldev && sudo chmod a+x /bin/tooldev && tooldev --help

install el script sascha en tu computadora con:

~ $ sudo curl -sL https://raw.githubusercontent.com/SaschaNutric/scripts-bash/master/dist/run-sascha -o /bin/sascha && sudo chmod a+x /bin/sascha && sudo sascha

Para Contribuir en el desarrollo desde la rama master script-bash con:

~ $ git clone http://github.com/Leo1305Pineda/scripts-bash.git
~ $ cd scripts-bash

Construir script con:
~ $ npm run build-tooldev
~ $ npm run build-sascha

Testear el script con 
~ $ npm run test-tooldev
~ $ npm run test-sascha

Deploy a Git con

~ $ npm run deploy-tooldev



