# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # fish 4.9.3 panics with "attempt to subtract with overflow" whenever a vi
    # repeat-jump (`;` / `,`) with Till precision runs on an empty command
    # line: src/reader/reader.rs computes `el.len() - 1` on a usize. Since
    # `t`/`T` (and the `ci<x>`/`di<x>`/`yi<x>` chains) leave Till as the
    # remembered precision for the rest of the session, a single `;` at an
    # empty normal-mode prompt kills the shell. Not fixed upstream as of 4.9.3.
    fish = prev.fish.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [ ./fish-jump-till-overflow.patch ];
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
