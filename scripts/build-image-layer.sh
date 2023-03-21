#!/bin/sh

set -eu

case "${TARGETARCH}" in
  "amd64")
    LINKER_NAME="x86_64-linux-gnu-gcc"
    LINKER_PACKAGE="gcc-x86-64-linux-gnu"
    BUILD_TARGET="x86_64-unknown-linux-gnu" ;;
  "arm64")
    LINKER_NAME="aarch64-linux-gnu-gcc"
    LINKER_PACKAGE="gcc-aarch64-linux-gnu"
    BUILD_TARGET="aarch64-unknown-linux-gnu" ;;
esac

tools() {
  apt-get install -y "${LINKER_PACKAGE}"
  rustup target add "${BUILD_TARGET}"
}

deps() {
  mkdir -p \
    crates/bonfire/src \
    crates/delta/src \
    crates/quark/src
  echo 'fn main() { panic!("stub"); }' |
    tee crates/bonfire/src/main.rs > crates/delta/src/main.rs
  echo '' > crates/quark/src/lib.rs
  cargo build --locked --release --target "${BUILD_TARGET}"
}

apps() {
  touch -am \
    crates/bonfire/src/main.rs \
    crates/delta/src/main.rs \
    crates/quark/src/lib.rs
  cargo build --locked --release --target "${BUILD_TARGET}"
  mv target _target && mv _target/"${BUILD_TARGET}" target
}

export RUSTFLAGS="-C linker=${LINKER_NAME}"
export PKG_CONFIG_ALLOW_CROSS="1"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/lib/aarch64-linux-gnu/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig"

"$@"
