{ latest, stable }:

let
  nodejs = latest.nodejs-14_x;
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
  elasticmq = (import ./elasticmq.nix) { inherit config; pkgs = latest; };
in

latest.mkShell {
    buildInputs = [
      nodejs
      postgresql
      elasticmq

      latest.findutils
      latest.pgcli
      latest.heroku
      latest.jq
    ];
}

