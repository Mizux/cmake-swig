FROM ubuntu:16.04
LABEL maintainer="mizux.dev@gmail.com"

# Base install
RUN apt-get update -qq \
&& apt-get install -yq git cmake build-essential \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Swig
RUN apt-get update -qq \
&& apt-get install -yq swig \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Python install
RUN apt-get update -qq \
&& apt-get install -yq python3-dev python3-pip \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Java install
RUN apt-get update -qq \
&& apt-get install -yq default-jdk \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Dotnet install
RUN apt-get update -qq \
&& apt-get install -yq wget apt-transport-https \
&& wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb \
&& dpkg -i packages-microsoft-prod.deb \
&& apt-get update -qq \
&& apt-get install -yq dotnet-sdk-2.1 \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
