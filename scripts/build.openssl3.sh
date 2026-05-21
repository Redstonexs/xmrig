#!/bin/sh -e

OPENSSL_VERSION="${OPENSSL_VERSION:-3.0.16}"
OPENSSL_CONFIG_FLAGS="${OPENSSL_CONFIG_FLAGS:-}"

mkdir -p deps
mkdir -p deps/include
mkdir -p deps/lib

mkdir -p build && cd build

wget https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_VERSION}/openssl-${OPENSSL_VERSION}.tar.gz -O openssl-${OPENSSL_VERSION}.tar.gz
tar -xzf openssl-${OPENSSL_VERSION}.tar.gz

cd openssl-${OPENSSL_VERSION}
./config -no-shared -no-asm -no-tests -no-zlib -no-comp -no-dgram -no-filenames -no-cms ${OPENSSL_CONFIG_FLAGS}
make -j$(nproc || sysctl -n hw.ncpu || sysctl -n hw.logicalcpu)
cp -fr include ../../deps
cp libcrypto.a ../../deps/lib
cp libssl.a ../../deps/lib
cd ..
