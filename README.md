# radian-flake
A Nix flake for the excellent [radian console](https://github.com/randy3k/radian) in R.

Experimental - I'm still new to flakes and am not 100% sure if this builds consistently on anything other than x86_64-linux.

Run radian using `nix run github:swt30/radian-flake`. Or create an R development environment using a flake like the one below:

```nix
# flake.nix

{
  description = "A development environment that includes R and radian";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.r-radian.url = "github:swt30/radian-flake";
  inputs.r-radian.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, r-radian }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      radian = r-radian.packages.${system}.radian;
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          R
          radian
          # here you can also include other R packages you need, like:
          # rPackages.tidyverse
          # rPackages.DBI
          # rPackages.shiny
        ];
      };
    });
}
```

Run `nix develop` in the directory containing the above `flake.nix` to launch the development shell.
