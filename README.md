# My Nix Config
A laptop nix config

## TODO:
- [ ]  Rofi
    - [x] Theme
    - [x] Power Menu
    - [ ] Multimonitor configuration (also with autorandr)
- [ ] Lock screen
  - [ ] replace xautolock with xidlehook
- [x] Auto sleep, hibernate etc.
- [x] Notification
    - [x] Theme 
    - [x] Volume
    - [x] Brightness
    - [x] Mute Mic
    - [x] Battery, low - full
- [x] Qtile
    - [x] Tidy up configs
    - [x] Bar 
        - [x] Theme
        - [x] Mute Mic
- [ ] nnn
    - [x] configure nnn
    - [ ] create derivation and  configuration to nix
- [ ] development env
  - [ ] tree-sitter (fix abi version to high)
  - [ ] lsp (pyright, gopls)
  - [ ] git (aliases, tools)
- [ ] mopidy
- [ ] firefox's userchrome

## Bugs
### fcitx5
fcitx5 doesnt work on some apps, notably `emacs` and `alacritty`
this can be solved by launching the app with `LC_CTYPE` set to zh, ja example:

``` sh
LC_CTYPE=zh_CN.UTF-8 emacs
LC_CTYPE=zh_CN.UTF-8 alacritty 
```
setting `LC_CTYPE` on nixos configuration doesnt work, 
changing `i18n.defaultLocale` or adding it to `i18n.supportedLocales` also doesnt work.


