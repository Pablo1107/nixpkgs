{ stdenv, fetchFromGitHub, fetchurl, glib, gtk-engine-murrine, gtk_engines, inkscape_0, optipng, sassc, which }:

stdenv.mkDerivation rec {
  pname = "mojave-gtk-theme";
  version = "2019-12-12";

  srcs = [
    (fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = version;
      sha256 = "0d5m9gh97db01ygqlp2sv9v1m183d9fgid9n9wms9r5rrrw6bs8m";
    })
    (fetchurl {
      url = "https://github.com/vinceliuice/Mojave-gtk-theme/raw/11741a99d96953daf9c27e44c94ae50a7247c0ed/macOS_Mojave_Wallpapers.tar.xz";
      sha256 = "18zzkwm1kqzsdaj8swf0xby1n65gxnyslpw4lnxcx1rphip0rwf7";
    })
  ];

  sourceRoot = "source";

  nativeBuildInputs = [ glib inkscape_0 optipng sassc which ];

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    patchShebangs .

    for f in render-assets.sh \
             src/assets/gtk-2.0/render-assets.sh \
             src/assets/gtk-3.0/common-assets/render-assets.sh \
             src/assets/gtk-3.0/windows-assets/render-assets.sh \
             src/assets/metacity-1/render-assets.sh \
             src/assets/xfwm4/render-assets.sh
    do
      substituteInPlace $f \
        --replace /usr/bin/inkscape ${inkscape_0}/bin/inkscape \
        --replace /usr/bin/optipng ${optipng}/bin/optipng
    done

    # Shut up inkscape's warnings
    export HOME="$NIX_BUILD_ROOT"
  '';

  installPhase = ''
    patchShebangs .
    name= ./install.sh -d $out/share/themes
    install -D -t $out/share/wallpapers ../"macOS Mojave Wallpapers"/*
  '';

  meta = with stdenv.lib; {
    description = "Mac OSX Mojave like theme for GTK based desktop environments";
    homepage = https://github.com/vinceliuice/Mojave-gtk-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
