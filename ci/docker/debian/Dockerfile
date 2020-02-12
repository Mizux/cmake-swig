# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/debian
FROM debian:latest AS env
LABEL maintainer="mizux.dev@gmail.com"
# Install system build dependencies
ENV PATH=$PATH:/usr/local/bin
RUN apt-get update -qq \
&& apt-get install -yq git build-essential cmake \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD [ "/bin/sh" ]




# Add the library src to our build env
FROM env AS cpp
# Create lib directory
WORKDIR /home/lib
# Bundle lib source
COPY . .
# CMake configure
RUN cmake -S. -Bbuild
# CMake build
RUN cmake --build build --target all
# CMake build
RUN cmake --build build --target install



FROM env AS python
# Swig install
RUN apt-get update -qq \
&& apt-get install -yq swig \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Python install
RUN apt-get update -qq \
&& apt-get install -yq python3-dev python3-pip \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Create lib directory
WORKDIR /home/lib
# Bundle lib source
COPY . .
# CMake configure
RUN cmake -S. -Bbuild -DBUILD_PYTHON=ON
# CMake build
RUN cmake --build build --target all
# CMake build
RUN cmake --build build --target install



FROM env AS java
# Swig install
RUN apt-get update -qq \
&& apt-get install -yq swig \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Java install
RUN apt-get update -qq \
&& apt-get install -yq default-jdk \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Create lib directory
WORKDIR /home/lib
# Bundle lib source
COPY . .
# CMake configure
RUN cmake -S. -Bbuild -DBUILD_JAVA=ON
# CMake build
RUN cmake --build build --target all
# CMake build
RUN cmake --build build --target install




FROM env AS dotnet
# Swig install
RUN apt-get update -qq \
&& apt-get install -yq swig \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# .Net install
RUN apt-get update -qq \
&& apt-get install -yq wget gpg apt-transport-https \
&& wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
&& mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
&& wget -q https://packages.microsoft.com/config/debian/10/prod.list \
&& mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
&& apt-get update -qq \
&& apt-get install -yq dotnet-sdk-3.1 \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Trigger first run experience by running arbitrary cmd
RUN dotnet --info
# Create lib directory
WORKDIR /home/lib
# Bundle lib source
COPY . .
# CMake configure
RUN cmake -S. -Bbuild -DBUILD_DOTNET=ON
# CMake build
RUN cmake --build build --target all
# CMake build
RUN cmake --build build --target install



# Create an install image
FROM env AS install
# Copy lib from devel to prod
COPY --from=cpp /usr/local /usr/local/
# Copy  sample
WORKDIR /home/sample
COPY ci/sample .
