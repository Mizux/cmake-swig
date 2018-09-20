FROM ubuntu:14.04
LABEL maintainer="mizux.dev@gmail.com"

# Base install
RUN apt-get update -qq \
&& apt-get install -yq git cmake3 build-essential \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
