#!/bin/bash

# Start the SSH daemon
service ssh restart

# Setup password less ssh
sshpass -p screencast ssh-copy-id root@localhost

sed -i "s#localhost#$MASTER_IP#g" /opt/hadoop-2.6.0/etc/hadoop/core-site.xml

# Start Datanode
hadoop-daemon.sh start datanode

# Start spark worker service
start-slave.sh spark://`echo $MASTER_IP`:7077

bash
