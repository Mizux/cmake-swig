#!/usr/bin/env bash
set -x
set -e

function install-swig() {
  # Need SWIG >= 3.0.8
  cd /tmp/
  wget https://github.com/swig/swig/archive/rel-3.0.12.tar.gz
  tar zxf rel-3.0.12.tar.gz
  cd swig-rel-3.0.12
  ./autogen.sh
  ./configure --prefix "${HOME}"/swig/ 1>/dev/null
  make >/dev/null
  make install >/dev/null
}

function install-python(){
  python --version
  python -m pip --version
  python -m pip install virtualenv wheel six
}

function install-dotnet-sdk(){
  sudo apt-get install -yq apt-transport-https
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-trusty-prod trusty main" > dotnetdev.list
  sudo mv dotnetdev.list /etc/apt/sources.list.d/dotnetdev.list
  sudo apt-get update -qq
  sudo apt-get install -yq dotnet-sdk-2.1
}

eval "${MATRIX_EVAL}"

# apt-get only have swig 2.0.11
if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
  sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
  sudo apt-get update -qq
  # GCC 4.8 Fail with $ORIGIN
  sudo apt-get install -qq g++-6
  sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 90
  /usr/bin/x86_64-linux-gnu-ld --version
  if [[ "$LANGUAGE" != "cpp" ]]; then
    install-swig
  fi
  if [[ "$LANGUAGE" == "python2" ]]; then
    # work around https://github.com/travis-ci/travis-ci/issues/8363
    pyenv global 2.7
    install-python
  elif [[ "$LANGUAGE" == "python3" ]]; then
    # work around https://github.com/travis-ci/travis-ci/issues/8363
    pyenv global 3.6
    install-python
  elif [[ "$LANGUAGE" == "dotnet" ]]; then
    install-dotnet-sdk
  elif [[ "$LANGUAGE" == "java" ]]; then
    java -version
  fi
elif [ "$TRAVIS_OS_NAME" == "osx" ]; then
  brew update
  brew install swig
  if [[ "$LANGUAGE" == "python2" ]]; then
    brew outdated | grep -q python@2 && brew upgrade python@2
    python2 -m pip install virtualenv wheel six
  elif [[ "$LANGUAGE" == "python3" ]]; then
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
