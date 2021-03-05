{
  description = "A CALA development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs }:
    let system = "x86_64_darwin";
        pkgs = import nixpkgs { inherit system; };
    in {
      devShell = import ./shell.nix { inherit pkgs; };
    };
}
