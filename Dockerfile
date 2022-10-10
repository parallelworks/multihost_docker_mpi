FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN apt-get update &&\
    apt-get install ssh -y &&\
    apt-get install make -y  &&\
    apt-get install -y libopenmpi-dev &&\
    echo PermitRootLogin yes >>  /etc/ssh/sshd_config &&\
    echo PasswordAuthentication no >> /etc/ssh/ssh_config &&\ 
    ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N "" &&\
    cat  ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys &&\
    chmod 600 ~/.ssh/authorized_keys

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
