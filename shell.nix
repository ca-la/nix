{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  nodejs = callPackage ./nodejs.nix { inherit pkgs; };
  postgresql = postgresql_10;
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
      '';
    };
  };
  elasticmq = (import ./elasticmq.nix) { inherit config pkgs stdenv fetchurl jre makeWrapper; };
in

pkgs.mkShell {
    buildInputs = [ nodejs postgresql pgcli heroku elasticmq ];
    shellHook = ''
      export PGDATA="$PWD/db"
      if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
          GIT_PROMPT_ONLY_IN_REPO=1
          source $HOME/.bash-git-prompt/gitprompt.sh
      fi
    '';
}

