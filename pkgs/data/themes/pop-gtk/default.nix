{ stdenv
, fetchFromGitHub
, meson
, ninja
, sassc
, gtk3
, inkscape_0
, optipng
, gtk-engine-murrine
, gdk-pixbuf
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "pop-gtk-theme";
  version = "2019-12-17";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "gtk-theme";
    rev = "77601545f049251bce9c63a07f0d9819aa27cb60";
    sha256 = "0bmkcdr1z9m3inrw33zprq2a4jawql4724a84nr89r19xllj2z1s";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
    gtk3
    inkscape_0
    optipng
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  postPatch = ''
    for file in $(find -name render-\*.sh); do
      patchShebangs "$file"

      substituteInPlace "$file" \
        --replace 'INKSCAPE="/usr/bin/inkscape"' \
                  'INKSCAPE="${inkscape_0}/bin/inkscape"' \
        --replace 'OPTIPNG="/usr/bin/optipng"' \
                  'OPTIPNG="${optipng}/bin/optipng"'
    done
  '';

  meta = with stdenv.lib; {
    description = "System76 Pop GTK+ Theme";
    homepage = "https://github.com/pop-os/gtk-theme";
    license = with licenses; [ gpl3 lgpl21 cc-by-sa-40 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ elyhaka ];
  };
}
