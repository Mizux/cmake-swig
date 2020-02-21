# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/r/opensuse/tumbleweed
FROM opensuse/tumbleweed AS env
LABEL maintainer="mizux.dev@gmail.com"
# Install system build dependencies
ENV PATH=$PATH:/usr/local/bin
RUN zypper up -y \
&& zypper install -y git gcc gcc-c++ cmake \
&& zypper clean -a
ENV CC=gcc CXX=g++
CMD [ "/bin/sh" ]



# Add the library src to our build env
FROM env AS cpp
# Create lib directory
WORKDIR /home/lib
# Bundle lib source
COPY . .
# CMake version
RUN cmake -version
# CMake configure
RUN cmake -S. -Bbuild
# CMake build
RUN cmake --build build --target all -v
# CMake build
RUN cmake --build build --target install



FROM env AS python
# Swig install
RUN zypper up -y \
&& zypper install -y swig \
&& zypper clean -a
# Python install
RUN zypper up -y \
&& zypper install -y python3 python3-pip python3-devel \
&& zypper clean -a
# Create lib directory
WORKDIR /home/lib
# Bundle lib source
COPY . .
# CMake configure
RUN cmake -S. -Bbuild -DBUILD_PYTHON=ON
# CMake build
RUN cmake --build build --target all -v
# CMake build
RUN cmake --build build --target install



FROM env AS java
# Swig install
RUN zypper up -y \
&& zypper install -y swig \
&& zypper clean -a
# Java install
RUN zypper up -y \
&& zypper install -y openjdk \
&& zypper clean -a
# Create lib directory
WORKDIR /home/lib
# Bundle lib source
COPY . .
# CMake configure
RUN cmake -S. -Bbuild -DBUILD_JAVA=ON
# CMake build
RUN cmake --build build --target all -v
# CMake build
RUN cmake --build build --target install




FROM env AS dotnet
# Swig install
RUN zypper up -y \
&& zypper install -y swig \
&& zypper clean -a
# .Net install
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-package-manager-opensuse15
RUN zypper up -y \
&& zypper install -y dotnet-sdk \
&& zypper clean -a
# Trigger first run experience by running arbitrary cmd
RUN dotnet --info
# Create lib directory
WORKDIR /home/lib
# Bundle lib source
COPY . .
# CMake configure
RUN cmake -S. -Bbuild -DBUILD_DOTNET=ON
# CMake build
RUN cmake --build build --target all -v
# CMake build
RUN cmake --build build --target install



# Create an install image
FROM env AS install
# Copy lib from devel to prod
COPY --from=cpp /usr/local /usr/local/
# Copy  sample
WORKDIR /home/sample
COPY ci/sample .
