{ pkgs ? import <nixpkgs> {} }:

let
  buildNodejs = pkgs.callPackage "${pkgs.path}/pkgs/development/web/nodejs/nodejs.nix" {};
in
  buildNodejs {
    enableNpm = true;
    version = "10.15.0";
    sha256 = "0gnygq4n7aar4jrynnnslxhlrlrml9f1n9passvj2fxqfi6b6ykr";
  }
