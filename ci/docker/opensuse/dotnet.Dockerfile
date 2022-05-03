FROM cmake-swig:opensuse_swig AS env
# see: https://docs.microsoft.com/en-us/dotnet/core/install/linux-opensuse
RUN zypper update -y \
&& zypper install -y wget tar gzip libicu

# .NET install
RUN wget https://packages.microsoft.com/keys/microsoft.asc \
&& rpm --import microsoft.asc \
&& rm microsoft.asc
RUN wget https://packages.microsoft.com/config/opensuse/15/prod.repo \
&& mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo \
&& chown root:root /etc/zypp/repos.d/microsoft-prod.repo
RUN zypper install -y dotnet-sdk-3.1 dotnet-sdk-6.0
# Trigger first run experience by running arbitrary cmd
RUN dotnet --info

FROM env AS devel
WORKDIR /home/project
COPY . .

FROM devel AS build
RUN cmake -S. -Bbuild -DBUILD_DOTNET=ON
RUN cmake --build build --target all -v
RUN cmake --build build --target install

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
