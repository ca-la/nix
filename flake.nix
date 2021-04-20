{
  description = "A CALA development environment";

  inputs.nixpkgs-latest.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.nixpkgs-stable.url = "github:NixOs/nixpkgs?rev=bed08131cd29a85f19716d9351940bdc34834492";

  outputs = { self, nixpkgs-latest, nixpkgs-stable }:
    let system = "x86_64-darwin";
        latest = import nixpkgs-latest {
          inherit system;
          config.allowUnfree = true;
        };
        stable = nixpkgs-stable.legacyPackages.${system};
    in {
      devShell.${system} = import ./shell.nix {
        inherit stable latest;
      };
    };
}
