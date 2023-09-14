#!/bin/bash
#SBATCH --exclusive
#SBATCH --nodes=2
#SBATCH --job-name=docker-hello-mpi
#SBATCH --output=docker-hello-mpi.out
#SBATCH --chdir=/contrib/User.Demo/docker-mpi-hello-world
#SBATCH --ntasks-per-node=1
chdir=/contrib/User.Demo/docker-mpi-hello-world

# CREATE OVERLAY NETWORK FOR MULTIHOST DOCKER CONTAINERS:
# (Running on the first node)
rm -rf hosts
scontrol show hostname $SLURM_JOB_NODELIST > node.list
sudo service docker start
sudo docker swarm init > swarm-init.out
cat swarm-init.out | grep -A 2 "docker swarm join " > docker-swarm-join.sh
sudo docker network create --attachable -d overlay overnet

# START CONTAINER AND PRINT INTERNAL IP
# (Running on the first node)
HOST=$(hostname)
cname=openmpi-${HOST}
sudo docker run -d --name ${cname} --network overnet -v `pwd`:`pwd` -w `pwd` avidalto/openmpi-ubuntu:v3 sleep 1d
cid=$(sudo docker ps -aqf "name=${cname}")
sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${cid} >> hosts

# (Running on all other nodes)
for node in $(tail -n +2 node.list ); do
    ssh ${node} 'bash -s' < ${PWD}/start_docker_container.sh $chdir
done

# COMPILE HELLO WORLD MPI
# (Running on the first node)
sudo docker exec ${cid} rm -f mpi_hello_world
sudo docker exec ${cid} make

# RUN HELLO WORLD MPI
# (Running on the first node)
sudo docker exec ${cid} mpirun \
    --allow-run-as-root \
    --mca plm_rsh_agent "ssh -q -o StrictHostKeyChecking=no" \
    -np 8 \
    --hostfile hosts \
    mpi_hello_world > mpirun.out


#sleep 9999
# STOP CONTAINER:
# (Running on the first node)
sudo docker stop ${cid}                                                                                                                                             
sudo docker rm ${cid}

# (Running on all other nodes)
for node in $(tail -n +2 node.list ); do
    ssh ${node} 'bash -s' < ${PWD}/stop_docker_container.sh
done
