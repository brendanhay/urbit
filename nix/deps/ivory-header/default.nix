{ pkgs, pills }:

pkgs.stdenv.mkDerivation {
  name              = "ivory.h";
  src               = pills;
  builder           = ./builder.sh;
  preferLocalBuild  = true;
  nativeBuildInputs = [ pkgs.xxd ];
}
