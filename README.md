# Nix Development Environment

## Why?

To have a consistent development environment without the overhead of Docker or
other containerization services. Provides a consistent set of development
dependencies, such as Node, PostgreSQL, ElasticMQ, pgcli, etc.

## Installing Nix on macOS

[Official documentation](https://nixos.org/manual/nix/stable/#sect-macos-installation)

### Big Sur

1. Install command line developer tools: `xcode-select --install`
2. Install nix: `sh <(curl https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume`
    - Installer will tell you to add a command to `~/.profile`. Put it in `~/.zshrc` instead.
3. Update nix for flakes support
    1. Use nix to install nix-cli with flakes support:
        ```bash
        nix-env -iA nixpkgs.nixUnstable
        ```
    2. Create a nix configuration for your user that includes flakes support:
        ```bash
        mkdir -p ~/.config/nix
        echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
        ```
4. Clone nix repo and enter the nix dev shell
    ```bash
    git clone git@github.com:ca-la/nix.git
    cd nix
    nix develop . # first run will take a while to download and install all dev tools
    ```

### Initial setup of data services

```bash
cd nix
nix develop .

# From within the nix bash shell
cd ..
mkdir -p data # will hold our database files
cd data
initdb cala # create development database
initdb cala-test # create test database
pg_ctl start -D cala
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
