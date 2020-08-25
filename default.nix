{ pkgs ? import ./nix/nixpkgs.nix { } }:

let

  ivory = pkgs.fetchgithublfs { src = ./bin/ivory.pill; };

  self = import ./nix/pkgs { inherit pkgs; };
  deps = import ./nix/deps { inherit pkgs ivory; };

in deps // self
