{ lib, ... }:

{
  xdg.mimeApps = let
    # TODO:
    # - Add more programming related text files
    # - Add document types
    directory = [ "inode/directory" ];
    pdf = [ "application/pdf" ];
    image = [
      # Source:
      # - https://github.com/nomacs/nomacs/blob/941f0d/ImageLounge/xgd-data/org.nomacs.ImageLounge.desktop
      # - https://github.com/derf/feh/blob/1d02f9/share/applications/feh.pre
      "image/avif"
      "image/bmp"
      "image/gif"
      "image/heic"
      "image/heif"
      "image/jpg"
      "image/jpeg"
      "image/jxl"
      "image/png"
      "image/pjpeg"
      "image/svg-xml"
      "image/tiff"
      "image/webp"
      "image/x-bmp"
      "image/x-eps"
      "image/x-ico"
      "image/x-pcx"
      "image/x-png"
      "image/x-tga"
      "image/x-portable-anymap"
      "image/x-portable-bitmap"
      "image/x-portable-graymap"
      "image/x-portable-pixmap"
      "image/x-xbitmap"
      "image/x-xpixmap"
    ];

    code = [
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

    setDefault = mimes: apps: lib.genAttrs mimes (_: apps);
  in {
    enable = true;
    associations = {
      removed = { } // (setDefault image [
        "gimp.desktop"
        "org.kde.ark.desktop"
        "feh.desktop"
        "org.xfce.ristretto.desktop"
      ]);
    };
    defaultApplications = (setDefault audio [ "vlc.desktop" ])
      // (setDefault video [ "vlc.desktop" ])
      // (setDefault image [ "org.nomacs.ImageLounge.desktop" "feh.desktop" ])
      // (setDefault pdf [ "org.pwmt.zathura.desktop" "sioyek.desktop" ])
      // (setDefault code [ "nvim.desktop" ])
      // (setDefault web [ "firefox.desktop" ])
      // (setDefault directory [ "thunar.desktop" ]);
  };
}
