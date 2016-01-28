# spark-docker-compose
Spark + HDFS cluster using docker compose

# build
`./build-images.sh`

# run
Note: Run below commands from the directory where `docker-compose.yml` file is present.
## bring up the cluster
`docker-compose up -d`
## stop the cluster
`docker-compose stop`
## restart the stopped cluster
`docker-compose start`
## remove containers
`docker-compose rm -f`

## attaching to cluster containers
#### master container which is running the HDFS NameNode/DataNode and Spark Master/Worker services
`docker exec -it sparkdockercluster_spark-master_1 /bin/bash`

#### slave container which is running the HDFS DataNode and Spark Worker services
`docker exec -it sparkdockercluster_spark-slave_1 /bin/bash`

