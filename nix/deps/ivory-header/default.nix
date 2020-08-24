{ pkgs, ivory ? ../../../bin/ivory.pill }:

pkgs.stdenv.mkDerivation {
  name              = "ivory.h";
  src               = ivory;
  nativeBuildInputs = [ pkgs.xxd pkgs.git-lfs ];
  unpackPhase = "git lfs install";
  

  installPhase = ''
cat $src > u3_Ivory.pill
xxd -i u3_Ivory.pill > ivory.h

mkdir -p $out/include

mv ivory.h $out/include
rm u3_Ivory.pill

'';
}
