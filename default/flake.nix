{
  description = "A good starting flake for a project to use nix as a package manager";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }@inputs:
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

      # pacakages defined for the developer. Can be built using
      # `nix build`
      packages.x86_64-linux = {
        hello = pkgs.hello;
      };

      # The gaunlet of packages to be run and tested in the CI/CD system when
      # running the following command
      # `nix flake check`
      checks.x86_64-linux = {
        default = pkgs.hello;
      };

      # The development environment that gets triggered when using direnv and
      # cding into the directory that contains this flake file or below
      devShells = {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cmake
          ];
        };
      };
    };
}
