# radian-flake
A Nix flake for the excellent [radian console](https://github.com/randy3k/radian) in R.

Run radian using `nix run github:swt30/radian-flake`. Or include it in a R development environment using a flake like the one below:

```nix
{
  description = "A development shell flake that includes R and radian";

  inputs.nixpkgs.url = "nixpkgs";
  inputs.flake-utils.url = "flake-utils";
  inputs.r-radian.url = "github:swt30/radian-flake";
  inputs.r-radian.inputs.follows = "nixpkgs";

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
