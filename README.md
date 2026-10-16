# My dotfiles

This directory contains the dofiles for my system.

## Requirements

### Linux requirements

```shell
sudo apt install git stow
```

### MacOS requirements

To install Git, it is necessary to install XCode command line tools.
To install GNU Stow, it is necessary to install Homebrew.

```shell
xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install stow
```

### Windows requirements

On an elevated terminal run:

```shell
winget install --id Git.Git

git config --system core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
git config --system gpg.ssh.program "C:/Windows/System32/OpenSSH/ssh-keygen.exe"

winget install --id MathiasCodes.Winstow
```

## Configuration

Clone the dofiles repository in your $HOME directory using git.

```shell
git clone ssh://git@codeberg.org/beppler/dotfiles.git .dotfiles
```

### Linux/MacOS configuration

Update directory and file permissions.

```shell
chmod 700 .dotfiles
chmod 600 .dotfiles/ssh/.ssh/id*
```

Enter on `.dotfiles` directory.

```shell
cd .dotfiles
```

Use GNU Stow to evaluate what actions will be done.

```shell
stow -nRv bash ghostty git mercurial oh-my-posh ssh zsh
```

Then use GNU stow to create the symlinks.

```shell
stow bash ghostty git mercurial oh-my-posh ssh
```

### Windows configuration

Enter on `.dotfiles` directory.

```shell
cd .dotfiles
```

Use GNU Stow to evaluate what actions will be done.

```shell
winstow -nRv ghostty git mercurial powershell ssh windows-terminal
```

Then use GNU stow to create the symlinks.

```shell
winstow ghostty git mercurial powershell ssh windows-terminal
```
