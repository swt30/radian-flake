{
  inputs = {
    rchitect.url = "github:randy3k/rchitect/v0.3.36";
    rchitect.flake = false;

    radian.url = "github:randy3k/radian/v0.6.3";
    radian.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, rchitect, radian }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = {
          rchitect = pkgs.python3Packages.buildPythonPackage {
            pname = "rchitect";
            version = "0.3.36";
            src = rchitect;

            preBuild = "export HOME=$TMP";
            buildInputs = with pkgs.python3Packages; [ pytest-runner ];
            propagatedBuildInputs = with pkgs.python3Packages; [
              pkgs.R
              cffi
              six
            ];
            doCheck = false;
          };

          radian = pkgs.python3Packages.buildPythonApplication {
            pname = "radian";
            version = "0.6.3";
            src = radian;

            preBuild = "export HOME=$TMP";
            buildInputs = with pkgs.python3Packages; [ pytest-runner ];
            propagatedBuildInputs = with pkgs.python3Packages; [
              self.packages.${system}.rchitect
              prompt_toolkit
              pygments
            ];
            doCheck = false;
          };

          default = self.packages.${system}.radian;
        };
      });
}
