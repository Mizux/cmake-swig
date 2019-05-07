FROM centos:7
LABEL maintainer="mizux.dev@gmail.com"

# Base install
RUN yum -y update \
&& yum -y groupinstall 'Development Tools' \
&& yum clean all \
&& rm -rf /var/cache/yum
# Install CMake
RUN wget "https://cmake.org/files/v3.8/cmake-3.8.2-Linux-x86_64.sh" \
&& chmod 775 cmake-3.8.2-Linux-x86_64.sh \
&& yes | ./cmake-3.8.2-Linux-x86_64.sh --prefix=/usr --exclude-subdir

# Swig install
RUN wget "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.12/swig-3.0.12.tar.gz" \
&& tar xvf swig-3.0.12.tar.gz \
&& rm swig-3.0.12.tar.gz \
&& cd swig-3.0.12 \
&& ./configure --prefix=/usr \
&& make -j 4 \
&& make install \
&& cd .. \
&& rm -rf swig-3.0.12

# Python install
RUN yum -y update \
&& yum -y install python-devel python-setuptools python-six python-wheel \
&& yum clean all \
&& rm -rf /var/cache/yum

# Java install
RUN yum -y update \
&& yum -y install java-1.8.0-openjdk  java-1.8.0-openjdk-devel \
&& yum clean all \
&& rm -rf /var/cache/yum

# .Net install
RUN rpm -Uvh "https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm" \
&& yum -y update \
&& yum -y install dotnet-sdk-2.1 \
&& yum clean all \
&& rm -rf /var/cache/yum
