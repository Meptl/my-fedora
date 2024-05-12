{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
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

        # For aider
        stdenv.cc.cc
      ];

      shellHook = ''
           export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath buildInputs}
      '';
    };
  };
}
