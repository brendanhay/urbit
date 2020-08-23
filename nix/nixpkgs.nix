{ sources ? import ./sources.nix, ... }@args:

let

  haskellNix = import sources.haskell-nix { };

  # By using haskell.nix's own pins we should get a higher cache
  # hit rate from `cachix use iohk`.
  nixpkgsSrc = haskellNix.sources.nixpkgs-2003;
  nixpkgsArgs = haskellNix.nixpkgsArgs // args;
  nixpkgs = import haskellNix.sources.nixpkgs-2003 nixpkgsArgs;

in nixpkgs // { inherit sources; }
