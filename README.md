# kbuild

Simple [nash](https://github.com/NeowayLabs/nash) script that automate the build and install of linux kernel versions on archlinux.

# Installation

Using `nashget`:

```sh
λ> nashget github.com/tiago4orion/kbuild
```

or manually:

```sh
λ> cd $NASHPATH+"/lib"
λ> git clone https://github.com/tiago4orion/kbuild.git
```

# Usage

Invoke the function kbuild.

```sh
kbuild(kernelName, kernelVersion, configPath)
```
- kernelName is the name used in the LOCALVERSION kernel config
- kernelVersion is the version of kernel to build. The script will download it from kernel.org
- configPath is the path to the configuration file. If empty string, the script will use the /proc/config.gz.

```sh
λ> import kbuild/kbuild
λ> kbuild("<name-of-the-kernel>", "4.7.4", "")
```

The script will ask for sudo password when needed...

