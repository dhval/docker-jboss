From ubuntu
MAINTAINER Dhval Mudawal

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --ignore-missing install -y \
 build-essential \
 lsof \
 git \
 openssh-server \
 pwgen \
 wget \
 software-properties-common \
 && apt-get clean

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define working directory.
WORKDIR /root

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle \ 
 EAP_HOME=/opt/jboss-eap-6.4

# Setup open ssh server.

RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD run.sh /root/run.sh
RUN chmod +x /root/run.sh

ENV AUTHORIZED_KEYS **None**
ENV ROOT_PWD changeit
EXPOSE 22 5455 9999 8009 8080 8443 3528 3529 7500 45700 7600 57600 5445 23364 5432 8090 4447 4712 4713 9990 8787

# Persistent Volumes
VOLUME ["${EAP_HOME}"]

# Define default command, can have only one command.
ENTRYPOINT ["/root/run.sh"]
CMD [""]
