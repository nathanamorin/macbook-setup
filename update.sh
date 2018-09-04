#!/bin/sh

# The following script will update outdated brew packages and also update your MacOS operating system. It will also clean out old versions of brew packages that can free up a lot of space on your hardrive!

##############
# Steps required to run script
# 1. cp ./update.sh /usr/local/bin
# 2. chmod 755 /usr/local/bin/update.sh
# 3. /usr/local/bin/update.sh
###############

# homebrew package updates
echo "Checking homebrew packages..."
brew update > /dev/null;
new_packages=$(brew outdated --quiet)
new_casks=$(brew cask outdated --quiet)
num_casks=$(echo $new_casks | wc -w)
num_packages=$(echo $new_packages | wc -w)

if [ $num_packages -gt 0 -o $num_casks -gt 0 ]; then
	echo "\n$num_packages New brew updates available:"

  for package in $new_packages; do
		echo "   * $package";
  done
  for cask in $new_casks; do
		echo "   * $cask (cask)";
  done

	echo "\nInstall brew updates? (y/n)"
	read answer
	if echo "$answer" | grep -iq "^y" ; then
		brew upgrade && echo "\nBrew updates done!"
	fi

	echo "\nClean up old versions of brew packages? (y/n)"
	read answer
	if echo "$answer" | grep -iq "^y" ; then
		brew cleanup && echo "\nBrew cleanup done!"
	fi
else
	echo "\nNo brew updates available."
fi

# macOS updates
echo "\nChecking macOS updates..."
softwareupdate -l | tail +5

echo "\nInstall macOS updates? (y/n)"
read answer
	if echo "$answer" | grep -iq "^y" ; then
	sudo softwareupdate -i -a && echo "\nmacOS updates done! You may need to reboot..."
fi
