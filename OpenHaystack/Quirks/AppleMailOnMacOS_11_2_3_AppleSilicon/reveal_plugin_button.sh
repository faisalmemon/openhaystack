#!/bin/bash

pkill Mail
mkdir -p "$HOME/Library/Application Support/Mail/Plug-ins/Bundles"
sudo defaults write "/Library/Preferences/com.apple.mail" EnableBundles 1
defaults write com.apple.mail EnableBundles -bool true
defaults write com.apple.mail BundleCompatibilityVersion 4
