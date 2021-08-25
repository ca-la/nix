{
  description = "A CALA development environment";

  inputs.nixpkgs-latest.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.nixpkgs-stable.url = "github:NixOs/nixpkgs?rev=bed08131cd29a85f19716d9351940bdc34834492";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.nixpkgs.follows = "nixpkgs-latest";
  };

  outputs = { self, nixpkgs-latest, nixpkgs-stable, flake-utils }:
    flake-utils.lib.eachSystem (flake-utils.lib.defaultSystems ++ ["aarch64-darwin"]) (system:
      let
        latest = import nixpkgs-latest { inherit system; };
        stable = import nixpkgs-stable { inherit system; };
        nodejs = latest.nodejs-14_x;
        yarn = latest.yarn;
        postgresql = latest.postgresql_13;
        config = {
          elasticmq = {
            queues = ''
              cala-iris-dev {
                defaultVisibilityTimeout = 10 seconds
                delay = 5 seconds
                receiveMessageWait = 0 seconds
                fifo = true
                contentBasedDeduplication = true
              }
              cala-hermes-dev {
                defaultVisibilityTimeout = 10 seconds
                delay = 5 seconds
                receiveMessageWait = 0 seconds
                fifo = true
                contentBasedDeduplication = true
              }
              cala-api-worker-dev {
                defaultVisibilityTimeout = 10 seconds
                delay = 5 seconds
                receiveMessageWait = 0 seconds
                fifo = true
                contentBasedDeduplication = true
              }
            '';
          };
        };
        elasticmq = (import ./elasticmq.nix) { inherit config; pkgs = stable; };
      in {
        devShell = latest.mkShell {
          buildInputs = [
            nodejs
            yarn
            postgresql
            elasticmq

            stable.findutils
            stable.jq
            stable.pandoc
            stable.gnupg
            stable.pgcli
            stable.gitAndTools.gitFull
            stable.tmux

            latest.heroku
            latest.gh
            latest._1password
          ];
        };
      });
}
