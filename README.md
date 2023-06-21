# My Nix Config
A laptop nix config

## TODO:
- [x]  Rofi
    - [x]  Theme
    - [x]  Power Menu
- [x] Lock screen
- [x] Auto sleep, hibernate etc.
- [ ] Notification
    - [x] Theme 
    - [x] Volume
    - [x] Brightness
    - [x] Mute Mic
    - [x] Battery, low - full
- [ ] Qtile
    - [x] Tidy up configs
    - [ ] Bar 
        - [ ] Theme
        - [x] Mute Mic

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


