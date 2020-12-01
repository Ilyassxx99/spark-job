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
--conf spark.kubernetes.container.image.pullPolicy=Always \
--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
--conf spark.eventLog.enabled=true \
--conf spark.eventLog.dir=/opt/spark/work-dir \
--conf spark.kubernetes.driver.volumes.persistentVolumeClaim.spark-volume-claim.options.claimName=spark-volume-claim \
--conf spark.kubernetes.driver.volumes.persistentVolumeClaim.spark-volume-claim.mount.path=/opt/spark/work-dir \
--conf spark.kubernetes.executor.volumes.persistentVolumeClaim.spark-volume-claim.options.claimName=spark-volume-claim \
--conf spark.kubernetes.executor.volumes.persistentVolumeClaim.spark-volume-claim.mount.path=/opt/spark/work-dir \
local:///opt/spark/jobs/WordCount.jar
#Cleanup of spark job pods
# kubectl delete pods --all -n default
