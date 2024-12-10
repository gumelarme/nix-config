{pkgs, ...}: {
  imports = [
    ./telescope.nix
    ./quick-scope.nix
    ./smear.nix
    ./mini_indentscope.nix
  ];

  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    todo-txt-vim
  ];
}
