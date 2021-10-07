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

# Install nix itself with macOS > 10.15 support
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume

# Installer will tell you to add a command to your shell profile
echo ". /a/path/provided/by/installation/step" >> ~/.zshrc

# Update to latest `nix` to get flakes support
nix-env -iA nixpkgs.nixUnstable

# Create nix configuration to enable flakes feature
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf<< EOF
system = aarch64-darwin
extra-platforms = aarch64-darwin x86_64-darwin
experimental-features = nix-command flakes
EOF

# Initial setup of CALA nix repo
cd ~/cala # or where ever your other CALA repos live
git clone git@github.com:ca-la/nix.git
cd nix

# Open a bash shell with our dependencies installed
# Note: first run will take a while to download and install packages
nix develop .

# Setting up databases
cd ~/cala # or where ever your other CALA repos live
mkdir -p data
cd data
initdb cala
initdb cala-test

# Run database services
# PostgreSQL
pg_ctl start -D cala

# ElasticMQ (SQS compatible message service)
elasticmq&
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
