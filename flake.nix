{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      bluebuild.url = "https://flakehub.com/f/blue-build/cli/0.8.7.tar.gz";
  };

  outputs = { self, nixpkgs, bluebuild }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    devShell.${system} = pkgs.mkShell rec {
      buildInputs = with pkgs; [
        pre-commit

        cosign
        bluebuild.packages.${system}.default
      ];

      shellHook = ''
           export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath buildInputs}
      '';
    };
  };
}
