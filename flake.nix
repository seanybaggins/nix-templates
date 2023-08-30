{
  description = "A good starting flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;

          # Add your overlays in the ./nix/overlays directory
          #overlays = (import ./nix/overlays);         

          # Special nixpkgs configs go here
          #config = {
          #  allowUnfree = true;
          #  permittedInsecurePackages = [
          #     Usually some python version
          #  ];
          #}

        };
      in
      {
        packages = {
          hello = pkgs.hello;
        };

        defaultPackage = self.packages.${system}.hello;
      }
    );
}
