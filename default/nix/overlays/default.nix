final: prev:

{
  hello = final.callPackage ./pkgs/hello { };
  release-it = final.callPackage ./pkgs/release-it { };

  lib = prev.lib // import ./lib/read-version-from-file.nix;
}
