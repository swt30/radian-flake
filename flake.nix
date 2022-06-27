{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    py-rchitect.url = "github:randy3k/rchitect/v0.3.36";
    py-rchitect.flake = false;

    py-radian.url = "github:randy3k/radian/v0.6.3";
    py-radian.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, py-rchitect, py-radian }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = rec {
        rchitect = pkgs.python3Packages.buildPythonPackage {
          pname = "rchitect";
          version = "0.3.36";
          src = py-rchitect;
          doCheck = false;
          preBuild = ''
            export HOME=$TMP
          '';
          propagatedBuildInputs = with pkgs.python3Packages; [
            pkgs.R
            cffi
            six
          ];
        };

        radian = pkgs.python3Packages.buildPythonApplication {
          pname = "radian";
          version = "0.6.3";
          src = py-radian;
          doCheck = false;
          preBuild = ''
            export HOME=$TMP
          '';
          propagatedBuildInputs = with pkgs.python3Packages; [
            self.packages.${system}.rchitect
            prompt_toolkit
            pygments
          ];
        };

        default = radian;
      };
    });
}
