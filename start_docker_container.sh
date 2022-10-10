#!/bin/bash
# FIXME: Generalize this cd
cd $1
sudo service docker start
sudo bash docker-swarm-join.sh
HOST=$(hostname)
cname=openmpi-${HOST}
sudo docker run -d --name ${cname} --network overnet -v `pwd`:`pwd` -w `pwd` avidalto/openmpi-ubuntu:v3 sleep 1d
cid=$(sudo docker ps -aqf "name=${cname}")
sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${cid} >> hosts
