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

sudo -v

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
#brew install gnu-sed #--with-default-names
#brew install gnu-tar #--with-default-names
#brew install gnu-indent #--with-default-names
#brew install gnu-which #--with-default-names
#brew install gnu-grep #--with-default-names


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
    postman
    dropbox
    docker
    firefox
    flux
    #google-chrome
    google-drive
    gpg-suite-pinentry
    wireshark
    iterm2
    macvim
    skype
    slack
    spectacle
    vagrant
    virtualbox
    vlc
    1password
    zoom
    microsoft-outlook
    xcodes
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

#echo "Configuring OSX..."
#
## Set fast key repeat rate
##defaults write NSGlobalDomain KeyRepeat -int 0
#
## Require password as soon as screensaver or sleep mode starts
#defaults write com.apple.screensaver askForPassword -int 1
#defaults write com.apple.screensaver askForPasswordDelay -int 0
#
## Show filename extensions by default
#defaults write NSGlobalDomain AppleShowAllExtensions -bool true
#
## Enable tap-to-click
#defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
#defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
#
## Disable "natural" scroll
##defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "Creating folder structure..."
[[ ! -d Wiki ]] && mkdir Wiki
[[ ! -d Workspace ]] && mkdir Workspace

echo "Bootstrapping complete"
