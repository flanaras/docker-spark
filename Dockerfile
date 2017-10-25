FROM flanaras/docker-opensuse-java:leap-jre8
MAINTAINER flanaras

USER root
ENV USER root

# Spark dependencies-ish
RUN zypper in -y wget curl which tar sudo openssh rsync hostname

# SSH keys
## Server
RUN sshd-gen-keys-start
## Client
RUN ssh-keygen -q -N "" -t rsa -b 4096 -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

# Spark 2.2.0 with support for Hadoop 2.7.x
RUN curl -s https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz | tar -xz -C /usr/local/\
	&& cd /usr/local \
	&& ln -s spark-2.2.0-bin-hadoop2.7 spark
ENV SPARK_HOME /usr/local/spark
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh
ENV BOOTSTRAP /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]

# Spark job ui
EXPOSE 4040
# Spark standalone rest port
EXPOSE 6066
# Spark standalone master port
EXPOSE 7077
# Spark standalone cluster manager
EXPOSE 8080
# Spark spark history server ui
EXPOSE 18080
