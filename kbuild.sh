#!/usr/bin/env nash

WORKDIR  = $NASHPATH+"/lib/kbuild/workdir"
BUILDDIR = $WORKDIR+"/build"
TMPDIR   = $WORKDIR+"/tmp"

-mkdir -p $BUILDDIR $TMPDIR

fn download(version, outFile) {
	linuxURL = "https://cdn.kernel.org/pub/linux/kernel/v4.x"

	wget -c $linuxURL+"/linux-"+$version+".tar.xz" -O $outFile
}

fn kbuild(name, version, config) {
	oldpwd <= pwd | xargs echo -n

	kfname    = "linux-"+$version+".tar.xz"
	ktgzpath  = $TMPDIR+"/"+$kfname

	canonName <= echo -n $version | sed "s/\\.//g"

	-test -f $ktgzpath

	if $status != "0" {
		download($version, $ktgzpath)
	}

	kbuilddir = $BUILDDIR+"/linux-"+$version

	-rm -rf $kbuilddir
	tar xvf $ktgzpath -C $BUILDDIR

	chdir($kbuilddir)

	# build
	make clean
	make mrproper

	sedReplace = "s/LOCALVERSION=.*/LOCALVERSION="+$name+"/g"

	if $config == "" {
		zcat /proc/config.gz | sed $sedReplace > $kbuilddir+"/.config"
	} else {
		cat $config | sed $sedReplace > $kbuilddir+"/.config"
	}

	make olddefconfig
	make -j3

	# install modules
	sudo make modules_install
	sudo cp -v arch/x86_64/boot/bzImage "/boot/vmlinuz-linux"+$canonName

	replaceKver = "s/-linux/-linux"+$canonName+"/g"

	sudo cat "/etc/mkinitcpio.d/linux.preset" | sed $replaceKver > /tmp/preset.tmp

	sudo cp /tmp/preset.tmp "/etc/mkinitcpio.d/linux"+$canonName+".preset"
	sudo mkinitcpio -k $version+"-"+$name -g "/boot/initramfs-linux"+$canonName+".img"
	sudo cp -v System.map "/boot/System.map-linux"+$canonName
	sudo ln -sf "/boot/System.map-linux"+$canonName "/boot/System.map"
	sudo grub-mkconfig -o /boot/grub/grub.cfg
	echo "Installation finished."

	chdir($oldpwd)
}
