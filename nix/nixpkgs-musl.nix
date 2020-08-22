{ ... }@args:

let

  nixpkgsArgs = {
    crossSystem.config = "x86_64-unknown-linux-musl";
  } // args;
  nixpkgs = import ./nixpkgs.nix nixpkgsArgs;
    
in nixpkgs
