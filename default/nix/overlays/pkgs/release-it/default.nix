{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nodejs,
  git,
  openssh,
}:

buildNpmPackage rec {
  pname = "release-it";
  version = "15.11.0";

  src = fetchFromGitHub {
    owner = "release-it";
    repo = pname;
    rev = "${version}";
    hash = "sha256-zPrW0d7rEea7hekiymQ+XZvb9pdWGFFLWIZN/yWD/t4=";
  };

  dontNpmBuild = true;
  npmDepsHash = "sha256-m4yGRzkZYz3PtWWhPinRF4RlLt4VX1EMeGDjWdI3kdI=";

  nativeBuildInputs = [
    makeWrapper
  ];

  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
    cp ${./package.json} ./package.json
  '';

  preInstall = ''
    mkdir -p $out/share
    cp ${./release-it.json} $out/share/release-it.json
  '';

  postInstall = ''
    mv $out/bin/release-it $out/bin/release-it-raw

    # Use release-it's built-in binary, but wrap config 
    makeWrapper $out/bin/release-it-raw $out/bin/release-it \
      --add-flags "--config $out/share/release-it.json" \
      --set PATH ${
        lib.makeBinPath [
          nodejs
          git
          openssh
        ]
      }
  '';

  meta = {
    description = "Conventional changelog plugin for release-it";
    homepage = "https://github.com/release-it/conventional-changelog";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
