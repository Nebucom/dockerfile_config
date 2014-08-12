# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.


# docker OS
FROM ubuntu:trusty


RUN apt-get update
RUN apt-get -y install git
RUN apt-get -y install wget


#RUN apt-get -y install build-essential
RUN apt-get install -y --no-install-recommends openjdk-7-jdk

RUN mkdir -p /root/.ssh
ADD id_rsa /root/.ssh/id_rsa
ADD id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 700 /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa.pub


RUN echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN echo "    UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config
RUN echo "    IdentityFile /root/.ssh/id_rsa" >> /etc/ssh/ssh_config


# In case of problem for testing #
#RUN apt-get install -y openssh-server sudo
#RUN mkdir -p /var/run/sshd

RUN echo 'root:1111' | chpasswd

# Standard SSH port
EXPOSE 22

##################################


# Checkout the node-simple code

RUN git clone -b master git@github.com:Nebucom/node-simple.git node-simple

# Command to run at "docker run ..."

CMD cd /node-simple && git checkout master && git pull && javac Hello.java && java Hello
