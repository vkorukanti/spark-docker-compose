FROM ubuntu:14.04
MAINTAINER Venki Korukanti (venki.korukanti@gmail.com)

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

# Install SSH server
RUN \
  apt-get update && \
  apt-get install -y openssh-server sshpass

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/' /etc/ssh/ssh_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Set environment variables.
ENV HOME /root

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Download Hadoop package
ADD http://apache.arvixe.com/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz /tmp/

# Download Spark package
ADD http://d3kbcqa49mib13.cloudfront.net/spark-1.4.0-bin-hadoop2.6.tgz /tmp/

# Create /opt directory
RUN mkdir -p /opt/

# Unpack hadoop into /opt/ and set HADOOP_HOME
RUN tar -xzf /tmp/hadoop-2.6.0.tar.gz -C /opt/

# Copy hadoop confs
ADD /hadoop-conf /opt/hadoop-2.6.0/etc/hadoop/

# Set Hadoop sepcific environment variables
ENV HADOOP_HOME /opt/hadoop-2.6.0
ENV HADOOP_CONF_DIR="${HADOOP_HOME}/etc/hadoop"
ENV HADOOP_LIBEXEC_DIR="${HADOOP_HOME}/libexec"

RUN sed -i 's/export JAVA_HOME=${JAVA_HOME}/export JAVA_HOME=\/usr\/lib\/jvm\/java-8-oracle/' /opt/hadoop-2.6.0/etc/hadoop/hadoop-env.sh

RUN mkdir -p /opt/data/apps/tmp
RUN mkdir -p /opt/data/apps/dfs/name
RUN mkdir -p /opt/data/apps/dfs/data

# Unpack spark into /opt and set SPARK_HOME
RUN tar -xzf /tmp/spark-1.4.0-bin-hadoop2.6.tgz -C /opt/
ENV SPARK_HOME /opt/spark-1.4.0-bin-hadoop2.6

ENV PATH $PATH:${HADOOP_HOME}/sbin/:${HADOOP_HOME}/bin:${SPARK_HOME}/sbin/:${SPARK_HOME}/bin

RUN ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''

COPY scripts /usr/bin/.

# Spark master port for job submission
EXPOSE 7077 
# Spark master REST interface port for job submission
EXPOSE 6066
# Spark master web port
EXPOSE 8080
# Spark worker web port
EXPOSE 8081
# HDFS Namenode web port
EXPOSE 50070 

ENTRYPOINT ["/usr/bin/bootstrap.sh"]
