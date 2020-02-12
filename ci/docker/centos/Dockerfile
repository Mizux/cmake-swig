# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/centos
FROM centos:latest AS env
LABEL maintainer="mizux.dev@gmail.com"
# Install system build dependencies
ENV PATH=$PATH:/usr/local/bin
RUN yum -y update \
&& yum -y install git \
&& yum -y groupinstall "Development Tools" \
&& yum -y install epel-release \
&& yum -y install cmake3 \
&& ln -s /usr/bin/cmake3 /usr/local/bin/cmake \
&& yum clean all \
&& rm -rf /var/cache/yum
CMD [ "/bin/sh" ]



# Add the library src to our build env
FROM env AS cpp
# Create lib directory
WORKDIR /home/lib
# Bundle lib source
COPY . .
# CMake configure
RUN cmake -H. -Bbuild
# CMake build
RUN cmake --build build --target all
# CMake build
RUN cmake --build build --target install



# Add the library src to our build env
FROM env AS python
# Swig install
RUN wget "https://downloads.sourceforge.net/project/swig/swig/swig-4.0.1/swig-4.0.1.tar.gz" \
&& tar xvf swig-4.0.1.tar.gz \
&& rm swig-4.0.1.tar.gz \
&& cd swig-4.0.1 \
&& ./configure --prefix=/usr \
&& make -j 4 \
&& make install \
&& cd .. \
&& rm -rf swig-4.0.1
# Python install
RUN yum -y update \
&& yum -y install python-devel python-setuptools python-six python-wheel \
&& yum clean all \
&& rm -rf /var/cache/yum
# Create lib directory
WORKDIR /home/lib
# Bundle lib source
COPY . .
# CMake configure
RUN cmake -H. -Bbuild -DBUILD_PYTHON=ON
# CMake build
RUN cmake --build build --target all
# CMake build
RUN cmake --build build --target install



# Add the library src to our build env
FROM env AS java
# Swig install
RUN wget "https://downloads.sourceforge.net/project/swig/swig/swig-4.0.1/swig-4.0.1.tar.gz" \
&& tar xvf swig-4.0.1.tar.gz \
&& rm swig-4.0.1.tar.gz \
&& cd swig-4.0.1 \
&& ./configure --prefix=/usr \
&& make -j 4 \
&& make install \
&& cd .. \
&& rm -rf swig-4.0.1
# Java install
RUN yum -y update \
&& yum -y install java-1.8.0-openjdk  java-1.8.0-openjdk-devel \
&& yum clean all \
&& rm -rf /var/cache/yum
# Create lib directory
WORKDIR /home/lib
# Bundle lib source
COPY . .
# CMake configure
RUN cmake -H. -Bbuild -DBUILD_JAVA=ON
# CMake build
RUN cmake --build build --target all
# CMake build
RUN cmake --build build --target install



# Add the library src to our build env
FROM env AS dotnet
# Swig install
RUN wget "https://downloads.sourceforge.net/project/swig/swig/swig-4.0.1/swig-4.0.1.tar.gz" \
&& tar xvf swig-4.0.1.tar.gz \
&& rm swig-4.0.1.tar.gz \
&& cd swig-4.0.1 \
&& ./configure --prefix=/usr \
&& make -j 4 \
&& make install \
&& cd .. \
&& rm -rf swig-4.0.1
# .Net install
RUN rpm -Uvh "https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm" \
&& yum -y update \
&& yum -y install dotnet-sdk-3.1 \
&& yum clean all \
&& rm -rf /var/cache/yum
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
FROM env AS install_cpp
# Copy lib from devel to prod
COPY --from=cpp /usr/local /usr/local/
# Copy  sample
WORKDIR /home/sample
COPY ci/sample .
