{ pkgs, ... }:
{
  # mdformat + GFM plugin so markdown tables get column-aligned (padded)
  home.packages = [ (pkgs.mdformat.withPlugins (ps: [ ps.mdformat-gfm ])) ];
}
