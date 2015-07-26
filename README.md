# dotfiles

Nothing is true, everything is permitted.

## Installation

### Setup a new Mac

Open up a Terminal and run:

	git clone https://github.com/hedlund/dotfiles.git ~/.dotfiles
	cd ~/.dotfiles

*If you're prompted to install git, just follow the instructions.*

Install the Homebrew formulae:

	./install-brew.sh
	./install-cask.sh

Install the dotfiles & install the new bash shell:

	./bootstrap.sh

Setup the machine:

	./setup-osx.sh

Setup the system as *either* a personal machine:

	./setup-personal.sh

*or* a work one:

	./setup-work.sh

Finally, reboot to ensure everything takes effect.


#### 1Password

* Read the existing password vault from `~/Dropbox/Library/1Password`
* Add license
* Install browser extensions

#### Google Chrome

* Sign in to Chrome

#### Spectacle

* Grant universal access


#### Dash

* Download docsets


### Mackup

In order to restore (and symlink to Dropbox), some of the more complex application configurations, simply run:

```bash
mackup restore
```



### App Store

* Airmail 2
* Dropshare
* Pixelmator
* Voila


## Thanks to…

* [Mathias Bynens](https://mathiasbynens.be/)
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
* [Kevin Suttle](http://kevinsuttle.com/) and his [dotfiles repository](https://github.com/kevinSuttle/dotfiles) and [OSXDefaults project](https://github.com/kevinSuttle/OSXDefaults), which aims to provide better documentation for [`~/.osx`](https://mths.be/osx)
* [Haralan Dobrev](http://hkdobrev.com/)
* anyone who [contributed a patch](https://github.com/mathiasbynens/dotfiles/contributors) or [made a helpful suggestion](https://github.com/mathiasbynens/dotfiles/issues)
