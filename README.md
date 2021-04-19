# Nix Development Environment

## Why?

To have a consistent development environment without the overhead of Docker or
other containerization services. Provides a consistent set of development
dependencies, such as Node, PostgreSQL, ElasticMQ, pgcli, etc.

## Installing Nix on macOS

[Official documentation](https://nixos.org/manual/nix/stable/#sect-macos-installation)

### Step-by-step (tested on Big Sur)

This has been tested on a new install of macOS 11 (Big Sur).

```bash
# Install Apple command line developer tools
xcode-select --install

# If you're on an M1 mac, install rosetta
softwareupdate --install-rosetta

# Install nix itself with macOS > 10.15 support
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume

# Installer will tell you to add a command to your shell profile
echo ". /a/path/provided/by/installation/step" >> ~/.zshrc

# Start a new terminal session to ensure `nix` is in your path
which nix # to confirm you have `nix` in your path

# Update to latest `nix` to get flakes support
nix-env -iA nixpkgs.nixUnstable

# Create nix configuration to enable flakes feature
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# Initial setup of CALA nix repo
cd ~/cala # or where ever your other CALA repos live
git clone git@github.com:ca-la/nix.git
cd nix

# Open a bash shell with our dependencies installed
# Note: first run will take a while to download and install packages
nix develop .

# Create a "database cluster" for running the Postgres server
cd ~/cala # or where ever your other CALA repos live
initdb data
pg_ctl start -D data

# Create the individual databases that our application and tests use
createdb cala
createdb cala-test

# ElasticMQ (SQS compatible message service)
elasticmq& # queues are preconfigured, so no additional work needed
```

## Usage

Using the `nix develop .` command from within the `nix` git repo, you can enter
a shell with all of our tools installed in your PATH.

### Bring your own shell

`nix develop --command zsh` will create a subshell within the bash session that
`nix develop` would create. That means you'll get the `PATH` set up by `nix`,
but it will create a new zsh session, giving you the best of both worlds!

One caveat here is that `nix` works by putting the correct tools in your `PATH`,
so if you have things in your shell profile scripts that would add to the `PATH`
you have to be careful not to override the tools provided by `nix`. When in
doubt, check `which foo-tool` and make sure it points to something in the
`/nix/store`.


## Uninstalling Nix

If the installation fails in the middle, or you just decide to delete nix for
some reason, here the installer itself contains some instructions on how to
uninstall. At the time this README was written, that is the following:

```bash
# Remove entry from fstab
sudo vifs
# Find the /nix data volume
diskutil list
# Destroy the /nix data volume
diskutil apfs deleteVolume diskNsN # value from previous command
# Remove the `nix` line from /etc/sythentic.conf
sudo vim /etc/synthetic.conf
```
