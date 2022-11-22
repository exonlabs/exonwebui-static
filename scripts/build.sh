#!/bin/bash
cd $(dirname $(readlink -f $0))/..

PKGNAME=exonwebui_static
VERSION=$(cat pool/VERSION |head -n 1 |xargs)

BUILD_VER=${VERSION}
echo "${BUILD_VER}" |grep -q 'dev' && {
    BUILD_VER=${BUILD_VER}$(date +%y%m%d%H%M%S)
}

SETUPENV_PATH=../venv_py3
ENV_PYTHON=${SETUPENV_PATH}/bin/python
ENV_PIP=${SETUPENV_PATH}/bin/pip


echo -e "\n* Building Packages:"

if ! (test -x ${ENV_PYTHON} && test -x ${ENV_PIP}) ;then
    echo -e "\n-- Error!! failed to detect virtualenv, rebuild DEV setup\n"
    exit 1
fi

# set build version
echo "${BUILD_VER}" > pool/VERSION

# create packages
${ENV_PYTHON} setup.py sdist bdist_wheel clean --all

# revert original version
echo "${VERSION}" > pool/VERSION

# install latest dev after version bump
${ENV_PIP} install -e ./

echo -e "\n* Created packages: ${PKGNAME} ${BUILD_VER}\n"
