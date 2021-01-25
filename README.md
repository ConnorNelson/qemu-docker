# qemu-docker

Docker run a Virtual Machine.
That virtual machine shares its file system with the underlying image's filesystem.

Heavily based on https://github.com/joshkunz/qemu-docker.
This project provides the kernel image.
It also uses the container's FS as the rootfs for the guest.

## Usage

```sh
docker build -t qemu-docker .
docker run -it --rm --cap-add NET_ADMIN --device=/dev/kvm --device=/dev/net/tun qemu-docker
ssh root@$(docker inspect --format '{{.NetworkSettings.IPAddress}}' qemu-docker)
```

## TODO

- [ ] Don't destroy the container's networking
- [ ] Gracefully support no `NET_ADMIN` / `/dev/net/tun`
  - [ ] Still support ssh-ing into the machine
  - [ ] Support network access via SLIRP, maybe?