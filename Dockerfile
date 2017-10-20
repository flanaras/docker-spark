FROM openjdk:8-jre
MAINTAINER flanaras

# Spark 2.2.0 with support for Hadoop 2.7.x
RUN curl https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz | tar -xz -C /usr/local/
RUN cd /usr/local \
	&& ln -s spark-2.2.0-bin-hadoop2.7 spark

ENV SPARK_HOME /usr/local/spark
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

ENTRYPOINT ["/bin/bash"]
