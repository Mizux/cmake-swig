PROJECT := cmake-swig
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
SHA1 := $(shell git rev-parse --verify HEAD)

# General commands
.PHONY: help
BOLD=\e[1m
RESET=\e[0m

help:
	@echo -e "${BOLD}SYNOPSIS${RESET}"
	@echo -e "\tmake <target> [NOCACHE=1]"
	@echo
	@echo -e "${BOLD}DESCRIPTION${RESET}"
	@echo -e "\ttest build inside docker container to have a reproductible build."
	@echo
	@echo -e "${BOLD}MAKE TARGETS${RESET}"
	@echo -e "\t${BOLD}help${RESET}: display this help and exit."
	@echo
	@echo -e "\t${BOLD}<prestage>${RESET}: build <prestage> docker images for ALL DISTROS."
	@echo -e "\t${BOLD}<distro>_<prestage>${RESET}: build the <prestage> docker image for a specific distro."
	@echo -e "\t${BOLD}save_<prestage>${RESET}: Save <prestage> docker images for ALL DISTROS."
	@echo -e "\t${BOLD}save_<distro>_<prestage>${RESET}: Save the <prestage> docker image for a specific distro."
	@echo -e "\t${BOLD}sh_<distro>_<prestage>${RESET}: run a container using the <prestage> docker image specified (debug purpose)."
	@echo
	@echo -e "\t${BOLD}<stage>${RESET}: build <stage> docker images for ALL DISTROS and ALL LANGUAGES."
	@echo -e "\t${BOLD}<distro>_<stage>${RESET}: build <stage> docker images for a specific distro for ALL LANGUAGES."
	@echo -e "\t${BOLD}<lang>_<stage>${RESET}: build <stage> docker images for ALL DISTROS for a specific language."
	@echo -e "\t${BOLD}<distro>_<lang>_<stage>${RESET}: build the <stage> docker image for a specific distro for a specific language."
	@echo -e "\t${BOLD}save_<stage>${RESET}: Save <stage> docker images for ALL DISTROS for ALL LANGUAGES."
	@echo -e "\t${BOLD}save_<distro>_<stage>${RESET}: Save <stage> docker images for a specific distro for ALL LANGUAGES."
	@echo -e "\t${BOLD}save_<lang>_<stage>${RESET}: Save <stage> docker images for ALL DISTRO for a specific language."
	@echo -e "\t${BOLD}save_<distro>_<lang>_<stage>${RESET}: Save the <stage> docker image for a specific distro for a specific language."
	@echo -e "\t${BOLD}sh_<distro>_<lang>_<stage>${RESET}: run a container using the <stage> docker image specified (debug purpose)."
	@echo
	@echo
	@echo -e "\t${BOLD}clean${RESET}: Remove cache and docker image."
	@echo -e "\t${BOLD}clean_<distro>${RESET}: Remove cache and docker image for the specified distro."
	@echo
	@echo -e "\t${BOLD}<distro>${RESET}:"
	@echo -e "\t\t${BOLD}alpine${RESET} (edge)"
	@echo -e "\t\t${BOLD}archlinux${RESET} (latest)"
	@echo -e "\t\t${BOLD}centos${RESET} (latest)"
	@echo -e "\t\t${BOLD}debian${RESET} (latest)"
	@echo -e "\t\t${BOLD}fedora${RESET} (latest)"
	@echo -e "\t\t${BOLD}opensuse${RESET} (tumbleweed)"
	@echo -e "\t\t${BOLD}ubuntu${RESET} (rolling)"
	@echo -e "\te.g. 'make test_ubuntu'"
	@echo
	@echo -e "\t${BOLD}<prestage>${RESET}:"
	@echo -e "\t\t${BOLD}base${RESET} (need by cpp)"
	@echo -e "\t\t${BOLD}swig${RESET} (need by .Net, Java and Python)"
	@echo -e "\te.g. 'make base'"
	@echo
	@echo -e "\t${BOLD}<lang>${RESET}:"
	@echo -e "\t\t${BOLD}cpp${RESET} (C++)"
	@echo -e "\t\t${BOLD}python${RESET} (Python >= 3)"
	@echo -e "\t\t${BOLD}java${RESET} (Java >= 8)"
	@echo -e "\t\t${BOLD}dotnet${RESET} (.Net Core >= 2.1)"
	@echo -e "\te.g. 'make devel_cpp'"
	@echo
	@echo -e "\t${BOLD}<stage>${RESET}:"
	@echo -e "\t\t${BOLD}env${RESET}"
	@echo -e "\t\t${BOLD}devel${RESET}"
	@echo -e "\t\t${BOLD}build${RESET}"
	@echo -e "\t\t${BOLD}test${RESET}"
	@echo -e "\t\t${BOLD}install_devel${RESET}"
	@echo -e "\t\t${BOLD}install_build${RESET}"
	@echo -e "\t\t${BOLD}install_test${RESET}"
	@echo -e "\te.g. 'make build'"
	@echo
	@echo -e "\t${BOLD}NOCACHE=1${RESET}: use 'docker build --no-cache' when building container (default use cache)."
	@echo
	@echo -e "branch: $(BRANCH)"
	@echo -e "sha1: $(SHA1)"

# Need to add cmd_distro to PHONY otherwise target are ignored since they do not
# contain recipe (using FORCE do not work here)
.PHONY: all
all: devel

# Delete all implicit rules to speed up makefile
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:
# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =
# Keep all intermediate files
# ToDo: try to remove it later
.SECONDARY:

# Docker image name prefix.
IMAGE := ${PROJECT}

ifdef NOCACHE
DOCKER_BUILD_CMD := docker build --no-cache
else
DOCKER_BUILD_CMD := docker build
endif

DOCKER_RUN_CMD := docker run --rm --init --net=host

# Currently supported distro
DISTROS = alpine archlinux centos debian fedora opensuse ubuntu
LANGUAGES = cpp python java dotnet

# $* stem
# $< first prerequist
# $@ target name


## Base ##
# Build the base image.
targets = $(addsuffix _base, $(DISTROS))
.PHONY: base $(targets)
base: $(targets)
$(targets): %_base: docker/%/Dockerfile
	#@docker image rm -f ${IMAGE}:$*_base 2>/dev/null
	${DOCKER_BUILD_CMD} --target=base --tag ${IMAGE}:$*_base -f $< docker/$*

# Save the base image.
targets = $(addprefix save_, $(addsuffix _base, $(DISTROS)))
.PHONY: save_base $(targets)
save_base: $(targets)
$(targets): save_%_base: cache/%/docker_base.tar
cache/%/docker_base.tar: %_base
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_base -o $@

# Run a container using the base image (debug).
targets = $(addprefix sh_, $(addsuffix _base, $(DISTROS)))
.PHONY: $(targets)
$(targets): sh_%_base: %_base
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_base ${IMAGE}:$*_base /bin/sh


## SWIG ##
# Build the swig image.
targets = $(addsuffix _swig, $(DISTROS))
.PHONY: swig $(targets)
swig: $(targets)
$(targets): %_swig: %_base
	#@docker image rm -f ${IMAGE}:$*_swig 2>/dev/null
	${DOCKER_BUILD_CMD} --target=swig --tag ${IMAGE}:$*_swig -f $< docker/$*

# Save the swig image.
targets = $(addprefix save_, $(addsuffix _swig, $(DISTROS)))
.PHONY: save_swig $(targets)
save_swig: $(targets)
$(targets): save_%_swig: cache/%/docker_swig.tar
cache/%/docker_swig.tar: %_swig
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_swig -o $@

# Run a container using the swig image (debug).
targets = $(addprefix sh_, $(addsuffix _swig, $(DISTROS)))
.PHONY: $(targets)
$(targets): sh_%_swig: %_swig
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_swig ${IMAGE}:$*_swig /bin/sh


## ENV ##
# Build the env image.
targets = $(addsuffix _env, $(DISTROS))
.PHONY: env $(targets)
env: $(targets)
$(targets): %_env: $(addprefix %_, $(addsuffix _env, $(LANGUAGES)))

targets = $(addsuffix _env, $(LANGUAGES))
.PHONY: $(targets)
$(targets): %_env: $(addsuffix _env, $(addsuffix _%, $(DISTROS)))

cpp_targets = $(addsuffix _env, $(addsuffix _cpp, $(DISTROS)))
dotnet_targets = $(addsuffix _env, $(addsuffix _dotnet, $(DISTROS)))
java_targets = $(addsuffix _env, $(addsuffix _java, $(DISTROS)))
python_targets = $(addsuffix _env, $(addsuffix _python, $(DISTROS)))
.PHONY: $(cpp_targets) $(dotnet_targets) $(java_targets) $(python_targets)

$(cpp_targets): %_cpp_env: docker/%/cpp.Dockerfile
	#@docker image rm -f ${IMAGE}:$*_cpp_env 2>/dev/null
	${DOCKER_BUILD_CMD} --target=env --tag ${IMAGE}:$*_cpp_env -f $< docker/$*
$(dotnet_targets): %_dotnet_env: docker/%/dotnet.Dockerfile %_swig
	#@docker image rm -f ${IMAGE}:$*_dotnet_env 2>/dev/null
	${DOCKER_BUILD_CMD} --target=env --tag ${IMAGE}:$*_dotnet_env -f $< docker/$*
$(java_targets): %_java_env: docker/%/java.Dockerfile %_swig
	#@docker image rm -f ${IMAGE}:$*_java_env 2>/dev/null
	${DOCKER_BUILD_CMD} --target=env --tag ${IMAGE}:$*_java_env -f $< docker/$*
$(python_targets): %_python_env: docker/%/python.Dockerfile %_swig
	#@docker image rm -f ${IMAGE}:$*_python_env 2>/dev/null
	${DOCKER_BUILD_CMD} --target=env --tag ${IMAGE}:$*_python_env -f $< docker/$*

# Save the env image.
targets = $(addprefix save_, $(addsuffix _env, $(DISTROS)))
.PHONY: save_env $(targets)
save_env: $(targets)
$(targets): save_%_env: $(addprefix save_%_, $(addsuffix _env, $(LANGUAGES)))

targets = $(addprefix save_, $(addsuffix _env, $(LANGUAGES)))
.PHONY: $(targets)
$(targets): save_%_env: $(addprefix save_, $(addsuffix _%_env, $(DISTROS)))

cpp_targets = $(addprefix save_, $(addsuffix _cpp_env, $(DISTROS)))
dotnet_targets = $(addprefix save_, $(addsuffix _dotnet_env, $(DISTROS)))
java_targets = $(addprefix save_, $(addsuffix _java_env, $(DISTROS)))
python_targets = $(addprefix save_, $(addsuffix _python_env, $(DISTROS)))
.PHONY: $(cpp_targets) $(dotnet_targets) $(java_targets) $(python_targets)

$(cpp_targets): save_%_cpp_env: cache/%/docker_cpp_env.tar
cache/%/docker_cpp_env.tar: %_cpp_env
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_cpp_env -o $@
$(dotnet_targets): save_%_dotnet_env: cache/%/docker_dotnet_env.tar
cache/%/docker_dotnet_env.tar: %_dotnet_env
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_dotnet_env -o $@
$(java_targets): save_%_java_env: cache/%/docker_java_env.tar
cache/%/docker_java_env.tar: %_java_env
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_java_env -o $@
$(python_targets): save_%_python_env: cache/%/docker_python_env.tar
cache/%/docker_python_env.tar: %_python_env
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_python_env -o $@

# Run a container using the env image (debug).
cpp_targets = $(addprefix sh_, $(addsuffix _cpp_env, $(DISTROS)))
dotnet_targets = $(addprefix sh_, $(addsuffix _dotnet_env, $(DISTROS)))
java_targets = $(addprefix sh_, $(addsuffix _java_env, $(DISTROS)))
python_targets = $(addprefix sh_, $(addsuffix _python_env, $(DISTROS)))
.PHONY: $(cpp_targets) $(dotnet_targets) $(java_targets) $(python_targets)

$(cpp_targets): sh_%_cpp_env: %_cpp_env
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_cpp_env ${IMAGE}:$*_cpp_env /bin/sh
$(dotnet_targets): sh_%_dotnet_env: %_dotnet_env
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_dotnet_env ${IMAGE}:$*_dotnet_env /bin/sh
$(java_targets): sh_%_java_env: %_java_env
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_java_env ${IMAGE}:$*_java_env /bin/sh
$(python_targets): sh_%_python_env: %_python_env
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_python_env ${IMAGE}:$*_python_env /bin/sh


## DEVEL ##
.PHONY: devel
devel: $(addprefix devel_, $(DISTROS))

distro_targets = $(addprefix devel_, $(DISTROS))
.PHONY: $(distro_targets)
$(distro_targets): devel_%: $(addprefix devel_%_, $(LANGUAGES))

lang_targets = $(addprefix devel_, $(LANGUAGES))
.PHONY: $(lang_targets)
$(lang_targets): devel_%: $(addsuffix _%, $(addprefix devel_, $(DISTROS)))

distro_cpp_targets = $(addprefix devel_, $(addsuffix _cpp, $(DISTROS)))
distro_python_targets = $(addprefix devel_, $(addsuffix _python, $(DISTROS)))
distro_java_targets = $(addprefix devel_, $(addsuffix _java, $(DISTROS)))
distro_dotnet_targets = $(addprefix devel_, $(addsuffix _dotnet, $(DISTROS)))
.PHONY: $(distro_cpp_targets) $(distro_python_targets) $(distro_java_targets) $(distro_dotnet_targets)
$(distro_cpp_targets): devel_%_cpp: cache/%/docker_cpp.tar
$(distro_python_targets): devel_%_python: cache/%/docker_python.tar
$(distro_java_targets): devel_%_java: cache/%/docker_java.tar
$(distro_dotnet_targets): devel_%_dotnet: cache/%/docker_dotnet.tar

# Save the devel image.
cache/%/docker_cpp.tar: docker/%/Dockerfile ../CMakeLists.txt ../cmake
	@echo building $@...
	@docker image rm -f ${IMAGE}:$*_cpp 2>/dev/null
	${DOCKER_BUILD_CMD} --target=cpp --tag ${IMAGE}:$*_cpp -f $< ..
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_cpp -o $@

cache/%/docker_python.tar: docker/%/Dockerfile ../CMakeLists.txt ../cmake
	@echo building $@...
	@docker image rm -f ${IMAGE}:$*_python 2>/dev/null
	${DOCKER_BUILD_CMD} --target=python --tag ${IMAGE}:$*_python -f $< ..
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_python -o $@

cache/%/docker_java.tar: docker/%/Dockerfile ../CMakeLists.txt ../cmake
	@echo building $@...
	@docker image rm -f ${IMAGE}:$*_java 2>/dev/null
	${DOCKER_BUILD_CMD} --target=java --tag ${IMAGE}:$*_java -f $< ..
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_java -o $@

cache/%/docker_dotnet.tar: docker/%/Dockerfile ../CMakeLists.txt ../cmake
	@echo building $@...
	@docker image rm -f ${IMAGE}:$*_dotnet 2>/dev/null
	${DOCKER_BUILD_CMD} --target=dotnet --tag ${IMAGE}:$*_dotnet -f $< ..
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_dotnet -o $@

# DOCKER BASH INSTALL (debug)
distro_cpp_targets = $(addprefix sh_, $(addsuffix _cpp, $(DISTROS)))
distro_python_targets = $(addprefix sh_, $(addsuffix _python, $(DISTROS)))
distro_java_targets = $(addprefix sh_, $(addsuffix _java, $(DISTROS)))
distro_dotnet_targets = $(addprefix sh_, $(addsuffix _dotnet, $(DISTROS)))
.PHONY: $(distro_cpp_targets) $(distro_python_targets) $(distro_java_targets) $(distro_dotnet_targets)

$(distro_cpp_targets): sh_%_cpp: cache/%/docker_cpp.tar
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_cpp ${IMAGE}:$*_cpp /bin/sh
$(distro_python_targets): sh_%_python: cache/%/docker_python.tar
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_python ${IMAGE}:$*_python /bin/sh
$(distro_java_targets): sh_%_java: cache/%/docker_java.tar
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_java ${IMAGE}:$*_java /bin/sh
$(distro_dotnet_targets): sh_%_dotnet: cache/%/docker_dotnet.tar
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_dotnet ${IMAGE}:$*_dotnet /bin/sh

# TEST DEVEL
.PHONY: test
test: $(addprefix test_, $(DISTROS))

distro_targets = $(addprefix test_, $(DISTROS))
.PHONY: $(distro_targets)
$(distro_targets): test_%: $(addprefix test_%_, $(LANGUAGES))

lang_targets = $(addprefix test_, $(LANGUAGES))
.PHONY: $(lang_targets)
$(lang_targets): test_%: $(addsuffix _%, $(addprefix test_, $(DISTROS)))

distro_cpp_targets = $(addprefix test_, $(addsuffix _cpp, $(DISTROS)))
distro_python_targets = $(addprefix test_, $(addsuffix _python, $(DISTROS)))
distro_java_targets = $(addprefix test_, $(addsuffix _java, $(DISTROS)))
distro_dotnet_targets = $(addprefix test_, $(addsuffix _dotnet, $(DISTROS)))
.PHONY: $(distro_cpp_targets) $(distro_python_targets) $(distro_java_targets) $(distro_dotnet_targets)

$(distro_cpp_targets): test_%_cpp: cache/%/docker_cpp.tar
	${DOCKER_RUN_CMD} -t --name ${IMAGE}_$*_cpp ${IMAGE}:$*_cpp cmake --build build --target test -- CTEST_OUTPUT_ON_FAILURE=1
$(distro_python_targets): test_%_python: cache/%/docker_python.tar
	${DOCKER_RUN_CMD} -t --name ${IMAGE}_$*_python ${IMAGE}:$*_python cmake --build build --target test -- CTEST_OUTPUT_ON_FAILURE=1
$(distro_java_targets): test_%_java: cache/%/docker_java.tar
	${DOCKER_RUN_CMD} -t --name ${IMAGE}_$*_java ${IMAGE}:$*_java cmake --build build --target test -- CTEST_OUTPUT_ON_FAILURE=1
$(distro_dotnet_targets): test_%_dotnet: cache/%/docker_dotnet.tar
	${DOCKER_RUN_CMD} -t --name ${IMAGE}_$*_dotnet ${IMAGE}:$*_dotnet cmake --build build --target test -- CTEST_OUTPUT_ON_FAILURE=1

# INSTALL
.PHONY: install
install: $(addprefix install_, $(DISTROS))

distro_targets = $(addprefix install_, $(DISTROS))
.PHONY: $(distro_targets)
$(distro_targets): install_%: $(addprefix install_%_, $(LANGUAGES))

lang_targets = $(addprefix install_, $(LANGUAGES))
.PHONY: $(lang_targets)
$(lang_targets): install_%: $(addsuffix _%, $(addprefix install_, $(DISTROS)))

distro_cpp_targets = $(addprefix install_, $(addsuffix _cpp, $(DISTROS)))
distro_python_targets = $(addprefix install_, $(addsuffix _python, $(DISTROS)))
distro_java_targets = $(addprefix install_, $(addsuffix _java, $(DISTROS)))
distro_dotnet_targets = $(addprefix install_, $(addsuffix _dotnet, $(DISTROS)))
.PHONY: $(distro_cpp_targets) $(distro_python_targets) $(distro_java_targets) $(distro_dotnet_targets)
$(distro_cpp_targets): install_%_cpp: cache/%/docker_install_cpp.tar
$(distro_python_targets): install_%_python: cache/%/docker_install_python.tar
$(distro_java_targets): install_%_java: cache/%/docker_install_java.tar
$(distro_dotnet_targets): install_%_dotnet: cache/%/docker_install_dotnet.tar

cache/%/docker_install_cpp.tar: docker/%/Dockerfile sample_cpp
	@docker image rm -f ${IMAGE}:$*_install_cpp 2>/dev/null
	${DOCKER_BUILD_CMD} --target=install_cpp --tag ${IMAGE}:$*_install_cpp -f $< ..
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_install_cpp -o $@

cache/%/docker_install_python.tar: docker/%/Dockerfile sample_python
	@docker image rm -f ${IMAGE}:$*_install_python 2>/dev/null
	${DOCKER_BUILD_CMD} --target=install_python --tag ${IMAGE}:$*_install_python -f $< ..
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_install_python -o $@

cache/%/docker_install_java.tar: docker/%/Dockerfile sample_java
	@docker image rm -f ${IMAGE}:$*_install_java 2>/dev/null
	${DOCKER_BUILD_CMD} --target=install_java --tag ${IMAGE}:$*_install_java -f $< ..
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_install_java -o $@

cache/%/docker_install_dotnet.tar: docker/%/Dockerfile sample_dotnet
	@docker image rm -f ${IMAGE}:$*_install_dotnet 2>/dev/null
	${DOCKER_BUILD_CMD} --target=install_dotnet --tag ${IMAGE}:$*_install_dotnet -f $< ..
	@rm -f $@
	mkdir -p cache/$*
	docker save ${IMAGE}:$*_install_dotnet -o $@

# DOCKER BASH INSTALL (debug)
distro_cpp_targets = $(addprefix sh_install_, $(addsuffix _cpp, $(DISTROS)))
.PHONY: $(distro_cpp_targets)
distro_python_targets = $(addprefix sh_install_, $(addsuffix _python, $(DISTROS)))
.PHONY: $(distro_python_targets)
distro_java_targets = $(addprefix sh_install_, $(addsuffix _java, $(DISTROS)))
.PHONY: $(distro_java_targets)
distro_dotnet_targets = $(addprefix sh_install_, $(addsuffix _dotnet, $(DISTROS)))
.PHONY: $(distro_dotnet_targets)

$(distro_cpp_targets): sh_install_%_cpp: cache/%/docker_install_cpp.tar
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_install_cpp ${IMAGE}:$*_install_cpp /bin/sh
$(distro_python_targets): sh_install_%_python: cache/%/docker_install_python.tar
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_install_python ${IMAGE}:$*_install_python /bin/sh
$(distro_java_targets): sh_install_%_java: cache/%/docker_install_java.tar
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_install_java ${IMAGE}:$*_install_java /bin/sh
$(distro_dotnet_targets): sh_install_%_dotnet: cache/%/docker_install_dotnet.tar
	${DOCKER_RUN_CMD} -it --name ${IMAGE}_$*_install_dotnet ${IMAGE}:$*_install_dotnet /bin/sh

# TEST INSTALL#
.PHONY: test_install
test_install: $(addprefix test_install, $(DISTROS))

distro_targets = $(addprefix test_install_, $(DISTROS))
.PHONY: $(distro_targets)
$(distro_targets): test_install_%: $(addprefix test_install_%_, cpp)

distro_cpp_targets = $(addprefix test_install_, $(addsuffix _cpp, $(DISTROS)))
distro_python_targets = $(addprefix test_install_, $(addsuffix _python, $(DISTROS)))
distro_java_targets = $(addprefix test_install_, $(addsuffix _java, $(DISTROS)))
distro_dotnet_targets = $(addprefix test_install_, $(addsuffix _dotnet, $(DISTROS)))
.PHONY: $(distro_cpp_targets) $(distro_python_targets) $(distro_java_targets) $(distro_dotnet_targets)

$(distro_cpp_targets): test_install_%_cpp: cache/%/docker_install_cpp.tar
	${DOCKER_RUN_CMD} -t --name ${IMAGE}_$*_install_cpp ${IMAGE}:$*_install_cpp /bin/sh -c \
		"cmake -H. -Bbuild; \
		cmake --build build --target all; \
		cmake --build build --target test; \
		cmake --build build --target install"

$(distro_python_targets): test_install_%_python: cache/%/docker_install_python.tar
	${DOCKER_RUN_CMD} -t --name ${IMAGE}_$*_install_python ${IMAGE}:$*_install_python /bin/sh -c \
		"./sample.py"

$(distro_java_targets): test_install_%_java: cache/%/docker_install_java.tar
	${DOCKER_RUN_CMD} -t --name ${IMAGE}_$*_install_java ${IMAGE}:$*_install_java /bin/sh -c \
		"java sample.java"

$(distro_dotnet_targets): test_install_%_dotnet: cache/%/docker_install_dotnet.tar
	${DOCKER_RUN_CMD} -t --name ${IMAGE}_$*_install_dotnet ${IMAGE}:$*_install_dotnet /bin/sh -c \
		"dotnet build; \
		dotnet run --project sample.csproj"

# CLEAN
targets = $(addprefix clean_, $(DISTROS))
.PHONY: clean $(targets)
clean: $(targets)
	-rmdir cache
$(targets): clean_%:
	docker container prune -f
	docker image prune -f
	-docker image rm -f ${IMAGE}:$*_install_cpp 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_dotnet 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_java 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_python 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_cpp 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_devel 2>/dev/null
	-docker image rm -f ${IMAGE}:$*_env 2>/dev/null
	-rm -f cache/$*/docker_install_cpp.tar
	-rm -f cache/$*/docker_dotnet.tar
	-rm -f cache/$*/docker_java.tar
	-rm -f cache/$*/docker_python.tar
	-rm -f cache/$*/docker_cpp.tar
	-rm -f cache/$*/docker_devel.tar
	-rm -f cache/$*/docker_env.tar
	-rmdir cache/$*

.PHONY: distclean
distclean: clean
	-docker container rm -f $$(docker container ls -aq)
	-docker image rm -f $$(docker image ls -aq)
