FROM cmake-swig:ubuntu_swig AS env

# Install .NET SDK
# see: https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu
# note: Ubuntu 22.04+ won't support .Net SDK 3.1 since it doesn't use OpenSSL 3
# see: https://github.com/dotnet/core/issues/7038#issuecomment-1110377345
RUN apt-get update -qq \
&& apt-get install -yq dotnet-sdk-6.0 \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Trigger first run experience by running arbitrary cmd
RUN dotnet --info

FROM env AS devel
WORKDIR /home/project
COPY . .

FROM devel AS build
RUN cmake --version
RUN cmake -S. -Bbuild -DBUILD_DOTNET=ON -DUSE_DOTNET_CORE_31=OFF
RUN cmake --build build --target all -v
RUN cmake --build build --target install -v

FROM build AS test
RUN CTEST_OUTPUT_ON_FAILURE=1 cmake --build build --target test -v

FROM env AS install_env
WORKDIR /home/sample
COPY --from=build /home/project/build/dotnet/packages/*.nupkg ./

FROM install_env AS install_devel
COPY ci/samples/dotnet .

FROM install_devel AS install_build
RUN dotnet build

FROM install_build AS install_test
RUN dotnet run
