#!/bin/bash

# Script to build all required images for running HDFS and Spark clusters
# Usage:
# <HOME>/build-images.sh [scratch]
# Options argument scratch for deleting existing images and building the images from scratch

if [ "$1" == scratch ]; then
  docker rmi -f hadoop-spark hdfs-namenode hdfs-datanode spark-master spark-slave
fi
docker build -t hadoop-spark ./hadoop-spark/
docker build -t hdfs-namenode ./hdfs-namenode/
docker build -t hdfs-datanode ./hdfs-datanode/
docker build -t spark-master ./spark-master/
docker build -t spark-slave ./spark-slave/
