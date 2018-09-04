# Macbook Setup Guide

This guide is designed to help with the setup of a new MacBook from scratch.

## Useful References:

- [Kent C Dodds Dotfiles](https://github.com/kentcdodds/dotfiles)
- [Kevin Jalbert Dotfiles Synchronization](https://kevinjalbert.com/synchronizing-my-dotfiles/#disqus_thread)
- [Brad Parbs' Mac Setup Script](https://gist.github.com/bradp/bea76b16d3325f5c47d4)

## Run Setup Script

The [setup script](./setup.sh) can be run to setup most things on a new computer. It should be noted that the script may not be perfect as it only gets tested when a new Mac is actually setup. If the script breaks at any step, the remaining commands will have to be run by hand.

To run the script, execute `./setup.sh` in a terminal. Here's a list of what the setup script currently does:

1. Installs [Xcode](https://developer.apple.com/xcode/)
2. Installs [Homebrew](https://brew.sh/)
3. Installs [MAS](https://github.com/mas-cli/mas)

   MAS allows to install apps on the App Store via the command line.

   _Useful Tips:_

   - To get the MAS app ID, use `mas search <App Name>` (for example `mas search XCode`). You can also see the list of currently installed App Store apps using `mas list`.
   - A Brewfile can be generated with all the packages installed on a computer by running `brew bundle dump` (useful when migrating computers).

4. Installs apps from [`Brewfile`](./Brewfile) using [homebrew-bundle](https://github.com/Homebrew/homebrew-bundle) and MAS
5. Prompts user to login to [Setapp](https://setapp.com/) and install all used applications related to the Setapp account
6. Prompts user to login to Dropbox and setup the Dropbox folder in the `$HOME` directory
7. Sets up most application settings and dotfiles using [Mackup](https://github.com/lra/mackup)
8. Prompts user to link shared configurations found in Dropbox for [iTerm2](https://www.iterm2.com/), [1Password](https://1password.com/), and [Alfred](https://www.alfredapp.com/). These applications require manual setup.
9. Installs JavaScript related packages
10. Installs Ruby related packages
11. Sets up some basic MacOS security settings

    - Full disk encryption
    - Disable guest accounts
    - Lock mac after 5 minutes of inactivity
    - Enable firewall

## VSCode

VS Code also has a shared configuration that is enabled by using the [Settings Sync extension](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync), so that should be the very first thing installed in VS Code as that will configure all the editor settings and extensions.

## Github SSH Keys

Follow [these instructions](https://help.github.com/enterprise/2.12/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) to create an ssh key and then [add the SSH key to Github](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/).

## Github GPG Signing

Follow these steps to create your GPG keys and add them to Github:

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

## Google Chrome

Just login with google and all the extensions I know and love will be there.

## Other Settings To Configure

- Set Chrome as the default browser
- Reorganize dock
- Change display energy saver settings
- Mouse scroll direction

## Update Script

This repo also contains an update script (`update.sh`) that can be used to update outdated brew packages along with updates to the Operating system. This should be done at least a couple of times in the year as it will also clean out old versions of brew packages and save a lot of hardrive space.

Here are the steps required to run the script:

1. `cp ./update.sh /usr/local/bin`
2. `chmod 755 /usr/local/bin/update.sh`
3. `/usr/local/bin/update.sh`
