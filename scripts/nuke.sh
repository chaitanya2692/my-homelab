#!/bin/sh -ex

#Nuke cluster
kubectl delete -f install.yaml

#Nuke docker images & volumes
docker volume prune -f && docker system prune -a -f
