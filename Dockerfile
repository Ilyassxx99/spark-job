FROM rappdw/docker-java-python:latest

RUN mkdir -p /opt/spark && mkdir /scripts

COPY jars /opt/spark/jars
COPY bin /opt/spark/bin
COPY sbin /opt/spark/sbin
COPY data /opt/spark/data
COPY conf /opt/spark/conf

ENV SPARK_HOME /opt/spark

# install boto3
RUN pip3 install boto3


# add scripts and update spark default config
WORKDIR /scripts
COPY spark-script.sh /scripts
COPY main.py /scripts
RUN chmod +x spark-script.sh
ENV PATH $PATH:/opt/spark/bin
