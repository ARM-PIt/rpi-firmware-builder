FROM debian:10-slim

ARG DEBIAN_FRONTEND="noninteractive"

RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    apt-get full-upgrade -y && \
    apt-get install -y \
    vim \
    autoconf \
    automake \
    cmake \
    curl \
    bzip2 \
    g++ \
    gcc \
    git \
    gperf \
    libtool \
    make \
    nasm \
    perl \
    pkg-config \
    python \
    yasm \
    meson \
    autopoint \
    gettext \
    libffi-dev \
    xz-utils

ARG PREFIX=/usr/local
ARG TMPDIR=/rpi-firmware-src
ARG USERLAND_GIT_COMMIT=7d3c6b9

RUN export KERNEL_VERSION="$(uname -r)" && \
    mkdir "${TMPDIR}" && \
    rm -rf /opt/vc /lib/modules && \
    mkdir -p /opt/vc /lib/modules && \
    git clone https://github.com/raspberrypi/userland ${TMPDIR}/userland && \
    cd ${TMPDIR}/userland && \
    git checkout "${USERLAND_GIT_COMMIT}" && \
    cp -a "${TMPDIR}"/userland/interface/* "${PREFIX}"/include/ && \
    sed -i -e 's/sudo//g' ${TMPDIR}/userland/buildme && \
    bash buildme --aarch64 && \
    rm -rf ${TMPDIR} && \
    tar --numeric-owner -zcvf /rpi-firmware-${KERNEL_VERSION}-"$(uname -m)".tar.xz -C /opt/vc . && \
    echo "/opt/vc/lib" > /etc/ld.so.conf.d/00-vmcs.conf && \
    ln -sf /opt/vc/bin/vcgencmd /usr/bin/vcgencmd && \
    ldconfig

RUN apt-get -y --purge remove \
    vim \
    autoconf \
    automake \
    cmake \
    curl \
    bzip2 \
    g++ \
    gcc \
    git \
    gperf \
    libtool \
    make \
    nasm \
    perl \
    pkg-config \
    python \
    yasm \
    meson \
    autopoint \
    gettext \
    libffi-dev \
    xz-utils && \
    apt-get update && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

CMD ["/bin/bash"]
