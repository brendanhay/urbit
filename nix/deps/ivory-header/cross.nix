{ crossenv, ivory ? ../../../bin/ivory.pill }:

crossenv.make_derivation {
  name          = "ivory.h";
  builder       = ./builder.sh;
  native_inputs = [ crossenv.nixpkgs.xxd ];

  IVORY = ivory;
}
