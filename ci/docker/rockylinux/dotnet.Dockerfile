FROM cmake-swig:rockylinux_swig AS env

# Install .NET SDK
# see: https://learn.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install
RUN wget -q "https://dot.net/v1/dotnet-install.sh" \
&& chmod a+x dotnet-install.sh \
&& ./dotnet-install.sh -c 3.1 -i /usr/local/bin \
&& ./dotnet-install.sh -c 8.0 -i /usr/local/bin
# Trigger first run experience by running arbitrary cmd
RUN dotnet --info

# Add the library src to our build env
FROM env AS devel
WORKDIR /home/project
COPY . .

FROM devel AS build
RUN cmake -version
RUN cmake -S. -Bbuild -DBUILD_DOTNET=ON
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
