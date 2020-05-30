#!/bin/bash

docker stop `docker ps -qa`
docker rm `docker ps -qa`

# On s'assure d'avoir les dernières versions des images
docker build -t res/apache_php apache-php-image
docker build -t res/express_students express-image

# On lance tout d'abord les deux containers admin / config 
$("pwd")/traefik.sh
$("pwd")/portainer.sh

# Om lance ensuite deux containers de chaque type 
docker run -d --name nodeApp res/express_students 
docker run -d --name nodeApp2 res/express_students 
docker run -d --name landingPage res/apache_php
docker run -d --name landingPage2 res/apache_php
