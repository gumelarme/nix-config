{pkgs, ...}: {
  imports = [
    ./telescope.nix
    ./quick-scope.nix
    ./smear.nix
    ./mini_indentscope.nix
    ./mini_hipatterns.nix
  ];

  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    todo-txt-vim
  ];
}
