FROM cmake-swig:centos_swig AS env
# Install dotnet
# see https://docs.microsoft.com/en-us/dotnet/core/install/linux-rhel#supported-distributions

# Microsoft/RHEL fail the net6.0 release, need this 2 lines
# ref: https://docs.microsoft.com/en-us/dotnet/core/install/linux-rhel#supported-distributions
RUN rpm -Uvh https://packages.microsoft.com/config/centos/8/packages-microsoft-prod.rpm
RUN echo 'priority=50' | tee -a /etc/yum.repos.d/microsoft-prod.repo

RUN dnf -y update \
&& dnf -y install dotnet-sdk-3.1 dotnet-sdk-6.0 dotnet-runtime-6.0 \
&& dnf clean all \
&& rm -rf /var/cache/dnf
# Trigger first run experience by running arbitrary cmd
RUN dotnet --info

FROM env AS devel
WORKDIR /home/project
COPY . .

FROM devel AS build
RUN cmake -S. -Bbuild -DBUILD_DOTNET=ON
RUN cmake --build build --target all -v
RUN cmake --build build --target install -v

FROM build AS test
RUN cmake --build build --target test

FROM env AS install_env
WORKDIR /home/sample
COPY --from=build /home/project/build/dotnet/packages/*.nupkg ./

FROM install_env AS install_devel
COPY ci/samples/dotnet .

FROM install_devel AS install_build
RUN dotnet build

FROM install_build AS install_test
RUN dotnet run
