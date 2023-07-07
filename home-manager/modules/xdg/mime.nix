{ lib, ... }:

{
  xdg.mimeApps = {
    enable = true;
    associations = {
      added = { };
      removed = { "image/*" = [ "gimp.desktop" "org.kde.ark.desktop" ]; };
    };

    defaultApplications = let
      # TODO:
      # - Add more programming related text files
      # - Add document types
      # - SVG
      image = [ "image/*" ];
      pdf = [ "application/pdf" ];
      code = [
        "text/*"
        "text/markdown"
        "text/org"
        "text/plain"
        "text/x-log"
        "text/x-tex"
        "text/x-python"
        "application/json"
        "application/toml"
        "application/x-makefile"
        "application/x-shellscript"
        "application/x-yaml"
      ];

      web = [
        "text/html"
        "application/x-extension-htm"
        "application/x-extension-html"
        "application/x-extension-shtml"
        "application/x-extension-xht"
        "application/x-extension-xhtml"
        "application/xhtml+xml"
        "x-scheme-handler/about"
        "x-scheme-handler/ftp"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/unknown"
      ];

      audio = [
        "audio/*"
        "audio/flac"
        "application/ogg"
        "application/x-ogg"
        "application/mxf"
        "application/sdp"
        "application/smil"
        "application/x-smil"
        "application/streamingmedia"
        "application/x-streamingmedia"
        "application/vnd.rn-realmedia"
        "application/vnd.rn-realmedia-vbr"
        "audio/aac"
        "audio/x-aac"
        "audio/vnd.dolby.heaac.1"
        "audio/vnd.dolby.heaac.2"
        "audio/aiff"
        "audio/x-aiff"
        "audio/m4a"
        "audio/x-m4a"
        "application/x-extension-m4a"
        "audio/mp1"
        "audio/x-mp1"
        "audio/mp2"
        "audio/x-mp2"
        "audio/mp3"
        "audio/x-mp3"
        "audio/mpeg"
        "audio/mpeg2"
        "audio/mpeg3"
        "audio/mpegurl"
        "audio/x-mpegurl"
        "audio/mpg"
        "audio/x-mpg"
        "audio/rn-mpeg"
        "audio/musepack"
        "audio/x-musepack"
        "audio/ogg"
        "audio/scpls"
        "audio/x-scpls"
        "audio/vnd.rn-realaudio"
        "audio/wav"
        "audio/x-pn-wav"
        "audio/x-pn-windows-pcm"
        "audio/x-realaudio"
        "audio/x-pn-realaudio"
        "audio/x-ms-wma"
        "audio/x-pls"
        "audio/x-wav"
        "audio/x-ms-asf"
        "audio/x-matroska"
        "audio/webm"
        "audio/vorbis"
        "audio/x-vorbis"
        "audio/x-vorbis+ogg"
        "application/x-shorten"
        "application/x-ogm"
        "application/x-ogm-audio"
        "audio/x-shorten"
        "audio/x-ape"
        "audio/x-wavpack"
        "audio/x-tta"
        "audio/AMR"
        "audio/ac3"
        "audio/eac3"
        "audio/amr-wb"
        "audio/flac"
        "audio/mp4"
        "application/x-mpegurl"
        "application/vnd.apple.mpegurl"
        "audio/x-pn-au"
        "audio/3gpp"
        "audio/3gpp2"
        "audio/dv"
        "audio/opus"
        "audio/vnd.dts"
        "audio/vnd.dts.hd"
        "audio/x-adpcm"
        "application/x-cue"
        "audio/m3u"
      ];

      video = [
        "video/*"
        "video/mpeg"
        "video/x-mpeg2"
        "video/x-mpeg3"
        "video/mp4v-es"
        "video/x-m4v"
        "video/mp4"
        "application/x-extension-mp4"
        "video/divx"
        "video/vnd.divx"
        "video/msvideo"
        "video/x-msvideo"
        "video/ogg"
        "video/quicktime"
        "video/vnd.rn-realvideo"
        "video/x-ms-afs"
        "video/x-ms-asf"
        "application/vnd.ms-asf"
        "video/x-ms-wmv"
        "video/x-ms-wmx"
        "video/x-ms-wvxvideo"
        "video/x-avi"
        "video/avi"
        "video/x-flic"
        "video/fli"
        "video/x-flc"
        "video/flv"
        "video/x-flv"
        "video/x-theora"
        "video/x-theora+ogg"
        "video/x-matroska"
        "video/mkv"
        "application/x-matroska"
        "video/webm"
        "video/x-ogm"
        "video/x-ogm+ogg"
        "video/vnd.mpegurl"
        "video/3gp"
        "video/3gpp"
        "video/3gpp2"
        "application/x-ogm-video"
        "video/mp2t"
        "video/dv"
      ];
    in (lib.genAttrs audio (_: [ "vlc.desktop" ]))
    // (lib.genAttrs video (_: [ "vlc.desktop" ]))
    // (lib.genAttrs image (_: [ "nomacs.desktop" ]))
    // (lib.genAttrs pdf (_: [ "org.pwmt.zathura.desktop" ]))
    // (lib.genAttrs code (_: [ "nvim_terminal.desktop" ]))
    // (lib.genAttrs web (_: [ "firefox.desktop" ]));
  };
}
