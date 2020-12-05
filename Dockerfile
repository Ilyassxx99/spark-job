FROM python:slim-buster

RUN apt-get update
RUN apt-get install -y apt-utils build-essential gcc

ENV JAVA_FOLDER jdk1.8.0_221

ENV JVM_ROOT /usr/lib/jvm

ENV JAVA_PKG_NAME jdk-8u221-linux-x64.tar.gz
ENV JAVA_TAR_GZ_URL http://sd-127206.dedibox.fr/hagimont/software/$JAVA_PKG_NAME

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*    && \
    apt-get clean                                                               && \
    apt-get autoremove                                                          && \
    echo Downloading $JAVA_TAR_GZ_URL                                           && \
    wget -q $JAVA_TAR_GZ_URL                                                    && \
    tar -xvf $JAVA_PKG_NAME                                                     && \
    rm $JAVA_PKG_NAME                                                           && \
    mkdir -p /usr/lib/jvm                                                       && \
    mv ./$JAVA_FOLDER $JVM_ROOT                                                 && \
    update-alternatives --install /usr/bin/java java $JVM_ROOT/$JAVA_FOLDER/bin/java 1        && \
    update-alternatives --install /usr/bin/javac javac $JVM_ROOT/$JAVA_FOLDER/bin/javac 1     && \
    java -version

ENV JAVA_HOME $JVM_ROOT/$JAVA_FOLDER

RUN mkdir -p /opt/spark && mkdir /scripts

COPY jars /opt/spark/jars
COPY bin /opt/spark/bin
COPY sbin /opt/spark/sbin
COPY data /opt/spark/data
COPY conf /opt/spark/conf

ENV SPARK_HOME /opt/spark

# install boto3
RUN pip3 install boto3
RUN pip3 install paramiko


# add scripts and update spark default config
WORKDIR /scripts
COPY spark-script.sh /scripts
COPY main.py /scripts
RUN chmod +x spark-script.sh
ENV PATH $PATH:/opt/spark/bin:$JAVA_HOME/bin
