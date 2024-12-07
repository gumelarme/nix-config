# Shell for bootstrapping flake-enabled nix and home-manager
# You can enter it through 'nix develop' or (legacy) 'nix-shell'
{
  checks,
  pkgs ? (import ./nixpkgs.nix) {},
}: {
  default = pkgs.mkShell {
    inherit (checks) shellHook;
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [nix home-manager git];
    buildInputs = checks.enabledPackages;
  };
}
