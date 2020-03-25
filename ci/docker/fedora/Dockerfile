# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/fedora
FROM fedora:latest AS env
LABEL maintainer="mizux.dev@gmail.com"
# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN dnf -y update \
&& dnf -y install git wget \
&& dnf -y groupinstall "Development Tools" \
&& dnf -y install gcc-c++ cmake \
&& dnf clean all
CMD [ "/bin/sh" ]

FROM base AS swig
RUN dnf -y update \
&& dnf -y install swig \
&& dnf clean all

################### C++
FROM cmake-swig:fedora_base AS env
RUN cmake -version

FROM env AS devel
WORKDIR /home/lib
COPY . .

FROM devel AS build
RUN cmake -S. -Bbuild
RUN cmake --build build --target all -v
RUN cmake --build build --target install

FROM build AS test
RUN cmake --build build --target test

FROM env AS install_env
COPY --from=build /usr/local /usr/local/

FROM install_env AS install_devel
WORKDIR /home/sample
COPY ci/sample .

FROM install_devel AS install_build
RUN cmake -S. -Bbuild
RUN cmake --build build --target all -v
RUN cmake --build build --target install

FROM install_build AS install_test
RUN cmake --build build --target test

##################### Python
FROM cmake-swig:fedora_swig AS env
RUN dnf -y update \
&& dnf -y install python3 python3-devel python3-pip \
&& dnf clean all

FROM env AS devel
WORKDIR /home/lib
COPY . .

FROM devel AS build
RUN cmake -S. -Bbuild -DBUILD_PYTHON=ON
RUN cmake --build build --target all -v
RUN cmake --build build --target install

FROM build AS test
RUN cmake --build build --target test

FROM env AS install_env
COPY --from=build /usr/local /usr/local/

FROM install_env AS install_devel
WORKDIR /home/sample
COPY ci/sample .

FROM install_devel AS install_build
RUN cmake -S. -Bbuild
RUN cmake --build build --target all -v
RUN cmake --build build --target install

FROM install_build AS install_test
RUN cmake --build build --target test

###################### JAVA
FROM cmake-swig:fedora_swig AS env
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
RUN dnf -y update \
&& dnf -y install java-1.8.0-openjdk-devel maven \
&& dnf clean all

FROM env AS devel
WORKDIR /home/lib
COPY . .

FROM devel AS build
RUN cmake -S. -Bbuild -DBUILD_JAVA=ON
RUN cmake --build build --target all -v
RUN cmake --build build --target install

FROM build AS test
RUN cmake --build build --target test

FROM env AS install_env
COPY --from=build /usr/local /usr/local/

FROM install_env AS install_devel
WORKDIR /home/sample
COPY ci/sample .

FROM install_devel AS install_build
RUN cmake -S. -Bbuild -DBUILD_DOTNET=ON
RUN cmake --build build --target all -v
RUN cmake --build build --target install

FROM install_build AS install_test
RUN cmake --build build --target test

###################### dotnet
FROM cmake-swig:fedora_swig AS env
# see: https://docs.microsoft.com/en-us/dotnet/core/install/linux-package-manager-fedora31
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc \
&& wget -q -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/31/prod.repo \
&& dnf -y update \
&& dnf -y install dotnet-sdk-3.1 \
&& dnf clean all
# Trigger first run experience by running arbitrary cmd
RUN dotnet --info

FROM env AS devel
WORKDIR /home/lib
COPY . .

FROM devel AS build
RUN cmake -S. -Bbuild -DBUILD_DOTNET=ON
RUN cmake --build build --target all -v
RUN cmake --build build --target install

FROM build AS test
RUN cmake --build build --target test

FROM env AS install_env
COPY --from=build /usr/local /usr/local/

FROM install_env AS install_devel
WORKDIR /home/sample
COPY ci/sample .

FROM install_devel AS install_build
RUN cmake -S. -Bbuild -DBUILD_DOTNET=ON
RUN cmake --build build --target all -v
RUN cmake --build build --target install

FROM install_build AS install_test
RUN cmake --build build --target test
