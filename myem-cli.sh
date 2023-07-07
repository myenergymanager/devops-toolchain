#!/bin/bash

####################################
##
##  myem cli
##
####################################


## Variables ####################################################



## Functions ####################################################

help(){

echo "USAGE :

  ${0##*/} [-h] [--help]
  
  Options :

    -h, --help : aides
    pgadmin, open-pgadmin : aides
    nvou-web, open-nvou-web : ai des
"
}
openPgadmin(){

PORT=80$((10 + $RANDOM % 99))
echo "open pgadmin in $1 et port $PORT  stdout:/tmp/stout-pgadmin-$1-$PORT  stderr:/tmp/stout-pgadmin-$1-$PORT  "
kubectl -n default --context  $1 port-forward pgadmin  $PORT:80  >/tmp/stout-pgadmin-$1-$PORT 2> /tmp/sterr-pgadmin-$1-$PORT &
sleep 2
xdg-open http://127.0.0.1:$PORT  >/dev/null 2>/dev/null


}
openNvouWeb(){

PORT=42$((10 + $RANDOM % 99))
if [ "$1" = "staging" ] || [ "$1" = "preprod" ] || [ "$1" = "alpha" ] ; then
    NAMESPACE=ng"$1"
else
    NAMESPACE="$1"
fi
echo $NAMESPACE

echo "open nvou-web in $1 et port $PORT  stdout:/tmp/stout-nvou-web-$1-$PORT  stderr:/tmp/stout-nvou-web-$1-$PORT  "
kubectl -n $NAMESPACE --context  $1 port-forward svc/nvou-web  $PORT:4200  >/tmp/stout-nvou-web-$1-$PORT 2> /tmp/sterr-nvou-web-$1-$PORT &
sleep 2
xdg-open http://127.0.0.1:$PORT  >/dev/null 2>/dev/null

}

function parser_options(){

case $1 in	
	-h|--help)
	  help
	;;
    open-pgadmin |pgadmin)
	  openPgadmin $2
	;;
    nvou-web | open-nvou-web)
	  openNvouWeb $2
	;;    

	*)
        echo "option invalide, lancez -h ou --help"
esac
}


## Execute ######################################################

parser_options $1  $2

