FROM debian:jessie
MAINTAINER Thiago Figueiro thiagocsf@gmail.com
ENV FLUME_VERSION 1.6.0
ENV FLUME_HOME /opt/flume
ENV HADOOP_VERSION 2.7.1

RUN apt-get update && apt-get install -q -y --no-install-recommends wget netcat

RUN mkdir /opt/java
RUN wget --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" -qO- \
  http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jre-8u77-linux-x64.tar.gz \
  | tar zxvf - -C /opt/java --strip 1

RUN mkdir $FLUME_HOME
RUN wget -qO- http://archive.apache.org/dist/flume/$FLUME_VERSION/apache-flume-"$FLUME_VERSION"-bin.tar.gz \
  | tar zxvf - -C $FLUME_HOME --strip 1

# TODO: try and pick only the needed dependencies to use a hdfs sink
RUN wget -q http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-"$HADOOP_VERSION".tar.gz && \
  tar zxf hadoop-"$HADOOP_VERSION".tar.gz hadoop-"$HADOOP_VERSION"/share/hadoop/common && \
  find hadoop-"$HADOOP_VERSION" -regex ".*\.jar" -type f -exec mv -f {} /opt/flume/lib/ \; && \
  rm -rf hadoop-"$HADOOP_VERSION"*
RUN cd $FLUME_HOME/lib && wget -q http://central.maven.org/maven2/org/apache/hadoop/hadoop-hdfs/2.7.1/hadoop-hdfs-2.7.1.jar

ENV FLUME_AGENT_NAME a1
ENV FLUME_CONF_DIR /opt/flume/conf
ENV FLUME_CONF_FILE $FLUME_CONF_DIR/example-a1.conf

ADD example-a1.conf $FLUME_CONF_DIR/example-a1.conf
ADD start-flume.sh /opt/flume/bin/start-flume

ENV JAVA_HOME /opt/java
ENV PATH /opt/flume/bin:/opt/java/bin:$PATH

CMD [ "start-flume" ]
