FROM ubuntu:14.04
LABEL maintainer="mizux.dev@gmail.com"

# Base install
RUN apt-get update -qq \
&& apt-get install -yq git cmake3 build-essential \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Swig
RUN apt-get update -qq \
&& apt-get install -yq wget \
&& wget "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.12/swig-3.0.12.tar.gz" \
&& tar xvf swig-3.0.12.tar.gz && rm swig-3.0.12.tar.gz \
&& cd swig-3.0.12 && ./configure --prefix=/usr && make -j 4 && make install \
&& cd .. && rm -rf swig-3.0.12

# Dotnet install
RUN apt-get update -qq \
&& apt-get install -yq wget apt-transport-https \
&& wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb \
&& dpkg -i packages-microsoft-prod.deb \
&& apt-get update -qq \
&& apt-get install -yq dotnet-sdk-2.1 \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
