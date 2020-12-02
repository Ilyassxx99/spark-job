FROM rappdw/docker-java-python:latest

RUN python --version
RUN java -version

RUN mkdir -p /opt/spark && mkdir /scripts

COPY /home/ilyass/spark-3.0.1-bin-hadoop2.7/jars /opt/spark/jars
COPY /home/ilyass/spark-3.0.1-bin-hadoop2.7/bin /opt/spark/bin
COPY /home/ilyass/spark-3.0.1-bin-hadoop2.7/sbin /opt/spark/sbin
COPY /home/ilyass/spark-3.0.1-bin-hadoop2.7/data /opt/spark/data

ENV SPARK_HOME /opt/spark

# install boto3
RUN pip3.8 install boto3


# add scripts and update spark default config
WORKDIR /scripts
COPY spark-script.sh /scripts
COPY main.py /scripts
COPY pod.yaml /scripts
RUN chmod +x spark-script.sh
ENV PATH $PATH:/opt/spark/bin
