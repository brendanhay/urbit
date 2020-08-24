{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  name = "pills";
  src = pkgs.lib.cleanSourceWith {
    src = ../../..;
    filter = path: type:
      pkgs.lib.hasInfix ".git" path || pkgs.lib.hasInfix "bin" path;
  };
  preferLocalBuild = true;
  nativeBuildInputs = [ pkgs.xxd pkgs.git pkgs.git-lfs ];
  unpackPhase = "true";
  installPhase = ''
    cp -R --no-preserve=mode,ownership $src tmp

    pushd tmp >/dev/null

    git lfs install --local --skip-smudge
    git lfs pull

    popd >/dev/null

    mv tmp/bin $out
  '';
}
