{
  description = "A good starting flake for a project to use nix as a package manager";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs } @ inputs:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          self.overlays.default
          # inputs.someOtherFlake.overlays.default
        ];
        config = {
          allowUnfree = true;
          #  permittedInsecurePackages = [
          #     Usually some python version
          #  ];
        };
      };
    in
    {
      # set of overlays provided by only this flake
      overlays.default = import ./nix/overlays/default.nix;

      # for testing. This causes an error with nix flake show but still works
      # with nix build .#pkgs.yourpackage as intended
      pkgs = pkgs;

      packages.x86_64-linux = {
        hello = pkgs.hello;
      };

      checks.x86_64-linux = {
        default = pkgs.hello;
      };

      devShells = {
        default = pkgs.mkShell
          {
            buildInputs = with pkgs;[
              cmake
            ];
          };
      };
    };
}
