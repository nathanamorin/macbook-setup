# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Start by installing Xcode from here: (https://developer.apple.com/xcode/)"

read -p "Press [Enter] once this is done."

echo "Installing xcode related stuff ⚒"
xcode-select --install
sudo xcodebuild -license accept # Accepts the Xcode license

echo "Installing Homebrew 🍺"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing MAS"
brew install mas
read -p "What is your Apple ID email? " appleID
mas signin $appleID

echo "Installing apps from Brewfile 🙌"
brew bundle install

echo "Login and download apps from Setapp before continuing."

read -p "Press [Enter] once this is done."

echo "Login to Dropbox and have the Dropbox folder in the $HOME directory."

read -p "Press [Enter] once this is done."

echo "Uploading settings from Mackup 🤙"
mackup restore

echo "Find the settings for iTerm2 and Alfred in Dropbox and link each one of these applications with their corresponding settings file. Also setup 1Password to sync with iCloud."

read -p "Press [Enter] once this is done."

echo "Installing JavaScript related packages 🖥"
yarn global add avn avn-nvm # Node version adapters for nvm
avn setup
yarn global add react-native-cli

echo "Installing Ruby related packages 💎"
Install latest ruby version with rbenv as default system ruby
rbenv init
LATEST_RUBY_VERSION="$(rbenv install -l | grep -v - | tail -1 | tr -d '[[:space:]]')"
rbenv install $LATEST_RUBY_VERSION
rbenv global $LATEST_RUBY_VERSION
rbenv rehash
gem install fastlane # Used for React Native

# General MacOS security related settings

# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Set some basic security settings
echo "Configuring security settings:"

# Check FileVault status
echo "--> Checking full-disk encryption status:"
if fdesetup status | grep $Q -E "FileVault is (On|Off, but will be enabled after the next restart)."; then
  echo "OK"
else
  echo "Enabling full-disk encryption on next reboot:"
  sudo fdesetup enable -user "$USER" \
    | tee ~/Desktop/"FileVault Recovery Key.txt"
  echo "OK"
fi

# Disable guest account
echo "--> Disabling guest account"
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO

# Lock computer and display the screensaver after 5 minutes of inactivity
echo "--> Lock computer after 5 minutes"
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay 0
defaults -currentHost write com.apple.screensaver idleTime 300 # 300s = 5mins

# Enable firewall (alf = application layer firewall)
echo "--> Enabling firewall"
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
sudo launchctl load /System/Library/LaunchDaemons/com.apple.alf.agent.plist
sudo launchctl load /System/Library/LaunchAgents/com.apple.alf.useragent.plist
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp on
sudo pkill -HUP socketfilterfw

echo "Done!"
