# MULTIHOST HELLO DOCKER MPI
This repository is an example of running OpenMPI in multiple hosts using Docker and Docker Swarm.


## Instructions:

### Creating the container:

Build, tag and push the docker container using the example Dockerfile in this repository:
```
sudo docker build --tag openmpi .
sudo docker tag openmpi avidalto/openmpi-ubuntu:v3
sudo docker push avidalto/openmpi-ubuntu:v3
```

### Running the demo:
Copy the files to the controller node, edit the header of file `run.sh` and run:
```
sbatch run.sh
```

The output is written to file mpirun.out:

```
Hello world from processor 9ce12119fda8, rank 0 out of 8 processors
Hello world from processor 9ce12119fda8, rank 2 out of 8 processors
Hello world from processor 9ce12119fda8, rank 3 out of 8 processors
Hello world from processor 9ce12119fda8, rank 1 out of 8 processors
Hello world from processor 7ab2031e89e3, rank 7 out of 8 processors
Hello world from processor 7ab2031e89e3, rank 4 out of 8 processors
Hello world from processor 7ab2031e89e3, rank 6 out of 8 processors
Hello world from processor 7ab2031e89e3, rank 5 out of 8 processors
```

For more information go through the code and comments in file `run.sh`