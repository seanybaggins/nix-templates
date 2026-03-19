final: prev:

{
  hello = final.callPackage ./pkgs/hello { };
  release-it = final.callPackage ./pkgs/release-it { };
}
