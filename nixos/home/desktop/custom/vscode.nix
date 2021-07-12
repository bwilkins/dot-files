{ lib, pkgs, config, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools
      tamasfe.even-better-toml
      matklad.rust-analyzer
      bbenoist.Nix
      vscodevim.vim
    ];
  };
}
