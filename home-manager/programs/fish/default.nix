{
  programs.fish = {
    enable = true;
    functions = {
      fish_command_not_found = {
        body = builtins.readFile ./functions/fish_command_not_found.fish;
        description = "command not found handler with nix-index lookup and 10min cache";
      };
      hpick = {
        body = builtins.readFile ./functions/hpick.fish;
        description = "copy history entry to clipboard via fzf";
      };
      hclean = {
        body = builtins.readFile ./functions/hclean.fish;
        description = "delete history entries via fzf multi-select";
      };
      killport = {
        body = builtins.readFile ./functions/killport.fish;
        description = "kill process by port via fzf";
      };
      pgcsv = {
        body = builtins.readFile ./functions/pgcsv.fish;
        description = "run SQL/CSV through postgres and view with csvlens";
      };
      devBackend = {
        body = builtins.readFile ./functions/devBackend.fish;
        description = "run air dev server, auto-refresh pgcsv on form design saves";
      };
      htmlLive = {
        body = builtins.readFile ./functions/htmlLive.fish;
        description = "start live-reload preview server and open browser";
      };
      cdf = {
        body = builtins.readFile ./functions/cdf.fish;
        description = "fuzzy cd to any dir or file parent under HOME";
      };
      dps = {
        body = builtins.readFile ./functions/dps.fish;
        description = "docker ps with csvlens viewer";
      };
      fipre = {
        body = builtins.readFile ./functions/fipre.fish;
        description = "fuzzy find files with bat preview";
      };
      flist = {
        body = builtins.readFile ./functions/flist.fish;
        description = "list custom fish functions with descriptions";
      };
      alist = {
        body = builtins.readFile ./functions/alist.fish;
        description = "list shell aliases with fzf picker or --csv for csvlens view";
      };
      aflist = {
        body = builtins.readFile ./functions/aflist.fish;
        description = "list all aliases and functions with type and description, sorted alphabetically";
      };
      tls = {
        body = builtins.readFile ./functions/tls.fish;
        description = "list tmux sessions with csvlens viewer";
      };
      tclean = {
        body = builtins.readFile ./functions/tclean.fish;
        description = "kill detached tmux sessions with preview";
      };
      tbr = {
        body = builtins.readFile ./functions/tbr.fish;
        description = "rename a tmux buffer via fzf picker";
      };
      tbd = {
        body = builtins.readFile ./functions/tbd.fish;
        description = "delete tmux buffers via fzf multi-select";
      };
      pPath = {
        body = builtins.readFile ./functions/pPath.fish;
        description = "show PATH entries one per line, nix store dimmed";
      };
      ypath = {
        body = builtins.readFile ./functions/ypath.fish;
        description = "fuzzy find file/dir and yank path to clipboard";
      };
    };
    shellAliases = import ./conf.d/aliases.nix;
    shellInit = builtins.readFile ./conf.d/init.fish;
    interactiveShellInit = builtins.readFile ./conf.d/interactive.fish;
  };
}
