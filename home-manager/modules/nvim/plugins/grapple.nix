{pkgs, ...}: {
  config = {
    programs.nixvim.extraPlugins = [
      pkgs.vimPlugins.grapple-nvim
    ];

    programs.nixvim.keymaps = let
      bind = key: action: desc: {
        key = "<leader>${key}";
        action = "<cmd>${action}<CR>";
        options = {inherit desc;};
      };
      bindTag = index: bind "q${index}" "Grapple select index=${index}" "Grapple ${index}";
    in
      [
        (bind "qq" "Grapple open_tags" "Open")
        (bind "qt" "Grapple toggle" "Toggle")
        (bind "qn" "Grapple cycle_tags next" "Next tag")
        (bind "qp" "Grapple cycle_tags prev" "Previous tag")
      ]
      ++ (map bindTag (map toString [1 2 3 4 5]));
  };
}
