# MacBook Setup Guide

This guide is designed to help with the setup of a new Mac from scratch. This repo includes a [setup script](./setup.sh) that can be run to install a good chunk of stuff for a new Mac.

## Useful References:

- [Kent C Dodds Dotfiles](https://github.com/kentcdodds/dotfiles)
- [Kevin Jalbert Dotfiles Synchronization](https://kevinjalbert.com/synchronizing-my-dotfiles/#disqus_thread)
- [Brad Parbs' Mac Setup Script](https://gist.github.com/bradp/bea76b16d3325f5c47d4)

## Pre-requisites

Prior to being able to run the setup script, you will need to download this repository from Github and also change the file permisions on `setup.sh` using the following command in this project's folder:

```bash
chmod 744 setup.sh
```

It should be noted that **the script IS NOT PERFECT**. The script will likely break at some point and you will need to fix things manually. If the script breaks at any step, the remaining commands will have to be run by hand.

Also, if sharing settings between computers using [Mackup](https://github.com/lra/mackup), be sure to have the same name for the home directory on both computers or things will get messy (I found this out the hard way).

## Setup Script

The [setup script](./setup.sh) can be run to setup most things on a new computer. To run the script, execute `./setup.sh` in a terminal. Here's a list of what the setup script currently does:

1. Prompts the user to install [Xcode](https://developer.apple.com/xcode/) since it is required in later steps in the script
2. Installs Xcode related tools & accepts the Xcode license
3. Installs [Homebrew](https://brew.sh/)
4. Installs [MAS](https://github.com/mas-cli/mas)

   MAS allows for the installation of apps on the App Store via the command line.

   _Useful Tips:_

   - To get the MAS app ID, use `mas search <App Name>` (for example `mas search XCode`). You can also see the list of currently installed App Store apps using `mas list`.
   - A Brewfile can be generated with all the packages installed on a computer by running `brew bundle dump` (useful when migrating computers).

5. Installs apps from the [`Brewfile`](./Brewfile) using [homebrew-bundle](https://github.com/Homebrew/homebrew-bundle) and MAS
6. Prompts user to login to [Setapp](https://setapp.com/) and install all used applications related to the Setapp account
7. Prompts user to login to Dropbox and setup the Dropbox folder in the `$HOME` directory
8. Sets up most application settings and dotfiles using [Mackup](https://github.com/lra/mackup)
9. Prompts user to link shared configurations found in Dropbox for [iTerm2](https://www.iterm2.com/) and [Alfred](https://www.alfredapp.com/). [1Password](https://1password.com/) should getted synced with iCloud.
10. Installs JavaScript related packages
11. Installs Ruby related packages
12. Sets up some basic MacOS security settings

    - Full disk encryption
    - Disable guest accounts
    - Lock mac after 5 minutes of inactivity
    - Enable firewall

## Manual Configurations

### VSCode

VS Code also has a shared configuration that is enabled by using the [Settings Sync extension](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync), so that should be the very first thing installed in VS Code as that will configure all the editor settings and extensions.

### Github SSH Keys

Follow [these instructions](https://help.github.com/enterprise/2.12/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) to create an ssh key and then [add the SSH key to Github](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/).

### Github GPG Signing

Follow these steps to create your GPG keys and add them to Github. Make sure to install [GPG Suite](https://gpgtools.org/) first.

1. `gpg --full-generate-key`

2. Choose options:

- What kind of key? `1 RSA and RSA`
- Key size: `4096`
- Length of time key should be valid: `(enter)` (meaning key doesn't expire)

3. Use your Github email

4. Enter a long unique password for the passphrase

5. `gpg --list-secret-keys`

6. The `sec` entry should have a long hash - copy that - it is your uid

7. `gpg --armor --export <UID>` to print your public key

8. Copy your key to [github here](https://github.com/settings/keys)

9. Add GPG related settings to your global git config:

```
git config --global commit.gpgsign true
git config --global user.signingkey <UID>
git config --global gpg.program `which gpg`
```

### Other Settings To Configure

- Set Chrome as the default browser
- Reorganize dock
- Change display energy saver settings
- Mouse scroll direction
- Set touchpad scroll speed to max
- Allow for keyboard language switch between EN-CA and FR-CA using `⌘` + `⌥` + `Space`
- Check for any missing apps that weren't installed

## Update Script

This repo also contains an update script (`update.sh`) that can be used to update outdated brew packages along with updates to the Operating system. This should be done at least a couple of times in the year as it will also clean out old versions of brew packages and save a lot of hardrive space.

Here are the steps required to run the script:

1. `cp ./update.sh /usr/local/bin`
2. `chmod 755 /usr/local/bin/update.sh`
3. `/usr/local/bin/update.sh`
