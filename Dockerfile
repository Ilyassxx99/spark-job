# base image
FROM ubuntu:latest

# define spark and hadoop versions
ENV SPARK_VERSION=3.0.0
ENV HADOOP_VERSION=3.3.0

# update repositories
RUN apt-get update
RUN apt-get install -y curl

# download and install java
RUN apt-get install -y openjdk-8-jdk
RUN export JAVA_HOME=$(readlink -f $(which java))

# download and install hadoop
RUN mkdir -p /opt && \
    cd /opt && \
    curl http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | \
        tar -zx hadoop-${HADOOP_VERSION}/lib/native && \
    ln -s hadoop-${HADOOP_VERSION} hadoop && \
    echo Hadoop ${HADOOP_VERSION} native libraries installed in /opt/hadoop/lib/native

# download and install spark
RUN mkdir -p /opt && \
    cd /opt && \
    curl http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz | \
        tar -zx && \
    ln -s spark-${SPARK_VERSION}-bin-hadoop2.7 spark && \
    echo Spark ${SPARK_VERSION} installed in /opt

# download and install python
RUN apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev && \
    curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz && \
    tar -xf Python-3.8.2.tar.xz && \
    cd Python-3.8.2 && \
    ./configure --enable-optimizations && \
    make -j 4 && \
    make altinstall

# install boto3
RUN pip3.8 install boto3

# add scripts and update spark default config
RUN mkdir /scripts
WORKDIR /scripts
COPY spark-script.sh /scripts
COPY main.py /scripts
RUN chmod +x spark-script.sh
ENV PATH $PATH:/opt/spark/bin
