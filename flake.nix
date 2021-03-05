{
  description = "A CALA development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let system = "x86_64-darwin";
        pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShell = import ./shell.nix { inherit pkgs; };
    };
}
