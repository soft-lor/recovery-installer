{
  pkgs,
  std,
}: let
  keymapFile = pkgs.writeText "keymap.toml" (std.serde.toTOML (import ./keymap.nix));
  luainit = pkgs.writeText "init.lua" ''
    require("zoxide"):setup {update_db = true,}
  '';
in
  pkgs.symlinkJoin {
    name = "yazi-wrapped";
    paths = [pkgs.yazi pkgs.dragon-drop pkgs._7zz pkgs.fd];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      cp ${keymapFile} $out/keymap.toml
      cp ${luainit} $out/init.lua
      cp -r ${./plugins} $out/plugins

      wrapProgram $out/bin/yazi \
        --set YAZI_CONFIG_HOME $out
    '';
  }
