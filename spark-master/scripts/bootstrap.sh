#!/bin/bash

# Start the SSH daemon
service ssh restart

# Setup password less ssh
sshpass -p screencast ssh-copy-id root@localhost

export HOSTNAME=`hostname`
sed -i "s#localhost#$HOSTNAME#g" /opt/hadoop-2.6.0/etc/hadoop/core-site.xml

# Format the NameNode data directory
hdfs namenode -format

# Start HDFS services
start-dfs.sh

# Start spark master and worker services
start-master.sh
start-slave.sh spark://`hostname`:7077

bash
