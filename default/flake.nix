{
  description = "A good starting flake for a project to use nix as a package manager";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs } @ inputs:
    let
      supportedSystems = [ "x86_64-linux" ];
      # Function to make the flake usable across machines with different system
      # architectures. See devShells and packages for usage.
      eachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ]; # ++ overlays from other flakes
            config = {
              allowUnfree = true;
              #  permittedInsecurePackages = [
              #     Usually some python version
              #  ];
            };
          };
        in
        f pkgs);
    in
    {
      # set of overlays provided by only this flake
      overlays.default = import ./nix/overlays/default.nix;

      packages = eachSupportedSystem (pkgs: {
        hello = pkgs.hello;

        # for testing. This causes an error with nix flake show but still works
        # with nix build .#pkgs.yourpackage as intended
        # pkgs = pkgs;
      });

      devShells = eachSupportedSystem
        (pkgs: {
          default = pkgs.mkShell
            {
              buildInputs = with pkgs;[
                cmake
              ];
            };
        });
    };
}
