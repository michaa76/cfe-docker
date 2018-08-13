FROM ubuntu
MAINTAINER Eystein Måløy Stenberg <eytein.stenberg@gmail.com>

RUN apt-get update -qq

RUN apt-get -y install gnupg2 wget lsb-release unzip apt-transport-https vim htop iotop

# install latest CFEngine
# https://cfengine.com/product/community/cfengine-linux-distros/
RUN wget -qO- https://cfengine-package-repos.s3.amazonaws.com/pub/gpg.key | apt-key add -
RUN echo "deb https://cfengine-package-repos.s3.amazonaws.com/pub/apt/packages stable main" > \
/etc/apt/sources.list.d/cfengine-community.list
RUN apt-get update
RUN apt-get install cfengine-community

# install cfe-docker process management policy
COPY cfengine/bin/* /var/cfengine/bin/
COPY cfengine/inputs/* /var/cfengine/inputs/

# apache2 and openssh are just for testing purposes, install your own apps here
RUN apt-get -y install openssh-server apache2
RUN mkdir -p /var/run/sshd
RUN echo "root:password" | chpasswd  # need a password for ssh

ENTRYPOINT ["/var/cfengine/bin/docker_processes_run"]
