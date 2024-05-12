{
  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: (utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages."${system}";
    in {
        devShell = pkgs.mkShell rec {
          venvDir = "./venv";
          buildInputs = with pkgs; [
            python312Packages.venvShellHook
            python312Packages.flake8
            python312Packages.ipdb

            pre-commit

            pkgs.stdenv.cc.cc
          ];
          postShellHook = ''
           export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath buildInputs}

           # Takes a bit of time, so we'll keep it commented.
           # pip install -r requirements.txt
           # pip install -e .
          '';
        };
      }
  ));
}
