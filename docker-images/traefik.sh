#!/bin/bash

docker run -d -p 8080:8080 -p 80:80 --name traefik \
        --label "traefik.http.routers.traefik.rule"="Host(\`config.res.ch\`)" \
        --label "traefik.http.services.traefik.loadbalancer.server.port"="8080" \
	-v $PWD/traefik/traefik.yml:/etc/traefik/traefik.yml \
	-v /var/run/docker.sock:/var/run/docker.sock \
	traefik:v2.0
