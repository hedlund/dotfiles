# dotfiles

Simply my dotfiles, and this README is mostly a reminder for my own sake, so there's not a lot of valuable information for anyone else...

## Installation

Clone the repository, then run the appropriate `init-<PLATFORM>.sh` script from the `install` folder.

After installation is finished, bootstrap the dotfiles by running:

```sh
./bootstrap.sh
```

You probably want to reboot your machine at this stage.

## Dual boot Pop!_OS with Windows

In case the Windows partition has disappeared from the boot menu after a Pop!_OS installation, follow these steps:

1. `sudo apt install os-prober`
2. `sudo os-prober`. The output is something similar to `/dev/sdb1@/efi/Microsoft/Boot/bootmgfw.efi:Windows Boot Manager:Windows:efi`
3. `sudo mount /dev/sdb1 /mnt` (replace the drive with the one in the output from step 2).
4. `sudo cp -ax /mnt/EFI/Microsoft /boot/efi/EFI`
5. Reboot & spam the spacebar to get the boot menu.
6. Add timeout with `t` (or `+`), and reduce with `T` (or `-`). Select the default with `d`.

## Thanks to...

* [Mathias Bynens](https://mathiasbynens.be/) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles)
* @ptb and [his _OS X Lion Setup_ repository](https://github.com/ptb/Mac-OS-X-Lion-Setup)
* [Ben Alman](http://benalman.com/) and his [dotfiles repository](https://github.com/cowboy/dotfiles)
* [Chris Gerke](http://www.randomsquared.com/) and his [tutorial on creating an OS X SOE master image](http://chris-gerke.blogspot.com/2012/04/mac-osx-soe-master-image-day-7.html) + [_Insta_ repository](https://github.com/cgerke/Insta)
* [Cătălin Mariș](https://github.com/alrra) and his [dotfiles repository](https://github.com/alrra/dotfiles)
* [Gianni Chiappetta](http://gf3.ca/) for sharing his [amazing collection of dotfiles](https://github.com/gf3/dotfiles)
* [Jan Moesen](http://jan.moesen.nu/) and his [ancient `.bash_profile`](https://gist.github.com/1156154) + [shiny _tilde_ repository](https://github.com/janmoesen/tilde)
* [Lauri ‘Lri’ Ranta](http://lri.me/) for sharing [loads of hidden preferences](http://osxnotes.net/defaults.html)
* [Matijs Brinkhuis](http://hotfusion.nl/) and his [dotfiles repository](https://github.com/matijs/dotfiles)
* [Nicolas Gallagher](http://nicolasgallagher.com/) and his [dotfiles repository](https://github.com/necolas/dotfiles)
* [Sindre Sorhus](http://sindresorhus.com/)
* [Tom Ryder](http://blog.sanctum.geek.nz/) and his [dotfiles repository](https://github.com/tejr/dotfiles)
* [Kevin Suttle](http://kevinsuttle.com/) and his [dotfiles repository](https://github.com/kevinSuttle/dotfiles) and [OSXDefaults project](https://github.com/kevinSuttle/OSXDefaults)
* [Haralan Dobrev](http://hkdobrev.com/)
* [spxak1](https://github.com/spxak1/weywot/blob/main/Pop_OS_Dual_Boot.md)
