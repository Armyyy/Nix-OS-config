{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # kill "direnv: loading ..." / "direnv: export +AR +AS ..." spam
    silent = true;

    # Written to ~/.config/direnv/direnvrc, sourced before every .envrc.
    #
    # devenv 2.3.1 stopped honouring `--quiet` for the task-runner progress lines,
    # so every `cd` into a devenv project prints:
    #   • Running devenv:files:cleanup
    #   ✓ Running devenv:files:cleanup in 10.9ms
    #   • Running devenv:enterShell            (etc.)
    # There is no flag, env var or devenv.nix option to turn these off, so filter
    # them out of stderr. Failures (✗ ⚠), Nix eval errors and anything a project's
    # own enterShell prints are left untouched.
    stdlib = ''
      _devenv_noise_filter() {
        grep --line-buffered -vE \
          '^[[:space:]]*(└[[:space:]]*)?[•✓] (Running|Validating|Configuring|Evaluating|Loading|Building) ' >&2
      }

      # Wrap direnv's `use` dispatcher rather than `use_devenv` itself: `use_devenv`
      # does not exist yet at this point, it is defined later by the
      # `eval "$(devenv direnvrc)"` line inside each project's .envrc.
      eval "_direnv_use_orig() $(declare -f use | tail -n +2)"
      use() {
        if [[ ''${1:-} == devenv ]]; then
          shift
          # No subshell: use_devenv must export into the current shell.
          use_devenv "$@" 2> >(_devenv_noise_filter)
          return
        fi
        _direnv_use_orig "$@"
      }
    '';
  };
}
