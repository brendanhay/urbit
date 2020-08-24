{ pkgs, ivory ? ../../../bin/ivory.pill }:

pkgs.stdenv.mkDerivation {
  name              = "ivory.h";
  src               = pkgs.lib.cleanSourceWith {
    src = ../../..;
    filter = path: type:
      let baseName = baseNameOf (toString path);
      in (baseName == ".git" || baseName == "bin");
  };

  nativeBuildInputs = [ pkgs.xxd pkgs.git pkgs.git-lfs ];

  unpackPhase = ''
     git lfs install --local
     git lfs pull
 '';

  installPhase = ''
cat $src > u3_Ivory.pill
xxd -i u3_Ivory.pill > ivory.h

mkdir -p $out/include

mv ivory.h $out/include
rm u3_Ivory.pill

'';
}
