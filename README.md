# Nix Development Environment

## Why?

To have a consistent development environment without the overhead of Docker or
other containerization services. Provides a consistent set of development
dependencies, such as NodeJS, PostgreSQL, ElasticMQ, pgcli, etc.

## Installing Nix

- [Official Docs](https://nixos.org/nix/download.html)
- If you don't like to pipe shell scripts, you can inspect the [installation
  script](https://nixos.org/nix/install) and do what it is doing: download the
  tarball, extract it, run the installation
  
## Using "unfree" packages

`ngrok` is an example of a package we use that is licensed as "unfree", so in
order to use this, you'll need to create a `nixpkgs` config file and allow unfree
packages:

```bash
$ mkdir -p ~/.config/nixpkgs
$ echo "{ allowUnfree: true; }" > ~/.config/nixpkgs/config.nix
```
  
## Initial setup of services

```bash
$ cd nix
$ nix-shell
[nix-shell:~/cala/nix]$ initdb cala
[nix-shell:~/cala/nix]$ initdb cala-test
[nix-shell:~/cala/nix]$ pg_ctl start
[nix-shell:~/cala/nix]$ elasticmq
```
