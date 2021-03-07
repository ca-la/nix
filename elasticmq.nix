{ config, pkgs }:

with pkgs;

let
  version = "0.14.12";
  name = "elasticmq-${version}";

  src = fetchurl {
    url = "https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-0.14.12.jar";
    sha256 = "0xjkvb39rd1s25q1vf24ihx4chvc1hi1z074ci37d9slyl0rfar3";
  };
  configFile = pkgs.writeText "custom.conf" ''
    include classpath("application.conf")

    queues {
      ${config.elasticmq.queues}
    }
  '';
in

stdenv.mkDerivation rec {
  inherit version name src configFile;

  dontUnpack = true;

  buildInputs = [ jre makeWrapper ];

  installPhase =
    ''
      mkdir -p $out/bin
      mkdir -p $out/share/elasticmq
      cp ${src} $out/share/elasticmq/${name}.jar
      makeWrapper ${jre}/bin/java $out/bin/elasticmq \
        --add-flags "-Dconfig.file=${configFile}" \
        --add-flags "-jar $out/share/elasticmq/${name}.jar"
    '';

  meta = with lib; {
    homepage = https://github.com/adamw/elasticmq;
    description = "Message queueing system with Java, Scala and Amazon SQS-compatible interfaces";
    longDescription =
      ''
        ElasticMQ is a message queueing system with Java, Scala and
        Amazon SQS-compatible interfaces.  You should set the
        environment ELASTICMQ_DATA_PREFIX to a writable directory
        where ElasticMQ will store its data and log files.  It also
        looks for its configuration file in
        $ELASTICMQ_DATA_PREFIX/conf/Default.scala.  You can use the
        Default.scala included in the distribution as a template.
      '';
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
