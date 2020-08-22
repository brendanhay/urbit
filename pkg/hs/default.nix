{ pkgs ? import ../../nix/nixpkgs.nix { } }:

let

  project = pkgs.haskell-nix.stackProject {
    src = pkgs.haskell-nix.cleanSourceHaskell {
      name = "urbit-king";
      src = ../../pkg/hs;
    };

    modules = [{ 
      # This corresponds to the set of packages (boot libs) that ship with GHC.
      # We declare them here to ensure any dependency gets them from GHC iteself
      # rather than trying to re-install them into the package database.
      nonReinstallablePkgs = [
        "Cabal"
        "Win32"
        "array"
        "base"
        "binary"
        "bytestring"
        "containers"
        "deepseq"
        "directory"
        "filepath"
        "ghc"
        "ghc-boot"
        "ghc-boot-th"
        "ghc-compact"
        "ghc-heap"
        "ghc-prim"
        "ghci"
        "ghcjs-prim"
        "ghcjs-th"
        "haskeline"
        "hpc"
        "integer-gmp"
        "integer-simple"
        "mtl"
        "parsec"
        "pretty"
        "process"
        "rts"
        "stm"
        "template-haskell"
        "terminfo"
        "text"
        "time"
        "transformers"
        "unix"
        "xhtml"
      ];

      # Disable the urbit-king test-suite for now - since it relies on pills/lfs.
      packages = { 
         urbit-king.doCheck = false;
      };
    }];
  };

in project
