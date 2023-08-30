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
          overlays = [ (import ./nix/overlays) ];

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
        # The hello package can be built by running `nix build '.#hello'`
        packages = {
          hello = pkgs.hello;
        };

        # If you uncomment this line. You will be able build the hello package
        # by simply invoking `nix build`
        #defaultPackage = self.packages.${system}.hello;
      }
    );
}
