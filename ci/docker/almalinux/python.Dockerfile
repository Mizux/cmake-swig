FROM cmake-swig:almalinux_swig AS env

ENV PATH=/root/.local/bin:$PATH
RUN dnf -y update \
&& dnf -y install python3-devel python3-pip python3-numpy \
&& dnf clean all \
&& rm -rf /var/cache/dnf
RUN python3 -m pip install \
 mypy pandas

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
RUN python3 -m pip install *.whl

FROM install_env AS install_devel
COPY ci/samples/python .

FROM install_devel AS install_build
RUN python3 -m compileall .

FROM install_build AS install_test
RUN python3 sample.py
