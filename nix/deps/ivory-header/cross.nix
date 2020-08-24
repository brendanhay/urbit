{ crossenv, pills }:

crossenv.make_derivation {
  name          = "ivory.h";
  builder       = ./builder.sh;
  native_inputs = [ crossenv.nixpkgs.xxd ];
}
