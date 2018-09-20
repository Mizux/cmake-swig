FROM alpine:latest
LABEL maintainer="mizux.dev@gmail.com"

# Base install
RUN apk add --no-cache git cmake build-base linux-headers

# Swig install
RUN apk add --no-cache swig

# Python install
RUN apk add --no-cache python3-dev py3-virtualenv \
&& python3 -m pip install wheel

# Java install
RUN apk add --no-cache openjdk8

# .Net install
ENV DOTNET_SDK_VERSION 2.1.402
RUN apk add --no-cache icu-libs libintl \
&& apk add --no-cache --virtual .build-deps openssl \
&& wget -O dotnet.tar.gz https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-musl-x64.tar.gz \
&& dotnet_sha512='88309e5ddc1527f8ad19418bc1a628ed36fa5b21318a51252590ffa861e97bd4f628731bdde6cd481a1519d508c94960310e403b6cdc0e94c1781b405952ea3a' \
&& echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
&& mkdir -p /usr/share/dotnet \
&& tar -C /usr/share/dotnet -xzf dotnet.tar.gz \
&& rm dotnet.tar.gz \
&& ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
&& apk del .build-deps
RUN dotnet --info
