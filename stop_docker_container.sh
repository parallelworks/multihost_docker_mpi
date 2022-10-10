#!/bin/bash
HOST=$(hostname)
cname=openmpi-${HOST}
cid=$(sudo docker ps -aqf "name=${cname}")
sudo docker stop ${cid}                                                                                                                                             
sudo docker rm ${cid}
