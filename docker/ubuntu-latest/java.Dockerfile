FROM ubuntu:latest
LABEL maintainer="mizux.dev@gmail.com"

# Base install
RUN apt-get update -qq \
&& apt-get install -yq git cmake build-essential \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Java install
RUN apt-get update -qq \
&& apt-get install -yq default-jdk \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
