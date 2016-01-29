#!/bin/bash

# Start the SSH daemon
service ssh restart

# Setup password less ssh
sshpass -p screencast ssh-copy-id root@localhost

# Replace "localhost" in Hadoop core-site xml with actual hostname which is passed
# as NAMENODE_HOSTNAME env variable
sed -i "s#localhost#$NAMENODE_HOSTNAME#g" /opt/hadoop-2.6.0/etc/hadoop/core-site.xml

# Start spark worker service
start-slave.sh spark://$MASTER_HOSTNAME:7077

# Run in daemon mode, don't exit
while true; do
  sleep 100;
done
