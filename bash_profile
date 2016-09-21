# Add `~/.bin` to the `$PATH`
export PATH="$HOME/.bin:$PATH";

# Add /usr/local/sbin
export PATH="/usr/local/sbin:$PATH";

# Export the frameworks path
export FRAMEWORKS_PATH="${HOME}/Frameworks";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra,dockerfunc,localfunc}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for many Bash commands
if command -v brew >/dev/null 2>&1 && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

if [[ $OSTYPE =~ darwin* ]]; then
	# Add tab completion for `defaults read|write NSGlobalDomain`
	# You could just use `-g` instead, but I like being explicit
	complete -W "NSGlobalDomain" defaults;

	# Add `killall` tab completion for common apps
	complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

	# Move next only if `homebrew` is installed
	if command -v brew >/dev/null 2>&1; then
	    # Load rupa's z if installed
	    [ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
	fi

	# Setup Docker machine environment
	#eval "$(docker-machine env default)"

	# If boot2docker is running double check its IP
	#DOCKER_IP="$(docker-machine ip default 2>&1)"
	#if [[ "$DOCKER_IP" != *"error in run"* ]]; then
	#    if [[ "$DOCKER_HOST" != *"$DOCKER_IP"* ]]; then
	#        printf "\n\033[0;31mWARNING: boot2docker's IP address is not matching environment!\033[0m\n\n"
	#    fi
	#fi

	# Enable iTerm 2 shell integration
	test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

# Init jenv
#if command -v jenv >/dev/null 2>&1; then
#	eval "$(jenv init -)"
#fi

# Init Cocos2d-x
if [ -d "${FRAMEWORKS_PATH}/Cocos/cocos2d-x-latest" ]; then

	export COCOS_X_ROOT=$FRAMEWORKS_PATH/Cocos
	export COCOS_CONSOLE_ROOT=$COCOS_X_ROOT/cocos2d-x-latest/tools/cocos2d-console/bin
	export COCOS_TEMPLATES_ROOT=$COCOS_X_ROOT/cocos2d-x-latest/templates

	export PATH=$COCOS_CONSOLE_ROOT:$PATH

	export NDK_ROOT=/usr/local/Cellar/android-ndk/r12
	export ANDROID_SDK_ROOT=/usr/local/Cellar/android-sdk/24.4.1_1

	#export PATH=$COCOS_X_ROOT:$PATH
	#export PATH=$COCOS_TEMPLATES_ROOT:$PATH
	#export PATH=$NDK_ROOT:$PATH
	#export PATH=$ANDROID_SDK_ROOT:$PATH
	#export PATH=$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools:$PATH
fi
