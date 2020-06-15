# rpi-firmware-builder

Dockerized builder for Raspberry Pi firmware (armhf) to be used with Raspbian Buster images. Running `docker build` provides a tar archive of the resulting firmware build, as well as usable firmware within the image itself. Who is this for? Anyone needing to run Raspbian containers on non-Raspbian hosts. The source Raspberry Pi Firmware project maintains tags for Raspbian kernel releases while this covers the need for compiling firmware against other pi-compatible linux kernels from non-Raspbian distributions (e.g. Manjaro, Gentoo).

## Usage

Docker build and run commands to create debian package and copy to local artifact directory.

### Compile and build firmware image and tar

```
docker build -t armpits/rpi-firmware-bulder:latest .
```

### Export tar

```
mkdir $(pwd)/tmp
docker run \
  -v "$(pwd)"/tmp:/tmp \
  -it armpits/rpi-firmware-bulder:latest \
  /bin/bash -c "/bin/cp /*.tar.xz /tmp/"
```

### Deploy archive

```
apt-get install xz-utils && \
mkdir -p /opt/vc && \
tar -C /opt/vc -xf ./rpi-firmware-${KERNEL_VERSION}-armv7.tar.xz && \
echo "/opt/vc/lib" > /etc/ld.so.conf.d/00-vmcs.conf && \
ln -sf /opt/vc/bin/vcgencmd /usr/bin/vcgencmd && \
ldconfig
```

## Base image

The [base image](https://hub.docker.com/r/armpits/raspbian-buster-lite-armhf) used for this Dockerfile comes from the [raspbian-buster-lite-armhf](https://github.com/ARM-PIt/raspbian-buster-lite-armhf) project from this same account. This base image contains existing firmware from the [official firmware repo](https://github.com/raspberrypi/firmware) which is removed before the build proceeds to avoid any interference and overlap.

## Sources

https://hub.docker.com/r/armpits/rpi-firmware-builder
https://hub.docker.com/r/armpits/raspbian-buster-lite-armhf  
https://github.com/ARM-PIt/raspbian-buster-lite-armhf  
https://github.com/ARM-PIt/jenkins-shared-library  
https://github.com/raspberrypi/userland  
https://github.com/raspberrypi/firmware
