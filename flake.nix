{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    connections.url = "github:cmk/connections";
    connections.flake = false;
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ inputs.haskell-flake.flakeModule ];

      perSystem = { self', pkgs, ... }: {

        haskellProjects.default = {
          basePackages = pkgs.haskell.packages.ghc981;

          packages = {
            connections.source = inputs.connections;
            ## singleton-bool.source = inputs.singleton-bool;
            singleton-bool.source = "0.1.7";
          };
          settings = {
            finite-typelits = {
              jailbreak = true;
            };
            # singleton-bool = {
            #   jailbreak = true;
            # };
            connections = {
              jailbreak = true;
            };
            lukko = {
              jailbreak = true;
              check = false;
            };
          };

          devShell = {
            hlsCheck.enable = true;
          };
        };

        packages.default = self'.packages.rings;
      };
    };
}
