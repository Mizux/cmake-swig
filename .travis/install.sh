#!/usr/bin/env bash
set -x
set -e

function install-swig() {
  # Need SWIG >= 3.0.8
  cd /tmp/
  wget https://github.com/swig/swig/archive/rel-4.0.1.tar.gz
  tar zxf rel-4.0.1.tar.gz
  cd swig-rel-4.0.1
  ./autogen.sh
  ./configure --prefix "${HOME}"/swig/ 1>/dev/null
  make >/dev/null
  make install >/dev/null
}

function install-python(){
  # work around https://github.com/travis-ci/travis-ci/issues/8363
  pyenv global 3.7
  python --version
  python -m pip --version
  python -m pip install virtualenv wheel six
}

# see https://docs.microsoft.com/en-us/dotnet/core/install/linux-package-manager-ubuntu-1804
function install-dotnet-sdk(){
  sudo apt-get install -yq apt-transport-https
  wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
  sudo dpkg -i packages-microsoft-prod.deb
  sudo apt-get update -qq
  sudo apt-get install -yq dotnet-sdk-3.1
}

eval "${MATRIX_EVAL}"

# apt-get only have swig 2.0.11
if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
  /usr/bin/x86_64-linux-gnu-ld --version
  if [[ "$LANGUAGE" != "cpp" ]]; then
    install-swig
  fi
  if [[ "$LANGUAGE" == "python" ]]; then
    install-python
  elif [[ "$LANGUAGE" == "dotnet" ]]; then
    install-dotnet-sdk
  elif [[ "$LANGUAGE" == "java" ]]; then
    java -version
  fi
elif [ "$TRAVIS_OS_NAME" == "osx" ]; then
  brew update
  brew install swig
  if [[ "$LANGUAGE" == "python" ]]; then
    brew upgrade python
    python3 -m pip install virtualenv wheel six
  elif [[ "$LANGUAGE" == "dotnet" ]]; then
    brew tap caskroom/cask
    brew cask install dotnet-sdk
  elif [[ "$LANGUAGE" == "java" ]]; then
    brew cask install java
  fi
fi
# vim: set tw=0 ts=2 sw=2 expandtab:
