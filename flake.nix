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
        nodejs = nixpkgs-latest.legacyPackages.x86_64-darwin.nodejs-14_x;
        yarn = nixpkgs-latest.legacyPackages.x86_64-darwin.yarn;
        postgresql = nixpkgs-latest.legacyPackages.x86_64-darwin.postgresql_13;
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
        elasticmq = (import ./elasticmq.nix) { inherit config; pkgs =
nixpkgs-stable.legacyPackages.x86_64-darwin; };
      in {
        devShell = nixpkgs-latest.legacyPackages.x86_64-darwin.mkShell {
          buildInputs = [
            nodejs
            yarn
            postgresql
            elasticmq

            nixpkgs-stable.legacyPackages.x86_64-darwin.findutils
            nixpkgs-stable.legacyPackages.x86_64-darwin.jq
            nixpkgs-stable.legacyPackages.x86_64-darwin.pandoc
            nixpkgs-stable.legacyPackages.x86_64-darwin.gnupg
            nixpkgs-stable.legacyPackages.x86_64-darwin.pgcli
            nixpkgs-stable.legacyPackages.x86_64-darwin.gitAndTools.gitFull
            nixpkgs-stable.legacyPackages.x86_64-darwin.tmux

            nixpkgs-latest.legacyPackages.x86_64-darwin.heroku
            nixpkgs-latest.legacyPackages.x86_64-darwin.gh
          ];
        };
      });
}
