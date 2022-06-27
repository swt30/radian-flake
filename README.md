# radian-flake
A Nix flake for the excellent [radian console](https://github.com/randy3k/radian) in R.

Build this flake with `nix build .#radian`, or include it in other flakes
using the github address of this repo `github:swt30/radian-flake`. For example:

```nix
{
  description = "A development shell flake that includes R and radian";

  inputs.nixpkgs.url = "nixpkgs";
  inputs.flake-utils.url = "flake-utils";
  inputs.r-radian.url = "github:swt30/radian-flake";

  outputs = { self, nixpkgs, flake-utils, r-radian }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      radian = r-radian.packages.${system}.radian;
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          R
          radian
        ];
      };
    });
}
```
