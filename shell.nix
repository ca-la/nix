{ latest, stable }:

let
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
      '';
    };
  };
  elasticmq = (import ./elasticmq.nix) { inherit config; pkgs = stable; };
in

stable.mkShell {
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
    stable.gitAndTools.hub

    latest.heroku
  ];
}

