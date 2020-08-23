
let

  dimension = name: attrs: f:
    builtins.mapAttrs
      (k: v:
       let o = f k v;
       in o // { recurseForDerivations = o.recurseForDerivations or true; }
      )
      attrs
    // { meta.dimension.name = name; };
  
  haskellPackages = pkgs:
    let

      projectPackages =
        pkgs.haskell-nix.haskellLib.selectProjectPackages 
          (import ./pkg/hs { inherit pkgs; });

      # These functions pull out from the Haskell package set either all the
      # components of a particular type, or all the checks.
      collectChecks = _: xs:
        pkgs.recurseIntoAttrs (builtins.mapAttrs (_: x: x.checks) xs);

      collectComponents = type: xs:
        pkgs.haskell-nix.haskellLib.collectComponents' type xs;

    in
      # This computes the Haskell package set sliced by component type
      pkgs.recurseIntoAttrs
        (dimension
          "Haskell component"
          {
            "library" = collectComponents;
            "tests" = collectComponents;
            "benchmarks" = collectComponents;
            "exes" = collectComponents;
            "checks" = collectChecks;
          }
          # Apply the selector to the Haskell package set
          (type: selector: (selector type) projectPackages));

  pkgs = import ./nix/nixpkgs.nix { };
  musl = import ./nix/nixpkgs-musl.nix { };

in {
  haskell = haskellPackages pkgs;
  haskellMusl = haskellPackages musl;
  linux64 = import ./release.nix { inherit pkgs; };
}
