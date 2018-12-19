# General commands
.PHONY: help
help:
	@echo "Tools to test build on various linux distros"
	@echo "Usage:"
	@echo "  make <command> [options]"
	@echo ""
	@echo "Commands:"
	@echo "  help: Print this help."
	@echo ""
	@echo "  docker: Generate docker build image for all distro"
	@echo "  docker_<distro>: Build docker build image for the specified <distro>."
	@echo "  bash_<distro>: Run an interactive shell container using the docker_<distro> image."
	@echo ""
	@echo "  configure: Run 'cmake configure' for all distro"
	@echo "  configure_<distro>: run 'cmake configure' for the specified <distro>."
	@echo ""
	@echo "  build: Run 'cmake build' for all distro"
	@echo "  build_<distro>: run 'cmake build' for the specified <distro>."
	@echo ""
	@echo "  test: Run 'cmake test(s)' for all distro."
	@echo "  test_<distro>: Run 'cmake test(s)' for the specified <distro>."
	@echo ""
	@echo "  install: Run 'cmake install' for all distro."
	@echo "  install_<distro>: Run 'cmake install' for the specified <distro>."
	@echo ""
	@echo "  clean: call cmake \"make clean\""
	@echo "  distclean: clean and also remove all docker images"
	@echo ""
	@echo "<distro>: alpine, centos-7, debian-9, ubuntu-latest, ubuntu-14.04, ubuntu-16.04, ubuntu-18.04"
	@echo "<lang>: cpp, python, java, dotnet"
	@echo ""
	@echo "Options:"
	@echo "  NOCACHE=1: use \"docker build --no-cache\""

# keep all intermediate files e.g. cache/<distro>/docker_*.tar
# src: https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
.SECONDARY:

BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
$(info branch: $(BRANCH))
SHA1 := $(shell git rev-parse --verify HEAD)
$(info SHA1: $(SHA1))

# Need to add cmd_distro to PHONY otherwise target are ignored since they don't
# contain recipe (using FORCE don't work here)
.PHONY: all
all: build

IMAGE := cmake-swig

# % stem in target and prerequisite
# $* stem in rules
# $< first prerequist
# $@ target name

cache:
	mkdir cache

# need docker/% to avoid stem matching "<distro>/docker_devel.tar"
cache/%: | docker/% cache
	mkdir cache/$*

##############
##  DOCKER  ##
##############
ifdef NOCACHE
DOCKER_BUILD_CMD := docker build --no-cache
else
DOCKER_BUILD_CMD := docker build
endif
UID := $(shell id -u)
GID := $(shell id -g)
DOCKER_DEVEL_CMD := docker run --rm -it --init --user ${UID}:${GID}
#DOCKER_DEVEL_CMD := docker run --rm -it --init
DOCKER_INSTALL_CMD := docker run --rm -it --init -v ${PWD}/cmake/sample:/project -w /project

.PHONY: docker \
docker_alpine \
docker_centos-7 \
docker_debian-9 \
docker_ubuntu-latest \
docker_ubuntu-18.04 \
docker_ubuntu-16.04 \
docker_ubuntu-14.04
docker: \
docker_alpine \
docker_centos-7 \
docker_debian-9 \
docker_ubuntu-latest \
docker_ubuntu-18.04 \
docker_ubuntu-16.04 \
docker_ubuntu-14.04
docker_alpine: cache/alpine/docker_devel.tar
docker_centos-7: cache/centos-7/docker_devel.tar
docker_debian-9: cache/debian-9/docker_devel.tar
docker_ubuntu-latest: cache/ubuntu-latest/docker_devel.tar
docker_ubuntu-18.04: cache/ubuntu-18.04/docker_devel.tar
docker_ubuntu-16.04: cache/ubuntu-16.04/docker_devel.tar
docker_ubuntu-14.04: cache/ubuntu-14.04/docker_devel.tar

cache/%/docker_devel.tar: docker/%/Dockerfile | cache/%
	-docker image rm -f ${IMAGE}_$*:devel 2>/dev/null
	$(DOCKER_BUILD_CMD) -f $< -t ${IMAGE}_$*:devel docker/$*
	docker save ${IMAGE}_$*:devel -o $@

###################
##  DOCKER BASH  ##
###################
.PHONY: \
bash_alpine \
bash_centos-7 \
bash_debian-9 \
bash_ubuntu-latest \
bash_ubuntu-18.04 \
bash_ubuntu-16.04 \
bash_ubuntu-14.04
bash_alpine: cache/alpine/docker_devel.tar
	${DOCKER_DEVEL_CMD} ${IMAGE}_alpine:devel /bin/sh
bash_centos-7: cache/centos-7/docker_devel.tar
	${DOCKER_DEVEL_CMD} ${IMAGE}_centos-7:devel /bin/bash
bash_debian-9: cache/debian-9/docker_devel.tar
	${DOCKER_DEVEL_CMD} ${IMAGE}_debian-9:devel /bin/bash
bash_ubuntu-latest: cache/ubuntu-latest/docker_devel.tar
	${DOCKER_DEVEL_CMD} ${IMAGE}_ubuntu-latest:devel /bin/bash
bash_ubuntu-18.04: cache/ubuntu-18.04/docker_devel.tar
	${DOCKER_DEVEL_CMD} ${IMAGE}_ubuntu-18.04:devel /bin/bash
bash_ubuntu-16.04: cache/ubuntu-16.04/docker_devel.tar
	${DOCKER_DEVEL_CMD} ${IMAGE}_ubuntu-16.04:devel /bin/bash
bash_ubuntu-14.04: cache/ubuntu-14.04/docker_devel.tar
	${DOCKER_DEVEL_CMD} ${IMAGE}_ubuntu-14.04:devel /bin/bash

#################
##  CONFIGURE  ##
#################
.PHONY: configure \
configure_alpine \
configure_centos-7 \
configure_debian-9 \
configure_ubuntu-latest \
configure_ubuntu-18.04 \
configure_ubuntu-16.04 \
configure_ubuntu-14.04
configure: \
configure_alpine \
configure_centos-7 \
configure_debian-9 \
configure_ubuntu-latest \
configure_ubuntu-18.04 \
configure_ubuntu-16.04 \
configure_ubuntu-14.04
configure_alpine: cache/alpine/configure.log
configure_centos-7: cache/centos-7/configure.log
configure_debian-9: cache/debian-9/configure.log
configure_ubuntu-latest: cache/ubuntu-latest/configure.log
configure_ubuntu-18.04: cache/ubuntu-18.04/configure.log
configure_ubuntu-16.04: cache/ubuntu-16.04/configure.log
configure_ubuntu-14.04: cache/ubuntu-14.04/configure.log

cache/%/configure.log: cache/%/docker_devel.tar CMakeLists.txt cmake */CMakeLists.txt
	@docker load -i $<
	${DOCKER_DEVEL_CMD} \
 -v ${PWD}:/project -w /project \
 ${IMAGE}_$*:devel \
 /bin/sh -c "cmake -H. -Bcache/$*/build"
	@date > $@

#############
##  BUILD  ##
#############
.PHONY: build \
build_alpine \
build_centos-7 \
build_debian-9 \
build_ubuntu-latest \
build_ubuntu-18.04 \
build_ubuntu-16.04 \
build_ubuntu-14.04
build: \
build_alpine \
build_centos-7 \
build_debian-9 \
build_ubuntu-latest \
build_ubuntu-18.04 \
build_ubuntu-16.04 \
build_ubuntu-14.04
build_alpine: cache/alpine/build.log
build_centos-7: cache/centos-7/build.log
build_debian-9: cache/debian-9/build.log
build_ubuntu-latest: cache/ubuntu-latest/build.log
build_ubuntu-18.04: cache/ubuntu-18.04/build.log
build_ubuntu-16.04: cache/ubuntu-16.04/build.log
build_ubuntu-14.04: cache/ubuntu-14.04/build.log

cache/%/build.log: cache/%/configure.log Bar Foo FooBar FooBarApp
	${DOCKER_DEVEL_CMD} \
 -v ${PWD}:/project -w /project \
 ${IMAGE}_$*:devel \
 /bin/sh -c "cmake --build cache/$*/build --target all"
	@date > $@

############
##  TEST  ##
############
.PHONY: test \
test_alpine \
test_centos-7 \
test_debian-9 \
test_ubuntu-latest \
test_ubuntu-18.04 \
test_ubuntu-16.04 \
test_ubuntu-14.04
test: \
test_alpine \
test_centos-7 \
test_debian-9 \
test_ubuntu-latest \
test_ubuntu-18.04 \
test_ubuntu-16.04 \
test_ubuntu-14.04
test_alpine: cache/alpine/test.log
test_centos-7: cache/centos-7/test.log
test_debian-9: cache/debian-9/test.log
test_ubuntu-latest: cache/ubuntu-latest/test.log
test_ubuntu-18.04: cache/ubuntu-18.04/test.log
test_ubuntu-16.04: cache/ubuntu-16.04/test.log
test_ubuntu-14.04: cache/ubuntu-14.04/test.log

cache/%/test.log: cache/%/build.log
	${DOCKER_DEVEL_CMD} \
 -v ${PWD}:/project -w /project \
 ${IMAGE}_$*:devel \
 /bin/sh -c "cmake --build cache/$*/build --target test -- CTEST_OUTPUT_ON_FAILURE=1"
	@date > $@

###############
##  INSTALL  ##
###############
.PHONY: install \
install_alpine \
install_centos-7 \
install_debian-9 \
install_ubuntu-latest \
install_ubuntu-18.04 \
install_ubuntu-16.04 \
install_ubuntu-14.04
install: \
install_alpine \
install_centos-7 \
install_debian-9 \
install_ubuntu-latest \
install_ubuntu-18.04 \
install_ubuntu-16.04 \
install_ubuntu-14.04
install_alpine: cache/alpine/install.log
install_centos-7: cache/centos-7/install.log
install_debian-9: cache/debian-9/install.log
install_ubuntu-latest: cache/ubuntu-latest/install.log
install_ubuntu-18.04: cache/ubuntu-18.04/install.log
install_ubuntu-16.04: cache/ubuntu-16.04/install.log
install_ubuntu-14.04: cache/ubuntu-14.04/install.log

cache/%/install.log: cmake/docker/%/InstallDockerfile cache/%/build.log
	${DOCKER_DEVEL_CMD} ${IMAGE}_$*:devel /bin/sh -c \
		"cmake --build cache/$*/build --target install -- DESTDIR=install"
	@docker image rm -f ${IMAGE}_$*:install 2>/dev/null
	$(DOCKER_BUILD_CMD) -f $< -t ${IMAGE}_$*:install .
	docker save ${IMAGE}_$*:install -o cache/$*/docker_install.tar
	@date > $@

###########################
##  DOCKER BASH INSTALL  ##
###########################
.PHONY: bash_install_alpine bash_install_ubuntu
bash_install_alpine: cache/alpine/install.log
	@docker load -i cache/alpine/docker_install.tar
	${DOCKER_INSTALL_CMD} ${IMAGE}_alpine:install /bin/sh
bash_install_ubuntu: cache/ubuntu/install.log
	@docker load -i cache/ubuntu/docker_install.tar
	${DOCKER_INSTALL_CMD} ${IMAGE}_ubuntu:install /bin/bash

####################
##  TEST INSTALL  ##
####################
.PHONY: test_install test_install_alpine bash_isntall_ubuntu
test_install: test_install_alpine test_install_ubuntu
test_install_alpine: cache/alpine/test_install.log
test_install_ubuntu: cache/ubuntu/test_install.log
cache/%/test_install.log: cache/%/install.log cmake/sample
	@docker load -i cache/$*/docker_install.tar
	${DOCKER_INSTALL_CMD} ${IMAGE}_$*:install \
 /bin/sh -c "cmake -H. -B/cache; \
cmake --build /cache; \
cmake --build /cache --target test; \
cmake --build /cache --target install"
	@date > $@

#############
##  CLEAN  ##
#############
.PHONY: clean
clean: clean_containers clean_images

.PHONY: clean_images
clean_images: clean_containers
	-docker image ls --all
	-docker image prune --force

.PHONY: clean_containers
clean_containers:
	-docker container ls --all
	-docker container rm $$(docker container ls -f status=exited -q)

.PHONY: distclean
distclean: clean
	-docker container rm $$(docker container ls --all -q)
	-docker image rm $$(docker image ls --all -q)
	rm -rf cache


##############
##  PYTHON  ##
##############
.PHONY: build_manylinux
bash_manylinux:

build_manylinux: cache/manylinux/build.log
bash_manylinux: cache/manylinux/docker_devel.tar
	${DOCKER_DEVEL_CMD} ${IMAGE}_manylinux:devel /bin/sh


cache/manylinux/configure.log: cache/manylinux/docker_devel.tar CMakeLists.txt cmake */CMakeLists.txt
	@docker load -i $<
	${DOCKER_DEVEL_CMD} \
 -v ${PWD}:/project -w /project \
 ${IMAGE}_manylinux:devel \
 /bin/sh -c "cmake -H. -Bcache/manylinux/build -DBUILD_PYTHON=ON"
	@date > $@
