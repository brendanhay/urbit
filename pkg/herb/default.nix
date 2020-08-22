{ pkgs ? import ../../nix/nixpkgs.nix {} }:

let

  pyenv = pkgs.python2.withPackages (py: [ py.requests ]);
  pyexe = "${pyenv}/bin/python";

in

pkgs.stdenv.mkDerivation rec {
  name         = "herb";
  buildInputs  = [ pyenv ];
  unpackPhase  = "true";
  installPhase = ''
    mkdir -p $out/bin

    cp ${./herb} $out/bin/herb.py

    cat > $out/bin/herb <<EOF
    #!/usr/bin/env bash
    ${pyexe} $out/bin/herb.py "\$@"
    EOF

    chmod +x $out/bin/herb
  '';
}
