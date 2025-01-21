{pkgs, ...}: {
  imports = [
    ./fzf-lua.nix
    ./grapple.nix
    ./quick-scope.nix
    ./smear.nix
    ./mini_indentscope.nix
    ./mini_hipatterns.nix
  ];

  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    todo-txt-vim
  ];

  # NOTE: used by fzf-lua, trouble, neotree
  programs.nixvim.plugins.mini = {
    enable = true;
    mockDevIcons = true;
    modules.icons = {};
  };
}
