{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    configure = {
      customRC = ''
      '';
      customLuaRC = ''
      '';
    };
    plugins = [
      inherit (pkgs.vimPlugins)
      {
        plugin = nvim-biscuits;
        config = ''
          packadd! nvim-biscuits
          lua <<EOF
          
          EOF
        '';
      }
    ];
  };


}
