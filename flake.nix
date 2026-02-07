{
  description = "A simple Scotty web application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          packageName = "amerihac2026";
        in
        {
          packages = {
            ${packageName} = pkgs.haskellPackages.callCabal2nix packageName inputs.self { };
            default = self'.packages.${packageName};
          };

          devShells.default = pkgs.mkShell rec {

            PGDATABASE = "amerihac2026";

            buildInputs =
              with pkgs.haskellPackages;
              [
                ghc
                cabal-install
                haskell-language-server
                scotty
                aeson
                text
                postgresql-simple
              ]
              ++ [
                pkgs.zlib
                pkgs.pkg-config
                pkgs.postgresql
                pkgs.just
              ];

            shellHook = ''
              export CABAL_DIR="$PWD/.cabal"
              export PGDATA="$PWD/.postgres/data"
              export PGHOST="$PWD/.postgres"
              export PGUSER="$USER"
              export DATABASE_URL="postgresql:///$PGDATABASE?host=$PGHOST"
              echo '>>> Run "cabal update && cabal run" to start the server'
            '';

          };
        };
    };
}
