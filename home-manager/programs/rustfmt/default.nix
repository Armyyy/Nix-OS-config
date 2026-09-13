{ ... }:

{
  # rustfmt walks up from the file being formatted looking for rustfmt.toml /
  # .rustfmt.toml, so one at $HOME covers every project under it. A project's
  # own rustfmt.toml still wins — it is the nearer ancestor.
  #
  # rustfmt is not installed globally; it comes from each project's devenv
  # (languages.rust). rust-analyzer shells out to it on save, which is what
  # helix's built-in `auto-format = true` for rust triggers.
  home.file.".rustfmt.toml".text = ''
    # match the 80-col guides in helix (rulers) and zed (wrap_guides)
    max_width = 80

    # scales fn_call_width / chain_width / struct_lit_width etc. off max_width
    # instead of pinning them to the 100-col defaults
    use_small_heuristics = "Default"
  '';
}
