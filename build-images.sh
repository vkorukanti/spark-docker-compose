# Script to build all required images for running a Spark+HDFS cluster
# Usage:
# <HOME>/build-images.sh [scratch]
# Options argument scratch for deleting existing images and building the images from scratch

if [ "$1" == scratch ]; then
  docker rmi -f hadoop-spark spark-master spark-slave
fi
docker build -t hadoop-spark ./hadoop-spark/
docker build -t spark-master ./spark-master/
docker build -t spark-slave ./spark-slave/
