{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  buildNodejs = pkgs.callPackage "${pkgs.path}/pkgs/development/web/nodejs/nodejs.nix" {};
  nodejs = buildNodejs {
    enableNpm = true;
    version = "10.15.0";
    sha256 = "0gnygq4n7aar4jrynnnslxhlrlrml9f1n9passvj2fxqfi6b6ykr";
  };
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
    '';
}

