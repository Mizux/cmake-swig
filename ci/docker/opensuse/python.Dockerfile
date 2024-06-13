FROM cmake-swig:opensuse_swig AS env
RUN zypper refresh \
&& zypper install -y python3 python3-pip python3-devel \
 python3-pip python3-wheel python3-virtualenv python3-setuptools \
&& zypper clean -a
RUN python3 -m pip install --break-system-packages \
 mypy

FROM env AS devel
WORKDIR /home/project
COPY . .

FROM devel AS build
RUN cmake -S. -Bbuild -DBUILD_PYTHON=ON
RUN cmake --build build --target all -v
RUN cmake --build build --target install

FROM build AS test
RUN CTEST_OUTPUT_ON_FAILURE=1 cmake --build build --target test

FROM env AS install_env
WORKDIR /home/sample
COPY --from=build /home/project/build/python/dist/*.whl .
RUN python3 -m pip install --break-system-packages *.whl

FROM install_env AS install_devel
COPY ci/samples/python .

FROM install_devel AS install_build
RUN python3 -m compileall .

FROM install_build AS install_test
RUN python3 sample.py
