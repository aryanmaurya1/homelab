# Linux Kernel Compilation

## 1. Required Packages
- For compiling kernel below packages are required:
  - git
  - fakeroot
  - build-essential
  - ncurses-dev
  - xz-utils
  - libssl-dev
  - bc
  - flex
  - libelf-dev
  - bison

- For Debian-based systems:
```bash
apt install git fakeroot build-essential ncurses-dev xz-utils  libssl-dev bc flex libelf-dev bison
```

- **Optional**: Install `pahole` if you want BPT symbol generation.
```bash
apt install pahole
```

## 2. Configure Kernel
- Get current kernel config.
```bash
cp /boot/config-$(uname -r) .config
```

- Modify kernel config.
  - Under kernel hacking menu, disable BPT symbol generation if you haven't installed `pahole`.
  - Set the value of `CONFIG_SYSTEM_TRUSTED_KEYS` (read more in [kernel documentation](https://www.kernel.org/doc/html/v4.15/admin-guide/module-signing.html)) config variable manually to empty string if you have this config value setup.
```bash
make menuconfig
```

## 3. Compile Kernel

```bash
make -j$(nproc)
make modules_install
make install
update-initramfs -u -k all
update-grub
```

- Kernel is installed in `/boot` directory.

| Description                        | Path                                 |
|------------------------------------|--------------------------------------|
| Kernel image                       | `/boot/vmlinuz-<version>`            |
| Initial ramdisk image              | `/boot/initrd.img-<version>`         |
| System map                         | `/boot/System.map-<version>`         |
| Kernel configuration file          | `/boot/config-<version>`             |
| Kernel modules                     | `/lib/modules/<version>/`         |
