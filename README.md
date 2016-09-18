# kbuild

Simple script that automate the build and install of linux kernel versions on archlinux.

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

```sh
λ> import kbuild/kbuild
λ> kbuild("<name-of-the-kernel>", "4.7.4", "")
```

The script will ask for sudo password when needed...

