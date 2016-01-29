# Docker compose for spawning on demand HDFS and Spark clusters

# Build the required Docker images
`./build-images.sh`

# Run the cluster
Note: Run below commands from the directory where `docker-compose.yml` file is present.
## bring up the cluster
`docker-compose up -d`
## stop the cluster
`docker-compose stop`
## restart the stopped cluster
`docker-compose start`
## remove containers
`docker-compose rm -f`
## to scale HDFS datanode or Spark worker containers
`docker-compose scale spark-slave=n` where n is the new number of containers.

## Attaching to cluster containers
  - HDFS NameNode container
    * Runs HDFS NameNode and DataNode services
    * `docker exec -it sparkdockercluster_hdfs-namenode_1 /bin/bash`
  - HDFS DataNode container(s)
    * Runs HDFS DataNode service
    * There could be multiple instances of this container. To connect to n'th container
      * `docker exec -it sparkdockercluster_hdfs-datanode__n_ /bin/bash`
  - Spark Master container
    * Runs Spark Master and Worker services
    * `docker exec -it sparkdockercluster_spark-master_1 /bin/bash`
  - Spark Worker container
    * Runs Spark Worker service
    * There could be multiple instances of this container. To connect to n'th container
      * `docker exec -it sparkdockercluster_spark-slave__n_ /bin/bash`
