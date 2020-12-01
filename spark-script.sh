#!/bin/bash
#Getting Cluster URL
port=6443
#To launch Spark job using spark-submit
cd /opt/spark
bin/spark-submit \
--master k8s://$clusterurl:$port \
--deploy-mode cluster \
--name spark-pi \
--class org.apache.spark.examples.SparkPi \
--conf spark.executor.instances=3 \
--conf spark.kubernetes.driver.request.cores=1 \
--conf spark.kubernetes.executor.request.cores=1 \
--conf spark.kubernetes.container.image=ilyassifez/bdataprojectpython:spark-testy \
--conf spark.kubernetes.container.image.pullPolicy=IfNotPresent \
--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
local:///opt/spark/examples/jars/spark-examples_2.12-3.0.1.jar
#Cleanup of spark job pods
# kubectl delete pods --all -n default
