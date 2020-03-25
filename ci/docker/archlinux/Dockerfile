# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/archlinux/
FROM archlinux/base AS base
LABEL maintainer="mizux.dev@gmail.com"
# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN pacman -Syu --noconfirm git base-devel cmake
CMD [ "/bin/sh" ]

FROM base AS swig
RUN pacman -Syu --noconfirm swig

################### C++
FROM cmake-swig:archlinux_base AS env
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
FROM cmake-swig:archlinux_swig AS env
RUN pacman -Syu --noconfirm python python-pip

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
FROM cmake-swig:archlinux_swig AS env
RUN pacman -Syu --noconfirm jdk-openjdk maven

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
FROM cmake-swig:archlinux_swig AS env
RUN pacman -Syu --noconfirm dotnet-sdk

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
