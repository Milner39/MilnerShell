{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, quickshell, ... } @ inputs: let
    inherit (flake-utils.lib) system;
    systems = [ system.x86_64-linux ];

  in flake-utils.lib.eachSystem systems (system: let
    pkgs = import nixpkgs { inherit system;
      config.allowUnfree = true;
    };

  in {
    # nix develop
    devShells.default = pkgs.mkShell {
      packages = [
        (quickshell.packages.${system}.default.withModules [])
      ];
    };
  });
}