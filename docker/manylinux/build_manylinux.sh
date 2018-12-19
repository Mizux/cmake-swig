#!/bin/bash
set -x
set -e

PATH_BCKP=$PATH
echo "PATH: $PATH_BCKP"
for PYROOT in /opt/python/*
do
  PYTAG=$(basename "${PYROOT}")
  echo "$PYTAG"
  PATH=${PYROOT}:${PATH_BCKP}
  cmake -H. -Bcache/manylinux/build_$PYTAG -DBUILD_PYTHON=ON
done



