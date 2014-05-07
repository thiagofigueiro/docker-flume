FROM ubuntu
MAINTAINER Alex Wilson a.wilson@alumni.warwick.ac.uk

RUN apt-get update -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends \
  wget openjdk-7-jre-headless

RUN mkdir /opt/flume
RUN wget -qO- https://archive.apache.org/dist/flume/stable/apache-flume-1.4.0-bin.tar.gz | tar zxvf - -C /opt/flume --strip 1

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV PATH /opt/flume/bin:$PATH