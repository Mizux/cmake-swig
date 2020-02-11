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
