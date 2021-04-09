#!/usr/bin/env bash
# 
# Bootstrap script for setting up a new OSX machine
# 
# This should be idempotent so it can be run multiple times.
#
# Some apps don't have a cask and so still need to be installed by hand. These
# include:
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#

osascript -e 'tell application "System Preferences" to quit'
echo "Starting bootstrapping"

#sudo -v
echo "installing xcode"
xcode-select --install 

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ##ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update homebrew recipes
brew update

echo "Installing rosetta..." "disable this command for non M1 Chip macbooks and run..."
softwareupdate --install-rosetta

# Install GNU core utilities (those that come with OS X are outdated)
#brew tap homebrew/dupes
brew install coreutils
brew install gnu-sed #--with-default-names
brew install gnu-tar #--with-default-names
brew install gnu-indent #--with-default-names
brew install gnu-which #--with-default-names
brew install gnu-grep #--with-default-names


brew install gnu-indent
brew install gnu-sed
brew install gnutls
brew install gnu-grep
brew install gnu-tar
brew install gawk
brew install gsed
brew install gnu-indent
brew install gnu-which
#brew install tar

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash
#for PACKAGES in $(<"$PACKAGES.txt") ; do

PACKAGES=(
    cask
    svn
    brew-pip
    ack
    autoconf
    automake
    boot2docker
    ffmpeg
    gettext
    gifsicle
    git
    graphviz
    hub
    imagemagick
    jq
    libjpeg
    libmemcached 
    lynx
    markdown
    memcached
    mercurial
    npm
    pkg-config
    postgresql
    #python
    #python3
    pypy
    rabbitmq
    rename
    ssh-copy-id
    terminal-notifier
    the_silver_searcher
    tmux
    tree
    #vim
    wget
)


echo "Installing packages..."
#if ! brew install ${PACKAGES[@]}    
#    then
#    echo "Failed to install ${PACKAGES[@]}"
#        continue
#    fi
#
#done
brew install ${PACKAGES[@]} || : 

echo "Cleaning up..."
brew cleanup



echo "Installing cask..."
brew install cask

#for CASKS in $(<"$CASKS.txt") ; do

CASKS=(
    google-chrome
    zoomus
    brackets
    slack
    postman
    dropbox
    docker
    firefox
    google-chrome
    wireshark
    iterm2
    macvim
    slack
    spectacle
    1password
    vscode
    github
    git
    pycharm-ce
    atom
)

echo "Installing cask apps..."
#if ! brew install ${CASKS[@]}    
#    then
#    echo "Failed to install ${CASKS[@]}"
#        continue
#    fi
#
#done
brew install --cask ${CASKS[@]} || : 
#brew upgrade --cask ${CASKS[@]}

echo "Installing fonts..."
brew tap homebrew/cask-fonts
FONTS=(
    font-roboto
    font-clear-sans
    font-fira-code
    #font-inconsolidata
)
brew install ${FONTS[@]} || : 

echo "Installing Python packages..."
PYTHON_PACKAGES=(
    ipython
    virtualenv
    virtualenvwrapper
)
sudo pip3 install ${PYTHON_PACKAGES[@]} || : 

echo "Installing Ruby gems"
RUBY_GEMS=(
    bundler
    filewatcher
    cocoapods
)
sudo gem install ${RUBY_GEMS[@]}

echo "Installing global npm packages..."
npm install marked -g

echo "Configuring OSX..."
#
## Set fast key repeat rate
##defaults write NSGlobalDomain KeyRepeat -int 0
#
## Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
#
## Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
#
## Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
#
## Disable "natural" scroll
##defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 0
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Documents/Screeshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
#defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
# Login window
###############################################################################

# Disable Guest Account
defaults write /Library/Preferences/com.apple.loginwindow  GuestEnabled 0

# User Auto login -- Off
defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser

# Enable Show Input menu in login window
defaults write /Library/Preferences/com.apple.loginwindow showInputMenu 1

# Enable show password hint
defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint 1

# Enable Show sleep, restart, and shutdown buttons
defaults write /Library/Preferences/com.apple.loginwindow PowerOffDisabled 0

# disable gatekeeper.
# ref https://www.defaults-write.com/disable-gatekeeper-on-your-mac/

defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool false

#Turning Gatekeeper back on on a Mac with the following command:

#defaults delete /Library/Preferences/com.apple.security GKAutoRearm




echo "Creating folder structure..."
[[ ! -d Wiki ]] && mkdir Wiki
[[ ! -d Workspace ]] && mkdir Workspace

echo "Bootstrapping complete"
