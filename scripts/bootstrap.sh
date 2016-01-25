#!/bin/bash

# Start the SSH daemon
service ssh restart

# Setup password less ssh
sshpass -p screencast ssh-copy-id root@localhost

# Format the NameNode data directory
hdfs namenode -format

# Start HDFS services
start-dfs.sh

# Start spark master and worker services
start-master.sh
start-slave.sh spark://`hostname`:7077

bash
