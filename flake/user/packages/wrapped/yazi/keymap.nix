{
  mgr.prepend_keymap = [
    {
      on = "W";
      run = "plugin what-size";
      desc = "Calc size of selection or cwd";
    }
    {
      on = "<C-n>";
      run = "shell 'dragon-drop -x -T -A \"$@\"' --confirm";
      desc = "Create drag & drop files from selection";
    }
    {
      on = "Z";
      run = "plugin fzf";
      desc = "Jump to a file/directory via fzf";
    }
    {
      on = "z";
      run = "plugin zoxide";
      desc = "Jump to a directory via zoxide";
    }
    {
      on = "<Enter>";
      run = "plugin smart-enter";
      desc = "Open selected file";
    }
  ];
}
