{
  programs.television = {
    enable = true;

    channels = {
      "man-pages" = {
        metadata = {
          name = "man-pages";
          description = "Browse and preview system manual pages";
          requirements = [ "apropos" "man" "col" ];
        };
        source.command = "apropos .";
        preview = {
          command = "man '{0}' | col -bx";
          env.MANWIDTH = "80";
        };
        keybindings = {
          "ctrl-b" = "actions:bat";
          "ctrl-n" = "actions:nvim";
        };
        ui = {
          layout = "landscape";
          preview_panel.header = "{0}";
        };
        actions = {
          bat = {
            description = "Pipe to bat";
            command = "man '{0}' | bat -l man";
            mode = "fork";
          };
          nvim = {
            description = "Pipe to nvim";
            command = "man '{0}' | nvim";
            mode = "fork";
          };
        };
      };
    };
  };
}
