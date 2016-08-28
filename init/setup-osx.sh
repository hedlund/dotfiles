#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Not running on Mac OS X. Aborting!"
    exit 1
fi

CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOTFILES=$( cd "$CURRENT/.." && pwd )

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
#sudo scutil --set ComputerName "0x6D746873"
#sudo scutil --set HostName "0x6D746873"
#sudo scutil --set LocalHostName "0x6D746873"
#sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"

# Set standby delay to 24 hours (default is 1 hour)
#sudo pmset -a standbydelay 86400

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Disable transparency in the menu bar and elsewhere on Yosemite
#defaults write com.apple.universalaccess reduceTransparency -bool true

# Menu bar: hide the Time Machine, Volume, User and Battery icons
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
	defaults write "${domain}" dontAutoLoad -array \
		"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
		"/System/Library/CoreServices/Menu Extras/User.menu" \
		"/System/Library/CoreServices/Menu Extras/Battery.menu"
done
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
	"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
	"/System/Library/CoreServices/Menu Extras/Volume.menu" \
	"/System/Library/CoreServices/Menu Extras/TextInput.menu" \
	"/System/Library/CoreServices/Menu Extras/Clock.menu"

# Set highlight color to green
#defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

# Set sidebar icon size to medium
#defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

# Disable the over-the-top focus ring animation
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Disable smooth scrolling
# (Uncomment if you’re on an older Mac that messes up the animation)
#defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

# Increase window resize speed for Cocoa applications
#defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
#defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
#defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

# Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)
# Commented out, as this is known to cause problems in various Adobe apps :(
# See https://github.com/mathiasbynens/dotfiles/issues/237
#echo "0x08000100:0" > ~/.CFUserTextEncoding

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
#sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Display contact info on login window
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "Email: henrik@hedlund.im"

# Make sure auto login is disabled
sudo defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Never go into computer sleep mode
#sudo systemsetup -setcomputersleep Off > /dev/null

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable Notification Center and remove the menu bar icon
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
#rm -rf ~/Library/Application Support/Dock/desktoppicture.db
#sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
#sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

# Set the clock settings (System Preferences → Date & Time → Clock)
defaults write com.apple.menuextra.clock DateFormat -string "d MMM  HH:mm"
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
defaults write com.apple.menuextra.clock IsAnalog -bool false

# Show the battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

###############################################################################
# Network                                                                     #
###############################################################################

# Use Google's DNS servers
sudo networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4

# Require admin auth to create computer-to-computer networks
sudo /usr/libexec/airportd prefs RequireAdminIBSS=YES

# Require admin auth to change networks
sudo /usr/libexec/airportd prefs RequireAdminNetworkChange=YES

# Require admin auth torn wifi on and off
sudo /usr/libexec/airportd prefs RequireAdminPowerToggle=YES

###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################

# Disable local Time Machine snapshots
sudo tmutil disablelocal

# Disable hibernation (speeds up entering sleep mode)
#sudo pmset -a hibernatemode 0

# Remove the sleep image file to save disk space
#sudo rm /private/var/vm/sleepimage
# Create a zero-byte file instead…
#sudo touch /private/var/vm/sleepimage
# …and make sure it can’t be rewritten
#sudo chflags uchg /private/var/vm/sleepimage

# Disable the sudden motion sensor as it’s not useful for SSDs
sudo pmset -a sms 0

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Trackpad: enable dragging
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool true
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool true

# Trackpad: map bottom right corner to right-click
#defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
#defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
#defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
#defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Disable “natural” (Lion-style) scrolling
#defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Increase sound quality for Bluetooth headphones/headsets
#defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
#defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
#defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Disable press-and-hold for keys in favor of key repeat
#defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
#defaults write NSGlobalDomain KeyRepeat -int 0

# Use the F-keys as standard function keys..
defaults write NSGlobalDomain "com.apple.keyboard.fnState" -int 1

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "en" "nb" "sv"
defaults write NSGlobalDomain AppleLocale -string "en_SE"
#defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
#defaults write NSGlobalDomain AppleMetricUnits -bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Oslo" > /dev/null

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Stop iTunes from responding to the keyboard media keys
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# Change "Move focus to next window" shortcut to Alt + Tab
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27 dict" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:enabled bool true" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:value dict" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:value:type string standard" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:value:parameters array" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:value:parameters:0 integer 65535" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:value:parameters:1 integer 48" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:27:value:parameters:2 integer 524288" ~/Library/Preferences/com.apple.symbolichotkeys.plist


###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
#defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
#defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
#defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# Don't show mirroring options in the menu bar when available
defaults write com.apple.airplay showInMenuBarIfPresent -bool false


###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show hidden files by default
#defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable disk image verification
#defaults write com.apple.frameworks.diskimages skip-verify -bool true
#defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
#defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show item info near icons on the desktop and in other icon views
#/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
#/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
#/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
#/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Enable the MacBook Air SuperDrive on any Mac
sudo nvram boot-args="mbasd=1"

# Show the ~/Library folder
chflags nohidden ~/Library

# Remove Dropbox’s green checkmark icons in Finder
#file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
#[ -e "${file}" ] && mv -f "${file}" "${file}.bak"

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

# Hide the dotfiles folder
chflags hidden $DOTFILES

# Install Finder workflow to be able to toggle hidden files
cp -r $CURRENT/config/Toggle\ Hidden\ Files.workflow/ $HOME/Library/Services/Toggle\ Hidden\ Files.workflow/
/usr/libexec/PlistBuddy -c "Add :NSServicesStatus dict" ~/Library/Preferences/pbs.plist 2> /dev/null
/usr/libexec/PlistBuddy -c "Add \":NSServicesStatus:(null) - Toggle Hidden Files - runWorkflowAsService\" dict" ~/Library/Preferences/pbs.plist 2> /dev/null
/usr/libexec/PlistBuddy -c "Add \":NSServicesStatus:(null) - Toggle Hidden Files - runWorkflowAsService:key_equivalent\" string \"@$.\"" ~/Library/Preferences/pbs.plist 2> /dev/null

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Enable highlight hover effect for the grid view of a stack (Dock)
#defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36

# Enable dock magnification
defaults write com.apple.dock magnification -bool true

# Set the maginification scale to 76
defaults write com.apple.dock largesize -int 76

# Set the dock to be positioned to the left
defaults write com.apple.dock orientation -string left

# Change minimize/maximize window effect
#defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
#defaults write com.apple.dock minimize-to-application -bool true

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
#defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array

# Show only open applications in the Dock
#defaults write com.apple.dock static-only -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
#defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
#defaults write com.apple.dock expose-group-by-app -bool false

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
#defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
#defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
#defaults write com.apple.dock showhidden -bool true

# Disable the Launchpad gesture (pinch with thumb and three fingers)
#defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

# Reset Launchpad, but keep the desktop wallpaper intact
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

# Add iOS Simulator to Launchpad
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/iOS Simulator.app" "/Applications/iOS Simulator.app"

# Add a spacer to the left side of the Dock (where the applications are)
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
#defaults write com.apple.dock wvous-tl-corner -int 2
#defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Start screen saver
defaults write com.apple.dock wvous-tr-corner -int 5
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
#defaults write com.apple.dock wvous-bl-corner -int 5
#defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

# Disable send and reply animations in Mail.app
#defaults write com.apple.mail DisableReplyAnimations -bool true
#defaults write com.apple.mail DisableSendAnimations -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
#defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
#defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9"

# Display emails in threaded mode, sorted by date (oldest at the top)
#defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
#defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
#defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

# Disable inline attachments (just show the icons)
#defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Disable automatic spell checking
#defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

###############################################################################
# Firewall                                                                    #
###############################################################################

# Application Level Firewall state.
# Possible value:
#  0: Disabled
#  1: Enabled
#  2: Enabled & blocking all incoming connections
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2

# Allow signed apps
#sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool true

# Enable logging
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true

# Enable stealth mode
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true

###############################################################################
# Location Services                                                           #
###############################################################################

# Show location icon in menu bar when System Services request your location
sudo defaults write /Library/Preferences/com.apple.locationmenu ShowSystemServices -bool true

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Hide Spotlight tray-icon (and subsequent helper)
#sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Change indexing order and disable some search results
# Yosemite-specific search results (remove them if you are using OS X 10.9 or older):
# 	MENU_DEFINITION
# 	MENU_CONVERSION
# 	MENU_EXPRESSION
# 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
# 	MENU_WEBSEARCH             (send search queries to Apple)
# 	MENU_OTHER
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
	'{"enabled" = 1;"name" = "FONTS";}' \
	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 0;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 0;"name" = "SOURCE";}' \
	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null

###############################################################################
# Terminal                                                                    #
###############################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Use a modified version of the Solarized Dark theme by default in Terminal.app
osascript <<EOD

tell application "Terminal"

	local allOpenedWindows
	local initialOpenedWindows
	local windowID
	set themeName to "Solarized Dark xterm-256color"

	(* Store the IDs of all the open terminal windows. *)
	set initialOpenedWindows to id of every window

	(* Open the custom theme so that it gets added to the list
	   of available terminal themes (note: this will open two
	   additional terminal windows). *)
	do shell script "open '$CURRENT/config/" & themeName & ".terminal'"

	(* Wait a little bit to ensure that the custom theme is added. *)
	delay 1

	(* Set the custom theme as the default terminal theme. *)
	set default settings to settings set themeName

	(* Get the IDs of all the currently opened terminal windows. *)
	set allOpenedWindows to id of every window

	repeat with windowID in allOpenedWindows

		(* Close the additional windows that were opened in order
		   to add the custom theme to the list of terminal themes. *)
		if initialOpenedWindows does not contain windowID then
			close (every window whose id is windowID)

		(* Change the theme for the initial opened terminal windows
		   to remove the need to close them in order for the custom
		   theme to be applied. *)
		else
			set current settings of tabs of (every window whose id is windowID) to settings set themeName
		end if

	end repeat

end tell

EOD

# Enable “focus follows mouse” for Terminal.app and all X11 apps
# i.e. hover over a window and start typing in it without clicking first
#defaults write com.apple.terminal FocusFollowsMouse -bool true
#defaults write org.x.X11 wm_ffm -bool true

# Enable Secure Keyboard Entry
defaults write com.apple.terminal SecureKeyboardEntry -bool true

###############################################################################
# iTerm                                                                       #
###############################################################################

# Install the Solarized Dark theme for iTerm
open -a iTerm && open "${CURRENT}/config/Solarized Dark.itermcolors"

# Make sure the DynamicProfiles folder exists & symlink the dynamic profile there
ITERM2_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$ITERM2_DIR"
ln -sf "${CURRENT}/config/iterm2-default.json" "$ITERM2_DIR/iterm2-default.json"

# Set the profile "Dynamic Default" from the JSON file above as the default
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "9166D500-B4DB-4C9D-AD36-7C9783733096"

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Set Dark theme for tabs...
defaults write com.googlecode.iterm2 TabStyle -int 1

# ...and always show them
defaults write com.googlecode.iterm2 HideTab -bool false

# Set the dimming to be a bit less invasive
defaults write com.googlecode.iterm2 SplitPaneDimmingAmount -string "0.2"

# Configure the Toolbelt
defaults write com.googlecode.iterm2 ToolbeltTools -array "Command History" "Recent Directories" "Notes"

# Enable Secure Keyboard Entry
defaults write com.googlecode.iterm2 "Secure Input" -bool true

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

# Enable the debug menu in Address Book
defaults write com.apple.addressbook ABShowDebugMenu -bool true

# Enable Dashboard dev mode (allows keeping widgets on the desktop)
defaults write com.apple.dashboard devmode -bool true

# Enable the debug menu in iCal (pre-10.8)
defaults write com.apple.iCal IncludeDebugMenu -bool true

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Disable gamed from continously spamming Apple's servers
defaults write com.apple.gamed Disabled -bool true

###############################################################################
# Messages                                                                    #
###############################################################################

# Disable automatic emoji substitution (i.e. use plain text smileys)
#defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# Disable smart quotes as it’s annoying for messages that contain code
#defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable continuous spell checking
#defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
# Google Chrome & Google Chrome Canary                                        #
###############################################################################

# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use the system-native print preview dialog
#defaults write com.google.Chrome DisablePrintPreview -bool true
#defaults write com.google.Chrome.canary DisablePrintPreview -bool true

# Expand the print dialog by default
#defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
#defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# GPGMail 2                                                                   #
###############################################################################

# Disable signing emails by default
#defaults write ~/Library/Preferences/org.gpgtools.gpgmail SignNewEmailsByDefault -bool false

###############################################################################
# Opera & Opera Developer                                                     #
###############################################################################

# Expand the print dialog by default
#defaults write com.operasoftware.Opera PMPrintingExpandedStateForPrint2 -boolean true
#defaults write com.operasoftware.OperaDeveloper PMPrintingExpandedStateForPrint2 -boolean true

###############################################################################
# SizeUp.app                                                                  #
###############################################################################

# Start SizeUp at login
defaults write com.irradiatedsoftware.SizeUp StartAtLogin -bool true

# Don’t show the preferences window on next start
defaults write com.irradiatedsoftware.SizeUp ShowPrefsOnNextStart -bool false

###############################################################################
# Sublime Text                                                                #
###############################################################################

SUBLIME_DIR="${HOME}/Library/Application Support/Sublime Text 3"
mkdir -p "${SUBLIME_DIR}/Installed Packages"
mkdir -p "${SUBLIME_DIR}/Packages/User"
mkdir -p "${SUBLIME_DIR}/Local"

# Download Package Control
wget -O "${SUBLIME_DIR}/Installed Packages/Package Control.sublime-package" https://packagecontrol.io/Package%20Control.sublime-package

# Download material theme
wget -O /tmp/sublime-material.zip https://github.com/equinusocio/material-theme/archive/v0.9.0.zip && \
	unzip /tmp/sublime-material.zip -d "${SUBLIME_DIR}/Packages" && \
	mv "${SUBLIME_DIR}/Packages/material-theme-0.9.0" "${SUBLIME_DIR}/Packages/material-theme" && \
	rm /tmp/sublime-material.zip

# Install Sublime Text settings
ln -sf "${CURRENT}/config/Preferences.sublime-settings" "${SUBLIME_DIR}/Packages/User/Preferences.sublime-settings"
ln -sf "${CURRENT}/config/Package Control.sublime-settings" "${SUBLIME_DIR}/Packages/User/Package Control.sublime-settings"

# Install license (from Dropbox)
cp ~/Dropbox/Library/Licenses/License.sublime_license "${SUBLIME_DIR}/Local" &2>/dev/null

###############################################################################
# Transmission.app                                                            #
###############################################################################

# Use `~/Documents/Torrents` to store incomplete downloads
#defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
#defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

# Don’t prompt for confirmation before downloading
#defaults write org.m0k.transmission DownloadAsk -bool false

# Trash original torrent files
#defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
#defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
#defaults write org.m0k.transmission WarningLegal -bool false

###############################################################################
# Twitter.app                                                                 #
###############################################################################

# Disable smart quotes as it’s annoying for code tweets
#defaults write com.twitter.twitter-mac AutomaticQuoteSubstitutionEnabled -bool false

# Show the app window when clicking the menu bar icon
#defaults write com.twitter.twitter-mac MenuItemBehavior -int 1

# Enable the hidden ‘Develop’ menu
#defaults write com.twitter.twitter-mac ShowDevelopMenu -bool true

# Open links in the background
#defaults write com.twitter.twitter-mac openLinksInBackground -bool true

# Allow closing the ‘new tweet’ window by pressing `Esc`
#defaults write com.twitter.twitter-mac ESCClosesComposeWindow -bool true

# Show full names rather than Twitter handles
#defaults write com.twitter.twitter-mac ShowFullNames -bool true

# Hide the app in the background if it’s not the front-most window
#defaults write com.twitter.twitter-mac HideInBackground -bool true

###############################################################################
# Spectacle.app                                                               #
###############################################################################

# Set up my preferred keyboard shortcuts
defaults write com.divisiblebyzero.Spectacle MakeLarger -data 62706c6973743030d40102030405061819582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708101155246e756c6cd4090a0b0c0d0e0d0f596d6f64696669657273546e616d65576b6579436f64655624636c6173731000800280035a4d616b654c6172676572d2121314155a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a216175f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11a1b54726f6f74800108111a232d32373c424b555a62696b6d6f7a7f8a93a7aabec7d9dce10000000000000101000000000000001c000000000000000000000000000000e3
defaults write com.divisiblebyzero.Spectacle MakeSmaller -data 62706c6973743030d40102030405061819582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708101155246e756c6cd4090a0b0c0d0e0d0f596d6f64696669657273546e616d65576b6579436f64655624636c6173731000800280035b4d616b65536d616c6c6572d2121314155a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a216175f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11a1b54726f6f74800108111a232d32373c424b555a62696b6d6f7b808b94a8abbfc8dadde20000000000000101000000000000001c000000000000000000000000000000e4
defaults write com.divisiblebyzero.Spectacle MoveToBottomHalf -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731119008002107d80035f10104d6f7665546f426f74746f6d48616c66d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e7072858a959eb2b5c9d2e4e7ec0000000000000101000000000000001d000000000000000000000000000000ee
defaults write com.divisiblebyzero.Spectacle MoveToCenter -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731119008002100880035c4d6f7665546f43656e746572d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70727f848f98acafc3ccdee1e60000000000000101000000000000001d000000000000000000000000000000e8
defaults write com.divisiblebyzero.Spectacle MoveToFullscreen -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731119008002102e80035f10104d6f7665546f46756c6c73637265656ed2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e7072858a959eb2b5c9d2e4e7ec0000000000000101000000000000001d000000000000000000000000000000ee
defaults write com.divisiblebyzero.Spectacle MoveToLeftHalf -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731119008002107b80035e4d6f7665546f4c65667448616c66d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70728186919aaeb1c5cee0e3e80000000000000101000000000000001d000000000000000000000000000000ea
defaults write com.divisiblebyzero.Spectacle MoveToLowerLeft -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c617373111a008002107d80035f100f4d6f7665546f4c6f7765724c656674d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70728489949db1b4c8d1e3e6eb0000000000000101000000000000001d000000000000000000000000000000ed
defaults write com.divisiblebyzero.Spectacle MoveToLowerRight -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c617373111a008002107c80035f10104d6f7665546f4c6f7765725269676874d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e7072858a959eb2b5c9d2e4e7ec0000000000000101000000000000001d000000000000000000000000000000ee
defaults write com.divisiblebyzero.Spectacle MoveToNextDisplay -data 62706c6973743030d40102030405061819582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708101155246e756c6cd4090a0b0c0d0e0d0f596d6f64696669657273546e616d65576b6579436f64655624636c6173731000800280035f10114d6f7665546f4e657874446973706c6179d2121314155a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a216175f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11a1b54726f6f74800108111a232d32373c424b555a62696b6d6f8388939cb0b3c7d0e2e5ea0000000000000101000000000000001c000000000000000000000000000000ec
defaults write com.divisiblebyzero.Spectacle MoveToNextThird -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731118008002107c80035f100f4d6f7665546f4e6578745468697264d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70728489949db1b4c8d1e3e6eb0000000000000101000000000000001d000000000000000000000000000000ed
defaults write com.divisiblebyzero.Spectacle MoveToPreviousDisplay -data 62706c6973743030d40102030405061819582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708101155246e756c6cd4090a0b0c0d0e0d0f596d6f64696669657273546e616d65576b6579436f64655624636c6173731000800280035f10154d6f7665546f50726576696f7573446973706c6179d2121314155a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a216175f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11a1b54726f6f74800108111a232d32373c424b555a62696b6d6f878c97a0b4b7cbd4e6e9ee0000000000000101000000000000001c000000000000000000000000000000f0
defaults write com.divisiblebyzero.Spectacle MoveToPreviousThird -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731118008002107b80035f10134d6f7665546f50726576696f75735468697264d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e7072888d98a1b5b8ccd5e7eaef0000000000000101000000000000001d000000000000000000000000000000f1
defaults write com.divisiblebyzero.Spectacle MoveToRightHalf -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731119008002107c80035f100f4d6f7665546f526967687448616c66d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70728489949db1b4c8d1e3e6eb0000000000000101000000000000001d000000000000000000000000000000ed
defaults write com.divisiblebyzero.Spectacle MoveToTopHalf -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731119008002107e80035d4d6f7665546f546f7048616c66d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e707280859099adb0c4cddfe2e70000000000000101000000000000001d000000000000000000000000000000e9
defaults write com.divisiblebyzero.Spectacle MoveToUpperLeft -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c617373111a008002107b80035f100f4d6f7665546f55707065724c656674d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70728489949db1b4c8d1e3e6eb0000000000000101000000000000001d000000000000000000000000000000ed
defaults write com.divisiblebyzero.Spectacle MoveToUpperRight -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c617373111a008002107e80035f10104d6f7665546f55707065725269676874d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e7072858a959eb2b5c9d2e4e7ec0000000000000101000000000000001d000000000000000000000000000000ee
defaults write com.divisiblebyzero.Spectacle RedoLastMove -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c617373110b008002100680035c5265646f4c6173744d6f7665d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70727f848f98acafc3ccdee1e60000000000000101000000000000001d000000000000000000000000000000e8
defaults write com.divisiblebyzero.Spectacle UndoLastMove -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731109008002100680035c556e646f4c6173744d6f7665d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70727f848f98acafc3ccdee1e60000000000000101000000000000001d000000000000000000000000000000e8

# Enable automatic update checks
defaults write com.divisiblebyzero.Spectacle SUEnableAutomaticChecks -bool true

# Hide icon in menu bar
defaults write com.divisiblebyzero.Spectacle StatusItemEnabled -bool false

###############################################################################
# Caffeine                                                                    #
###############################################################################

# Do not activate on launch
defaults write com.lightheadsw.caffeine ActivateOnLaunch -bool false

# Set the default duration to one hour
defaults write com.lightheadsw.caffeine DefaultDuration -int 60

# Do not show launch message
defaults write com.lightheadsw.caffeine SuppressLaunchMessage -bool true

###############################################################################
# Transmit                                                                    #
###############################################################################

# Enable automatic updates
defaults write com.panic.Transmit SUAutomaticallyUpdate -bool true

# Hide icon in menu bar
defaults write com.panic.Transmit ShowTransmitMenu -bool false

# Show hidden files
defaults write com.panic.Transmit ShowHiddenFiles2 -bool true

###############################################################################
# Dash                                                                        #
###############################################################################

# Start at login
defaults write com.kapeli.dashdoc shouldStartAtLogin -bool true

# Show icon in menu bar
defaults write com.kapeli.dashdoc shouldShowStatusIcon -bool true

# Menu bar icon click toggles menu
defaults write com.kapeli.dashdoc shouldToggleMethods -bool true

# Do not show in dock
defaults write com.kapeli.dashdoc showInDock -bool false

# Sync the bookmarks
defaults write com.kapeli.dashdoc shouldSyncBookmarks -bool true

# Sync the docsets
defaults write com.kapeli.dashdoc shouldSyncDocsets -bool true

# Sync general settings
defaults write com.kapeli.dashdoc shouldSyncGeneral -bool true

# Sync view settings
defaults write com.kapeli.dashdoc shouldSyncView -bool true

# Set the sync folder path
defaults write com.kapeli.dashdoc syncFolderPath -string "$HOME/Dropbox/Library/Dash"

# Set the Snippets library path
defaults write com.kapeli.dashdoc snippetSQLPath -string "$HOME/Dropbox/Library/Dash/library.dash"

###############################################################################
# Alfred 2                                                                    #
###############################################################################

# Set the theme
defaults write com.runningwithcrayons.Alfred-Preferences "appearance.theme" -string "alfred.theme.darkandsmooth"

# Set the sync folder
defaults write com.runningwithcrayons.Alfred-Preferences syncfolder -string "~/Dropbox/Library/Alfred"

# Set the hotkey to Cmd + Space
defaults write com.runningwithcrayons.Alfred-Preferences "hotkey.default" '{ key = 49; mod = 262144; string = Space; }'

###############################################################################
# ChronoSync                                                                  #
###############################################################################

# Don't run the scheduler in the background
defaults write com.econtechnologies.chronosync prefUseBackgrounderKey -bool false

###############################################################################
# iStat Menus                                                                 #
###############################################################################

# Purple graphs
defaults write com.bjango.istatmenus5.extras MenubarSkinColor -int 5

# White graph backgrounds
defaults write com.bjango.istatmenus5.extras MenubarTheme -int 0

# Black dropdown theme
defaults write com.bjango.istatmenus5.extras DropdownTheme -int 1

# Slow update frequency
defaults write com.bjango.istatmenus5.extras TimerFrequency -int 0

# Show just the memory graph, no label
defaults write com.bjango.istatmenus5.extras "Memory_MenubarMode" -int 1

# Show just the disk graph, no label
defaults write com.bjango.istatmenus5.extras "Disks_MenubarMode" -int 0

# Show just the CPU graph, no label
defaults write com.bjango.istatmenus5.extras "CPU_MenubarMode" -int 0

# Show just the network graph, no label
defaults write com.bjango.istatmenus5.extras "Network_MenubarMode" -int 1

# Show percentage left of battery indicator
defaults write com.bjango.istatmenus5.extras "Battery_MenubarMode" -int 2

# Set the order of the status items
defaults write com.bjango.istatmenus5.extras "StatusItems-Order" -array 2 3 1 4 6


###############################################################################
# Path Finder                                                                 #
###############################################################################

# Start at login
defaults write com.cocoatech.PathFinder kLaunchAfterLogin -int 1

# Set as default file viewer
defaults write com.cocoatech.PathFinder pathFinderIsDefaultFileViewer -int 1

# Terminal is the default terminal
defaults write com.cocoatech.PathFinder kTerminalApplicationPath -string "/Applications/Utilities/Terminal.app"

# Quit Finder when Path Finder starts
defaults write com.cocoatech.PathFinder kQuitFinderWhenLaunched -int 1

# Enter renames file (not opens it)
defaults write com.cocoatech.PathFinder kReturnKeyStartsRename -int 1

# Set show/hidden files to Cmd+Shift+.
# TODO: this is probably very error prone...
defaults write com.cocoatech.PathFinder kMenuKeyMappingPrefKey -data 62706c6973743030d400010002000300040005000603c703c8582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0af1101440007000800b500b600b700b800b900ba00bb00bc00bd00be00bf00c000c100c200c300c400c500c600c700c800c900ca00cb00cc00cd00ce00cf00d000d100d200d300d400d500d600d700d800d900da00db00dc00dd00de00df00e000e100e200e300e400e500e600e700e800e900ea00eb00ec00ed00ee00ef00f000f100f200f300f400f500f600f700f800f900fa00fb00fc00fd00fe00ff01000101010201030104010501060107010801140118011f012001210125012b010e012c012d013301360137013d013e013f0140014601470148014e014f01500151015701580159015f016201630169016a016b0171017201730179017a017b0181018201830184018a018b018c019201930194019a019b019c01a201a301a401aa01ab01ac01b201b501b601bc01bf01c001c601c701c801ce01cf01d001d601d701dd01de01df01e501e601e701ee01ef01f001f601f701f801fe01ff020002060209020a02100211021202180219021f022002210227022a022b0231023202330239023a023b0241024202430249024a024b0251025202580259025a0260026102620269026a026b027202780279027a028002830284028a028b028c029202930294029a029b029c02a202a302a902aa02ab02b102b402b502bb02be02bf02c502c802c902ca02d002d102d202d802d902da02e002e302e402ea02eb02ec02f202f302f402fa02fb0301030203030309030a030b0311031203180319031a03200321032703280329032f033003360339033a0340034303440345034b034c035203530359035a035b0361036203630369036a03700371037703780379037f0380038103870388038e038f039503960397039d039e03a403a503ab03ac03ad03b303b403ba03bb03c103c203c355246e756c6cd30009000a000b000c006000b4574e532e6b6579735a4e532e6f626a656374735624636c617373af1053000d000e000f0010001100120013001400150016001700180019001a001b001c001d001e001f0020002100220023002400250026002700280029002a002b002c002d002e002f0030003100320033003400350036003700380039003a003b003c003d003e003f0040004100420043004400450046004700480049004a004b004c004d004e004f0050005100520053005400550056005700580059005a005b005c005d005e005f80028003800480058006800780088009800a800b800c800d800e800f8010801180128013801480158016801780188019801a801b801c801d801e801f8020802180228023802480258026802780288029802a802b802c802d802e802f8030803180328033803480358036803780388039803a803b803c803d803e803f8040804180428043804480458046804780488049804a804b804c804d804e804f80508051805280538054af1053006100620063006400650066006700680069006a006b006c006d006e006f0070007100720073007400750076007700780079007a007b007c007d007e007f0080008100820083008400850086008700880089008a008b008c008d008e008f0090009100920093009400950096009700980099009a009b009c009d009e009f00a000a100a200a300a400a500a600a700a800a900aa00ab00ac00ad00ae00af00b000b100b200b38055805b805f806280668069806d8070807380768079807c8080808380868089808c808f809280958098809b809d80a080a380a680a980ac80af80b280b480b780ba80bd80c080c380c680c880cb80ce80d180d280d580d880db80de80e180e380e680e980ec80f080f380f680f980fc80ff81010181010481010781010981010c81010e81011181011381011681011a81011c81011e81012181012481012681012881012b81012e81013081013281013581013781013981013c81013e8101408101435f1012476f2f476f20746f20466f6c6465722e2e2e5f101f436f6d6d616e64732f436f6d707265737320746f204f746865722050616e655f100f46696c652f536176652041732e2e2e5d46696c652f47657420496e666f5f102c456469742f5370656c6c696e6720616e64204772616d6d61722f436865636b20446f63756d656e74204e6f775f101b456469742f466f726d61742f466f6e742f436f7079205374796c655f101246696c652f53686f77204f726967696e616c5f101246696c652f4e657720466f6c6465722e2e2e5f1017506174682046696e6465722f456d7074792054726173685c566965772f6173204c6973745f101c456469742f466f726d61742f466f6e742f5061737465205374796c655f1016566965772f456e7465722046756c6c2053637265656e5e46696c652f4f70656e2f4f70656e5f100f46696c652f4d616b6520416c6961735a46696c652f456a6563745f101a506174682046696e6465722f507265666572656e6365732e2e2e5f1016566965772f53686f772056696577204f7074696f6e736f101a0045006400690074002f00460069006e0064002f00460069006e006400200069006e002000420072006f007700730065007220265f100f476f2f4170706c69636174696f6e735f101b436f6d6d616e64732f436f707920746f204f746865722050616e655f101548656c702f506174682046696e6465722048656c705f101546696c652f52657665616c20696e2046696e6465725f100f456469742f53656c65637420416c6c5f101c506174682046696e6465722f5175697420506174682046696e6465725f1013456469742f46696e642f46696e64204e6578745d46696c652f5072696e742e2e2e5f101046696c652f4e65772046696c652e2e2e5f1012436f6d6d616e64732f52656e616d652e2e2e5f101357696e646f772f4d696e696d697a6520416c6c5e456469742f4564697420506174685f100f566965772f537761702050616e65735c476f2f5574696c69746965735f101b456469742f466f726d61742f466f6e742f53686f7720466f6e74735d566965772f61732049636f6e735f1011476f2f4f70656e2053656c656374696f6e5f1017456469742f466f726d61742f546578742f43656e7465725f101e46696c652f4e657720466f6c64657220776974682053656c656374696f6e5946696c652f536176655f1017506174682046696e6465722f48696465204f74686572735f1019566965772f53686f7720496e76697369626c652046696c65735f1011456469742f46696e642f46696e642e2e2e57476f2f4261636b59456469742f5265646f5f1021436f6d6d616e64732f4465636f6d707265737320746f204f746865722050616e655f1015456469742f466f726d61742f466f6e742f426f6c645a476f2f466f72776172645f101c46696c652f4e65772042726f777365722f4e65772042726f777365725f101b436f6d6d616e64732f4d6f766520746f204f746865722050616e655f101c456469742f466f726d61742f466f6e742f53686f7720436f6c6f72735f101746696c652f4d616b652053796d626f6c6963204c696e6b5f101146696c652f4e6577205465726d696e616c5f101657696e646f772f53656c656374204e657874205461625f1033456469742f5370656c6c696e6720616e64204772616d6d61722f53686f77205370656c6c696e6720616e64204772616d6d61725f101a456469742f506173746520616e64204d61746368205374796c655f1013476f2f456e636c6f73696e6720466f6c6465725f101246696c652f4d6f766520746f2054726173685f101b46696c652f4f70656e2f4f70656e20546578742046696c652e2e2e5f1012436f6d6d616e64732f4475706c69636174656f10200043006f006d006d0061006e00640073002f0043006f006d0070006100720065002000530065006c006500630074006500640020004900740065006d007320265f101346696c652f53686f7720496e73706563746f725f1011566965772f4475616c2042726f777365725f101c456469742f466f726d61742f546578742f50617374652052756c65725f1018566965772f42726f77736520696e204e6578742050616e655f100f57696e646f772f4d696e696d697a655f101246696c652f506167652053657475702e2e2e5f101246696c652f4e657720546578742046696c655f101346696c652f41646420746f20536964656261725f101146696c652f546162732f4e6577205461625f1017476f2f436f6e6e65637420746f205365727665722e2e2e59456469742f556e646f5f101b456469742f466f726d61742f546578742f436f70792052756c65725f101657696e646f772f46696c65204f7065726174696f6e735f101146696c652f436c6f73652057696e646f7758456469742f4375745e46696c652f436c6f736520416c6c59456469742f436f70795f100f566965772f617320436f6c756d6e735a456469742f50617374655f101c506174682046696e6465722f4869646520506174682046696e6465725f101a456469742f466f726d61742f466f6e742f556e6465726c696e655d46696c652f5361766520416c6c5f101546696c652f4765742053756d6d61727920496e666f5f101a57696e646f772f53656c6563742050726576696f757320546162d60109010a000b010b010c010d010e010f011001110112000d537461675f10196b65794571756976616c656e744d6f6469666965724d61736b5c616374696f6e537472696e675d6b65794571756976616c656e745c6d656e754974656d5061746810008058805a805980568002d2000b011501160117594e532e737472696e6780575167d20119011a011b011c5a24636c6173736e616d655824636c61737365735f100f4e534d757461626c65537472696e67a3011b011d011e584e53537472696e67584e534f626a65637412001200005f1011676f546f466f6c646572416374696f6e3ad20119011a012201235e4e544d656e754b6579456e747279a20124011e5e4e544d656e754b6579456e747279d60109010a000b010b010c010d010e0126011001280129000e805d805a805e805c800361f70a5f101a636f6d7072657373546f4f7468657250616e65416374696f6e3ad60109010a000b010b010c010d010e010f011001300131000f8058805a806180608004d2000b011501160135805751735f100f73617665446f63756d656e7441733ad60109010a000b010b010c010d010e01380110013a013b00108064805a806580638005516912001000005f101773686f77476574496e666f50616e656c416374696f6e3ad60109010a000b010b010c010d010e013801100143014400118064805a806880678006513b5e636865636b5370656c6c696e673ad60109010a000b010b010c010d010e01490110014b014c0012806b805a806c806a80075163120018000059636f7079466f6e743ad60109010a000b010b010c010d010e013801100154015500138064805a806f806e800851725f101373686f774f726967696e616c416374696f6e3ad60109010a000b010b010c010d010e010f0110015c015d00148058805a807280718009d2000b0115011601618057516e5f10106e6577466f6c646572416374696f6e3ad60109010a000b010b010c010d010e010f01100166016700158058805a80758074800a51085f1011656d7074795472617368416374696f6e3ad60109010a000b010b010c010d010e01380110016e016f00168064805a80788077800b51325f100f6c69737456696577416374696f6e3ad60109010a000b010b010c010d010e01490110017601770017806b805a807b807a800c51765a7061737465466f6e743ad60109010a000b010b010c010d010e017c0110017e017f0018807e805a807f807d800d516612001400005f1011746f67676c6546756c6c53637265656e3ad60109010a000b010b010c010d010e013801100187018800198064805a80828081800e516f5d6f70656e446f63756d656e743ad60109010a000b010b010c010d010e01380110018f0190001a8064805a80858084800f516c5f10106d616b65416c696173416374696f6e3ad60109010a000b010b010c010d010e0138011001970198001b8064805a80888087801051655c656a656374416374696f6e3ad60109010a000b010b010c010d010e01380110019f01a0001c8064805a808b808a8011512c5f101573686f77507265666572656e63657350616e656c3ad60109010a000b010b010c010d010e0138011001a701a8001d8064805a808e808d8012516a5f101673686f77566965774f7074696f6e73416374696f6e3ad60109010a000b010b010c010d010e010f011001af01b0001e8058805a809180908013d2000b0115011601b4805751665f101b706572666f726d46696e64496e42726f77736572416374696f6e3ad60109010a000b010b010c010d010e010f011001b901ba001f8058805a809480938014d2000b0115011601be805751615f10136170706c69636174696f6e73416374696f6e3ad60109010a000b010b010c010d010e0126011001c301c40020805d805a80978096801561f7085f1016636f7079546f4f7468657250616e65416374696f6e3ad60109010a000b010b010c010d010e0138011001cb01cc00218064805a809a80998016513f5f100f73686f7748656c70416374696f6e3ad60109010a000b010b010c010d010e0149011001d3017f0022806b805a809c807d80175f101373686f77496e46696e646572416374696f6e3ad60109010a000b010b010c010d010e0138011001da01db00238064805a809f809e801851615a73656c656374416c6c3ad60109010a000b010b010c010d010e0138011001e201e300248064805a80a280a1801951715f10107465726d696e617465416374696f6e3ad60109010a000b010b010c010d01e80138011001eb01ec002510028064805a80a580a4801a51675f1017706572666f726d46696e6450616e656c416374696f6e3ad60109010a000b010b010c010d010e0138011001f301f400268064805a80a880a7801b51705e7072696e74446f63756d656e743ad60109010a000b010b010c010d010e0149011001fb01fc0027806b805a80ab80aa801c516e5e6e657746696c65416374696f6e3ad60109010a000b010b010c010d010e010f01100203020400288058805a80ae80ad801dd2000b011501160208805751725d72656e616d65416374696f6e3ad60109010a000b010b010c010d010e01490110020d020e0029806b805a80b180b0801e516d5f10126d696e696d697a65416c6c416374696f6e3ad60109010a000b010b010c010d010e0149011002150190002a806b805a80b38084801f5f100f6564697450617468416374696f6e3ad60109010a000b010b010c010d010e01260110021c021d002b805d805a80b680b5802061f7055f1014737761704475616c50616e6573416374696f6e3ad60109010a000b010b010c010d010e010f011002240225002c8058805a80b980b88021d2000b011501160229805751755f10107574696c6974696573416374696f6e3ad60109010a000b010b010c010d010e01490110022e022f002d806b805a80bc80bb802251745f10146f7264657246726f6e74466f6e7450616e656c3ad60109010a000b010b010c010d010e0138011002360237002e8064805a80bf80be802351315f100f69636f6e56696577416374696f6e3ad60109010a000b010b010c010d010e01380110023e023f002f8064805a80c280c1802461f7015f10146f70656e53656c656374696f6e416374696f6e3ad60109010a000b010b010c010d010e013801100246024700308064805a80c580c48025517c5c616c69676e43656e7465723ad60109010a000b010b010c010d010e017c0110024e01fc0031807e805a80c780aa80265f101d6e6577466f6c6465725769746853656c656374696f6e416374696f6e3ad60109010a000b010b010c010d010e013801100255025600328064805a80ca80c9802751735d73617665446f63756d656e743ad60109010a000b010b010c010d010e01490110025d025e0033806b805a80cd80cc802851685f1016686964654f746865724170706c69636174696f6e733ad60109010a000b010b010c010d0263013801100266026700341103e98064805a80d080cf8029513a5f101573686f77496e76697369626c6573416374696f6e3ad60109010a000b010b010c010d026c0138011001eb017f003510018064805a80a5807d802ad60109010a000b010b010c010d010e013801100275027600368064805a80d480d3802b515b5f10166261636b50617468486973746f7279416374696f6e3ad60109010a000b010b010c010d010e010f0110027d027e00378058805a80d780d6802cd2000b0115011602828057517a557265646f3ad60109010a000b010b010c010d010e01260110028702880038805d805a80da80d9802d61f70b5f101c6465636f6d7072657373546f4f7468657250616e65416374696f6e3ad60109010a000b010b010c010d01e801380110028f029000398064805a80dd80dc802e51625d616464466f6e7454726169743ad60109010a000b010b010c010d010e0138011002970298003a8064805a80e080df802f515d5f1019666f727761726450617468486973746f7279416374696f6e3ad60109010a000b010b010c010d010e01380110029f01fc003b8064805a80e280aa80305f10146e657746696c6557696e646f77416374696f6e3ad60109010a000b010b010c010d010e0126011002a602a7003c805d805a80e580e4803161f7095f10166d6f7665546f4f7468657250616e65416374696f6e3ad60109010a000b010b010c010d010e010f011002ae02af003d8058805a80e880e78032d2000b0115011602b3805751635f10156f7264657246726f6e74436f6c6f7250616e656c3ad60109010a000b010b010c010d010e010f011002b802b9003e8058805a80eb80ea8033d2000b0115011602bd8057516c5f10176d616b6553796d626f6c69634c696e6b416374696f6e3ad60109010a000b010b010c010d010e02c0011002c202c3003f80ee805a80ef80ed8034d2000b0115011602c78057516e12001a00005f100f7465726d696e616c416374696f6e3ad60109010a000b010b010c010d010e0138011002cd02ce00408064805a80f280f18035517d5f101473656c6563744e657874546162416374696f6e3ad60109010a000b010b010c010d010e0126011002d502d60041805d805a80f580f48036505f100f73686f77477565737350616e656c3ad60109010a000b010b010c010d010e02c0011002dd02de004280ee805a80f880f78037d2000b0115011602e2805751765f101170617374654173506c61696e546578743ad60109010a000b010b010c010d010e0138011002e702e800438064805a80fb80fa803861f7005f1016706172656e744469726563746f7279416374696f6e3ad60109010a000b010b010c010d010e0138011002ef02f000448064805a80fe80fd803951085f10126d6f7665546f5472617368416374696f6e3ad60109010a000b010b010c010d010e017c011002f701880045807e805a8101008081803a5f10116f70656e54657874446f63756d656e743ad60109010a000b010b010c010d010e0138011002fe02ff00468064805a810103810102803b51645f10106475706c6963617465416374696f6e3ad60109010a000b010b010c010d010e01260110030603070047805d805a810106810105803c61f70c5f1016636f6d706172654475616c50616e65416374696f6e3ad60109010a000b010b010c010d010e01490110030e013b0048806b805a8101088063803d5f101c746f67676c65476574496e666f496e73706563746f7250616e656c3ad60109010a000b010b010c010d010e01260110031503160049805d805a81010b81010a803e61f7045f1018746f67676c654475616c42726f77736572416374696f6e3ad60109010a000b010b010c010d010e017c0110031d0177004a807e805a81010d807a803f5b706173746552756c65723ad60109010a000b010b010c010d010e0126011003240325004b805d805a81011081010f804061f7065f101762726f777365496e4e65787450616e65416374696f6e3ad60109010a000b010b010c010d010e01380110032c020e004c8064805a81011280b080415f1013706572666f726d4d696e6961747572697a653ad60109010a000b010b010c010d010e010f011003330334004d8058805a8101158101148042d2000b011501160338805751705e72756e506167654c61796f75743ad60109010a000b010b010c010d010e033b0110033d033e004e810118805a8101198101178043d2000b0115011603428057516e12001600005f10126e65775465787446696c65416374696f6e3ad60109010a000b010b010c010d010e017c01100348022f004f807e805a81011b80bb80445d616464546f536964656261723ad60109010a000b010b010c010d010e01380110034f022f00508064805a81011d80bb80455d6e6577546162416374696f6e3ad60109010a000b010b010c010d010e013801100356035700518064805a81012081011f8046516b5f1016636f6e6e656374546f536572766572416374696f6e3ad60109010a000b010b010c010d010e01380110035e035f00528064805a8101238101228047517a55756e646f3ad60109010a000b010b010c010d010e017c01100366014c0053807e805a810125806a80485a636f707952756c65723ad60109010a000b010b010c010d010e01490110036d01f40054806b805a81012780a780495f101b66696c654f7065726174696f6e7357696e646f77416374696f6e3ad60109010a000b010b010c010d010e013801100374037500558064805a81012a810129804a51775d706572666f726d436c6f73653ad60109010a000b010b010c010d010e01380110037c037d00568064805a81012d81012c804b5178546375743ad60109010a000b010b010c010d010e01490110038403750057806b805a81012f810129804c5f100f636c6f7365416c6c416374696f6e3ad60109010a000b010b010c010d010e01380110038b014c00588064805a810131806a804d55636f70793ad60109010a000b010b010c010d010e013801100392039300598064805a810134810133804e51335f1011636f6c756d6e56696577416374696f6e3ad60109010a000b010b010c010d010e01380110039a0177005a8064805a810136807a804f5670617374653ad60109010a000b010b010c010d010e0138011003a1025e005b8064805a81013880cc805055686964653ad60109010a000b010b010c010d010e0138011003a803a9005c8064805a81013b81013a805151755a756e6465726c696e653ad60109010a000b010b010c010d010e0149011003b00256005d806b805a81013d80c980525f101173617665416c6c446f63756d656e74733ad60109010a000b010b010c010d010e017c011003b7013b005e807e805a81013f806380535f101e73686f7747657453756d6d617279496e666f50616e656c416374696f6e3ad60109010a000b010b010c010d010e0138011003be03bf005f8064805a8101428101418054517b5f101873656c65637450726576696f7573546162416374696f6e3ad20119011a03c403c55f10134e534d757461626c6544696374696f6e617279a303c403c6011e5c4e5344696374696f6e6172795f100f4e534b657965644172636869766572d103c903ca54726f6f748001000800190022002b0035003a003f02cb02d102de02e602f102f803a103a303a503a703a903ab03ad03af03b103b303b503b703b903bb03bd03bf03c103c303c503c703c903cb03cd03cf03d103d303d503d703d903db03dd03df03e103e303e503e703e903eb03ed03ef03f103f303f503f703f903fb03fd03ff04010403040504070409040b040d040f04110413041504170419041b041d041f04210423042504270429042b042d042f04310433043504370439043b043d043f044104430445044704f004f204f404f604f804fa04fc04fe05000502050405060508050a050c050e05100512051405160518051a051c051e05200522052405260528052a052c052e05300532053405360538053a053c053e05400542054405460548054a054c054e05500552055405560558055a055c055e0560056205650568056b056e057105740577057a057d0580058305860589058c058f059205950598059b059e05a105a405a705aa05ad05b005b305c805ea05fc060a06390657066c0681069b06a806c706e006ef0701070c072907420779078b07a907c107d907eb080a0820082e08410856086c087b088d089a08b808c608da08f40915091f0939095509690971097b099f09b709c209e109ff0a1e0a380a4c0a650a9b0ab80ace0ae30b010b160b590b6f0b830ba20bbd0bcf0be40bf90c0f0c230c3d0c470c650c7e0c920c9b0caa0cb40cc60cd10cf00d0d0d1b0d330d500d690d6d0d890d960da40db10db30db50db70db90dbb0dbd0dc60dd00dd20dd40ddd0de80df10e030e0a0e130e1c0e210e350e3e0e4d0e520e610e7a0e7c0e7e0e800e820e840e870ea40ebd0ebf0ec10ec30ec50ec70ed00ed20ed40ee60eff0f010f030f050f070f090f0b0f100f2a0f430f450f470f490f4b0f4d0f4f0f5e0f770f790f7b0f7d0f7f0f810f830f880f920fab0fad0faf0fb10fb30fb50fb70fcd0fe60fe80fea0fec0fee0ff00ff90ffb0ffd10101029102b102d102f10311033103510491062106410661068106a106c106e10801099109b109d109f10a110a310a510b010c910cb10cd10cf10d110d310d510da10ee11071109110b110d110f111111131121113a113c113e114011421144114611591172117411761178117a117c117e118b11a411a611a811aa11ac11ae11b011c811e111e311e511e711e911eb11ed1206121f122112231225122712291232123412361254126d126f1271127312751277128012821284129a12b312b512b712b912bb12bd12c012d912f212f412f612f812fa12fc12fe13101329132b132d132f1331133313491362136413661368136a136c136e13791392139413961398139a139c139e13b113ca13cc13ce13d013d213d413d613d813f2140b140d140f14111413141514171426143f14411443144514471449144b145a1473147514771479147b147d14861488148a149814b114b314b514b714b914bb14bd14d214eb14ed14ef14f114f314f5150715201522152415261528152a152d1544155d155f1561156315651567157015721574158715a015a215a415a615a815aa15ac15c315dc15de15e015e215e415e615e815fa1613161516171619161b161d1620163716501652165416561658165a165c16691682168416861688168a168c16ac16c516c716c916cb16cd16cf16d116df16f816fa16fc16fe170017021704171d17361739173b173d173f174117431745175d17761778177a177c177e17801782179b179d179f17a117a317a517a717c017d917db17dd17df17e117e317ec17ee17f017f6180f18111813181518171819181c183b185418561858185a185c185e1860186e18871889188b188d188f1891189318af18c818ca18cc18ce18d018d218e91902190419061908190a190c190f192819411943194519471949194b19541956195819701989198b198d198f19911993199c199e19a019ba19d319d519d719d919db19dd19e619e819ea19ef1a011a1a1a1c1a1e1a201a221a241a261a3d1a561a581a5a1a5c1a5e1a601a611a731a8c1a8e1a901a921a941a961a9f1aa11aa31ab71ad01ad21ad41ad61ad81ada1add1af61b0f1b111b131b151b171b191b1b1b301b491b4b1b4d1b501b521b541b681b811b831b851b881b8b1b8d1b8f1ba21bbb1bbd1bbf1bc21bc51bc71bca1be31bfc1bfe1c001c031c051c071c261c3f1c411c431c461c491c4b1c4e1c691c821c841c861c891c8b1c8d1c991cb21cb41cb61cb91cbc1cbe1cc11cdb1cf41cf61cf81cfb1cfd1cff1d151d2e1d301d321d351d381d3a1d431d451d471d561d6f1d721d741d771d7a1d7c1d851d871d891d8e1da31dbc1dbe1dc01dc31dc51dc71dd51dee1df01df21df51df71df91e071e201e221e241e271e2a1e2c1e2e1e471e601e621e641e671e6a1e6c1e6e1e741e8d1e8f1e911e941e961e981ea31ebc1ebe1ec01ec31ec51ec71ee51efe1f001f021f051f081f0a1f0c1f1a1f331f351f371f3a1f3d1f3f1f411f461f5f1f611f631f661f691f6b1f7d1f961f981f9a1f9d1f9f1fa11fa71fc01fc21fc41fc71fca1fcc1fce1fe21ffb1ffd1fff200220042006200d20262028202a202d202f203120372050205220542057205a205c205e20692082208420862089208b208d20a120ba20bc20be20c120c320c520e620ff2101210321062109210b210d212821312147214e215b216d21722177000000000000020200000000000003cb00000000000000000000000000002179

###############################################################################
# Todoist                                                                     #
###############################################################################

# Show in Dock, but not in the menubar
defaults write "com.todoist.mac.Todoist" ShowInDock -bool true
defaults write "com.todoist.mac.Todoist" ShowQuickAddExpandInfo -bool false
defaults write "com.todoist.mac.Todoist" ShowTodoistMenuBar -bool false

###############################################################################
# Little Snitch & Micro Snitch                                                #
###############################################################################

# Don't show the warning when closing Little Snitch configuration
defaults write "at.obdev.LittleSnitchConfiguration" ShowTerminationAlert -int 0

# Set Micro Snitch to open at login
defaults write "at.obdev.MicroSnitch" OpenAtLogin -int 1

###############################################################################
# Adobe Lightroom                                                             #
###############################################################################

# Don't try to import when detecting memory card
defaults write com.adobe.Lightroom6 memoryCardDetectionAction -string "ImportBehavior_DoNothing"

# Always ask for catalog on startup
defaults write com.adobe.Lightroom6 recentLibraryBehavior20 -string "AlwaysPromptForLibrary"

###############################################################################
# Enable Dark Mode                                                            #
###############################################################################

dark-mode --mode Dark

###############################################################################
# Login Items                                                                 #
###############################################################################

osascript -e 'tell application "System Events" to make login item at end with properties {path:"~/Applications/Alfred 2.app", name:"Alfred 2", hidden:false}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"~/Applications/Caffeine.app", name:"Caffeine", hidden:false}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"~/Applications/Dash.app", name:"Dash", hidden:false}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"~/Applications/Dropbox.app", name:"Dropbox", hidden:false}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"~/Applications/Jotta.app", name:"Jottacloud", hidden:false}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"~/Applications/Spectacle.app", name:"Spectacle", hidden:false}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"~/Applications/Evernote.app/Contents/Library/LoginItems/EvernoteHelper.app", name:"EvernoteHelper", hidden:false}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"~/Applications/Path Finder.app", name:"Path Finder", hidden:false}'

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
	"Dock" "Finder" "Google Chrome" "Google Chrome Canary" "Mail" "Messages" \
	"Opera" "Safari" "SizeUp" "Spectacle" "SystemUIServer" "Alfred 2" "Dash" \
	"Terminal" "Transmission" "Twitter" "iCal" "Transmit"; do
	killall "${app}" > /dev/null 2>&1
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
