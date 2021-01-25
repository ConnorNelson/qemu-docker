FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV LC_CTYPE=C.UTF-8

RUN apt-get update && \
    apt-get install -y build-essential \
                       wget \
                       bc \
                       bison \
                       flex \
                       libelf-dev \
                       libssl-dev \
                       qemu-system-x86 \
                       kmod \
                       iproute2 \
                       openssh-server \
                       jq \
                       udhcpd \
                       udhcpc \
                       iputils-ping \
                       strace

ARG VERSION="linux-5.4"

WORKDIR /opt
RUN wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/$VERSION.tar.gz
RUN tar xf $VERSION.tar.gz
RUN rm $VERSION.tar.gz

WORKDIR /opt/$VERSION
RUN make defconfig
RUN echo 'CONFIG_NET_9P=y' >> .config && \
    echo 'CONFIG_NET_9P_DEBUG=n' >> .config && \
    echo 'CONFIG_9P_FS=y' >> .config && \
    echo 'CONFIG_9P_FS_POSIX_ACL=y' >> .config && \
    echo 'CONFIG_9P_FS_SECURITY=y' >> .config && \
    echo 'CONFIG_NET_9P_VIRTIO=y' >> .config && \
    echo 'CONFIG_VIRTIO_PCI=y' >> .config && \
    echo 'CONFIG_VIRTIO_BLK=y' >> .config && \
    echo 'CONFIG_VIRTIO_BLK_SCSI=y' >> .config && \
    echo 'CONFIG_VIRTIO_NET=y' >> .config && \
    echo 'CONFIG_VIRTIO_CONSOLE=y' >> .config && \
    echo 'CONFIG_HW_RANDOM_VIRTIO=y' >> .config && \
    echo 'CONFIG_DRM_VIRTIO_GPU=y' >> .config && \
    echo 'CONFIG_VIRTIO_PCI_LEGACY=y' >> .config && \
    echo 'CONFIG_VIRTIO_BALLOON=y' >> .config && \
    echo 'CONFIG_VIRTIO_INPUT=y' >> .config && \
    echo 'CONFIG_CRYPTO_DEV_VIRTIO=y' >> .config && \
    echo 'CONFIG_BALLOON_COMPACTION=y' >> .config && \
    echo 'CONFIG_PCI=y' >> .config && \
    echo 'CONFIG_PCI_HOST_GENERIC=y' >> .config && \
    echo 'CONFIG_GDB_SCRIPTS=y' >> .config && \
    echo 'CONFIG_DEBUG_INFO=y' >> .config && \
    echo 'CONFIG_DEBUG_INFO_REDUCED=n' >> .config && \
    echo 'CONFIG_DEBUG_INFO_SPLIT=n' >> .config && \
    echo 'CONFIG_DEBUG_FS=y' >> .config && \
    echo 'CONFIG_DEBUG_INFO_DWARF4=y' >> .config && \
    echo 'CONFIG_DEBUG_INFO_BTF=y' >> .config && \
    echo 'CONFIG_FRAME_POINTER=y' >> .config
RUN make -j16 bzImage

WORKDIR /boot
RUN cp /opt/linux-5.4/arch/x86/boot/bzImage .
RUN rm -r /opt/linux-5.4

ADD generate-dhcpd-conf qemu-ifup qemu-ifdown run init ./

WORKDIR /

CMD /boot/run