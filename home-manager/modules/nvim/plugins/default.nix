{pkgs, ...}: {
  imports = [
    ./telescope.nix
    ./quick-scope.nix
  ];

  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    todo-txt-vim
  ];
}
