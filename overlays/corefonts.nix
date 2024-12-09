{
  final,
  prev,
}: let
  fonts = [
    {
      name = "andale";
      hash = "sha256-BST+QpUa3Dp+uHDjLwkgMTxx8XDIWbX3cNgrTuER6XA=";
    }
    {
      name = "arial";
      hash = "sha256-hSl6TRRunIesb3SCJzS97l9LKnItfqpYS38sv3b0ePY=";
    }
    {
      name = "arialb";
      hash = "sha256-pCXw/7ahpe3luXntYXf09PT972rnwwKnt3IO8zL+wKg=";
    }
    {
      name = "comic";
      hash = "sha256-nG3z/u/eJtTkHUpP5dsqifkSOncllNf1mv0GJiXNIE4=";
    }
    {
      name = "courie";
      hash = "sha256-u1EdhhZV3eh5rlUuuGsTTW+uZ8tYUC5v9z7F2RUfM4Q=";
    }
    {
      name = "georgi";
      hash = "sha256-LCx9zaZgbqXPCJGPt80/M1np6EM43GkAE/IM1C6TAwE=";
    }
    {
      name = "impact";
      hash = "sha256-YGHvO3QB2WQvXf218rN2qhRmP2J15gpRIHrU+s8vzPs=";
    }
    {
      name = "times";
      hash = "sha256-21ZZXsbvXT3lwkmU8AHwOyoT43zuJ7wlxY9vQ+j4B6s=";
    }
    {
      name = "trebuc";
      hash = "sha256-WmkNm7hRC+G4tP5J8fIxllH+UbvlR3Xd3djvC9B/2sk=";
    }
    {
      name = "webdin";
      hash = "sha256-ZFlbWrwQgPuoYQxcNPq1hjQI6Aaq/oRlPKhXW+0X11o=";
    }
    {
      name = "verdan";
      hash = "sha256-wcthJV42MWZ5TkdmTi8hr446JstjRuuNKuL6hd1arZY=";
    }
    {
      name = "wd97vwr";
      hash = "sha256-9hEmptF7LRJqfzGxQlBNzkk095icVfHBPGR3s/6As9I=";
    }
  ];
in
  prev.corefonts.overrideAttrs (
    _oldAtttrs: {
      exes = map ({
        name,
        hash,
      }:
        final.fetchurl {
          url = "https://f003.backblazeb2.com/file/squirrel-stash/pkgs/corefonts/${name}32.exe";
          inherit hash;
        })
      fonts;
    }
  )
