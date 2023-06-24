# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # capture-last-output = pkgs.callPackage ((import ./tmux-custom-plugin.nix) { inherit pkgs; }).capture-last-output;
  # fzf-session-switch = pkgs.callPackage ((import ./tmux-custom-plugin.nix) { inherit pkgs; }).fzf-session-switch;
}
