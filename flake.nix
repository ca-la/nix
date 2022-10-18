{
  description = "A CALA development environment";

  inputs.nixpkgs-intel.url = "github:NixOS/nixpkgs/bfd326421ef093b77d70dfe8b9195e1cee78c097";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.05-darwin";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.nixpkgs.follows = "nixpkgs-latest";
  };

  outputs = { self, nixpkgs, nixpkgs-intel, flake-utils }:
    flake-utils.lib.eachSystem (flake-utils.lib.defaultSystems) (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        intel = nixpkgs-intel.legacyPackages.x86_64-darwin;
        nodejs = intel.nodejs-14_x;
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
        elasticmq = (import ./elasticmq.nix) { inherit config pkgs; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            nodejs
            elasticmq
            pkgs.postgresql_13
            pkgs.yarn

            pkgs.findutils
            pkgs.jq
            pkgs.pandoc
            pkgs.gnupg
            pkgs.pgcli
            pkgs.gitAndTools.git
            pkgs.tmux
            pkgs.graphicsmagick

            pkgs.heroku
            pkgs.gh
            pkgs.awscli2
          ];
        };
      });
}
