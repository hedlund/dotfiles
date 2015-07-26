# dotfiles

Simply my dotfiles, and this README is mostly a reminder for my own sake, so there's not a lot of valuable information for anyone else...

Nothing is true, everything is permitted.


## Installation & setup

Open up a Terminal and simply run:

	git

You should now be prompted to install git - just follow the instructions. After the installation has finished, run:

	git clone https://github.com/hedlund/dotfiles.git ~/.dotfiles && cd ~/.dotfiles

### Installing the softwares

Install the Homebrew formulae (the command-line stuff):

	./install-brew.sh

This is a script that takes quite a while to run, and you'll be asked a few questions. Simply answer yes and supply your password when prompted for it.

Then install the Homebrew Cask formulae (UI applications):

	./install-cask.sh

Again, this is a long script that will ask for your password and a few other prompts. At the end of the script a couple of applications will be run:

1. Simply close the iTerm 2 window.
2. Follow the MAMP Pro uninstall instructions (we only need the regular edition).
3. Log in to you Dropbox account and **wait for the synchronization to completely finish before continuing!**

### Configuring the environment

After Dropbox is finished with it's synchronization, install the dotfiles & the new bash shell:

	./bootstrap.sh

You will be asked to verify that you want to overwrite and patch a few files; simply answer yes. A couple of operations also requires your password.

Setup the main components of the system:

	./setup-osx.sh

And then finish up by setting up the system as *either* a personal machine:

	./setup-personal.sh

*or* a work one:

	./setup-work.sh

This step will install a few additional softwares (depeding on the type of system), and generate a new SSH key which you'll be prompted about.

Finally, reboot to ensure everything takes effect.


## After the reboot

A number of applications will ask you about things after the reboot (if the startup items have been added successfully). Configure these right away to make sure everything runs smoothly...

### 1Password

1. Read the existing password vault from `~/Dropbox/Library/1Password`
2. Add the license
3. Install browser extensions

### Alfred 2

1. Allow it to access your contacts.
2. Configure it to use the Ctrl + Space shortcut.
3. Activate the powerpack

### Google Chrome

1. Make the default browser
2. Sign in to Chrome

### Jotta

1. Login and follow the instructions
2. Setup the folders to backup

### Spectacle

1. Grant universal access

### Dash

1. Grant universal access
2. Download docsets

### Sublime Text

1. Start Sublime Text
2. Wait for a notification that it needs to be restarted
3. Restart it to automatically install all the plugins


## Additional licenses, logins & the App Store

There's a number of applications to that needs licenses:

* TotalFinder
* ChronoSync
* AppZapper
* Parallels Desktop
* IntelliJ IDEA

And a number of applications that requires a login:

* Evernote
* Spotify
* Todoist
* Steam

### Adobe Creative Cloud

1. Run the *Creative Cloud Installer* and wait for it the install the CC client.
2. Login with the Adobe credentials.
3. Install **Photoshop CC** and *Lightroom CC**.

### App Store

There's also a few applications that needs to be installed via the damn App Store, and those are:

* Airmail 2
* Keynote
* Numbers
* Pages
* Xcode
* Dropshare
* Pixelmator
* Voila


## Configure integrations

### Github

#### SSH key

Copy the public SSH key to the clipboard:

	pbcopy < ~/.ssh/id_rsa.pub

Then open the [Github SSH key page](https://github.com/settings/ssh) and press **Add SSH key**. Simply paste the key and store it with a good name.

#### Tokens 

Open the [Github tokens page](https://github.com/settings/tokens) and generate 
two new tokens: one for general Git usage, and one for Homebrew (name them accordlingly).

Use the Git token the next time you push to a Github repository to store it.

Use the Homebrew token to create a new local dotfile which will contain code only relevant to this machine:

	echo "export HOMEBREW_GITHUB_API_TOKEN=<TOKEN>" >> ~/.local

Replace the *<TOKEN>* with the new token of course...

### Bitbucket

Copy the public SSH key to the clipboard:

	pbcopy < ~/.ssh/id_rsa.pub

Then open the [Bitbucket SSH keys page](https://bitbucket.org/account/user/hedlund/ssh-keys/) and press **Add key**. Simply paste the key and store it with a good name.


## Wrapping up

Wrap up the whole installation process by running:

	~/.dotfiles/finalize.sh


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
