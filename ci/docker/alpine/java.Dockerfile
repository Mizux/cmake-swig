FROM cmake-swig:alpine_swig AS env

RUN apk add --no-cache openjdk11 maven
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

FROM env AS devel
WORKDIR /home/project
COPY . .

FROM devel AS build
RUN cmake -S. -Bbuild -DBUILD_JAVA=ON -DSKIP_GPG=ON
RUN cmake --build build --target all -v
RUN cmake --build build --target install

FROM build AS test
RUN CTEST_OUTPUT_ON_FAILURE=1 cmake --build build --target test

FROM env AS install_env
COPY --from=build /usr/local /usr/local/

FROM install_env AS install_devel
WORKDIR /home/sample
COPY ci/samples/java .

FROM install_devel AS install_build
RUN mvn compile

FROM install_build AS install_test
RUN mvn test
