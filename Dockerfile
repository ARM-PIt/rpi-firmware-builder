FROM armpits/raspbian-buster-lite-armhf

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

RUN export KERNEL_VERSION="$(uname -r)" && \
    mkdir "${TMPDIR}" && \
    rm -rf /opt/vc /lib/modules && \
    mkdir -p /opt/vc /lib/modules && \
    git clone --depth=1 https://github.com/raspberrypi/userland ${TMPDIR}/userland && \
    cp -a "${TMPDIR}"/userland/interface/* "${PREFIX}"/include/ && \
    cd ${TMPDIR}/userland && \
    sed -i -e 's/sudo//g' ${TMPDIR}/userland/buildme && \
    bash buildme && \
    rm -rf ${TMPDIR} && \
    tar --numeric-owner -zcvf /rpi-firmware-${KERNEL_VERSION}-armv7.tar.xz -C /opt/vc . && \
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
