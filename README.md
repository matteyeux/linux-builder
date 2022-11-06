# Linux builder

Build minimal ARM64 kernel + busybox + qemu

### Running

`bash linux_builder.sh`

The script will create a directory named `dbglinux` and copy all the needed files to start the ARM64 minimal OS.

Then you can run it with qemu : `qemu-system-aarch64 -cpu cortex-a53 -M virt -kernel Image -initrd initramfs.cpio.gz -nographic`:
```
λ ~/dev/linux-builder/dbglinux » qemu-system-aarch64 -cpu cortex-a53 -M virt -kernel Image -initrd initramfs.cpio.gz -nographic
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
[    0.000000] Linux version 6.1.0-rc3 (mathieu@stormbreaker) (aarch64-linux-gnu-gcc (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0, GNU ld (GNU Binutils for Ubuntu) 2.38) #1 SMP PREEMPT Sun Nov  6 15:58:55 CET 2022
[    0.000000] random: crng init done
[    0.000000] Machine model: linux,dummy-virt
[    0.000000] efi: UEFI not found.
[    0.000000] NUMA: No NUMA configuration found
[    0.000000] NUMA: Faking a node at [mem 0x0000000040000000-0x0000000047ffffff]
[    0.000000] NUMA: NODE_DATA [mem 0x47fb0a00-0x47fb2fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000040000000-0x0000000047ffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000040000000-0x0000000047ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000040000000-0x0000000047ffffff]
[    0.000000] cma: Reserved 32 MiB at 0x0000000045c00000
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv1.1 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: Trusted OS migration not required
[    0.000000] psci: SMC Calling Convention v1.0
..
[    0.655567] Loading compiled-in X.509 certificates
[    0.674803] input: gpio-keys as /devices/platform/gpio-keys/input/input0
[    0.682134] ALSA device list:
[    0.682321]   No soundcards found.
[    0.685092] uart-pl011 9000000.pl011: no DMA platform data
[    0.723740] Freeing unused kernel memory: 7552K
[    0.724542] Run /init as init process
 ___  ___  ___ _    _
|   \| _ )/ __| |  (_)_ _ _  ___ __
| |) | _ \ (_ | |__| | ' \ || \ \ /
|___/|___/\___|____|_|_||_\_,_/_\_
~matteyeux
/ # uname -a
Linux (none) 6.1.0-rc3 #1 SMP PREEMPT Sun Nov  6 15:58:55 CET 2022 aarch64 GNU/Linux
/ # 
```
