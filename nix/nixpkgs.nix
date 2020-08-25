{ sources ? import ./sources.nix, ... }@args:

let

  haskellNix = import sources.haskell-nix { };

  nixpkgsArgs = haskellNix.nixpkgsArgs // args // {
    overlays = haskellNix.nixpkgsArgs.overlays; # ++ overlays;
  };

  # By using haskell.nix's own pins we should get a higher cache
  # hit rate from `cachix use iohk`.
  nixpkgs = import haskellNix.sources.nixpkgs-2003 nixpkgsArgs;

in nixpkgs // {
  inherit sources;

  fetchgithublfs = import ./fetchgithublfs { pkgs = nixpkgs; };
}
