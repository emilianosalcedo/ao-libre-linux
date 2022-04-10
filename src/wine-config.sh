#!/bin/sh

export prefix="${HOME}/.wine/wineprefix"
wprefix="Argentum"
prefix_ao="${prefix}/${wprefix}"
prefixshare="${prefix}/share/wine"
prefixcache="${HOME}/.cache/wine"
monov="5.1.0"
geckov="2.47.1"
urlmono="http://dl.winehq.org/wine/wine-mono/${monov}/wine-mono-${monov}-x86.msi"
urlgecko="http://dl.winehq.org/wine/wine-gecko/${geckov}/wine-gecko-${geckov}-x86.msi"

[ ! -d "${HOME}/.wine" ] && mkdir "${HOME}/.wine"
[ ! -d "${prefix}" ] && mkdir -p "${prefix}"
[ ! -d "${prefix_ao}" ] && mkdir -p "${prefix_ao}"
{ [ ! -d "${prefixshare}/mono" ] && [ ! -d "${prefixshare}/gecko" ]; } && mkdir -p "${prefixshare}/"{mono,gecko}

## GECKO (IE) Y MONO (.NET) PARA WINE
dl() {
  if [ ! -e "${1}" ]; then
    wget -P "${2}" "${3}"
  fi
}

dl "${HOME}/.cache/wine/wine-mono-${monov}-x86.msi" "${prefixcache}" "${urlmono}"
dl "${HOME}/.cache/wine/wine-gecko-${geckov}-x86.msi" "${prefixcache}" "${urlgecko}"
cp "${prefixcache}/wine-mono-${monov}-x86.msi" "${prefixshare}/mono"
cp "${prefixcache}/wine-gecko-${geckov}-x86.msi" "${prefixshare}/gecko"

WINEDEBUG=fixme-all WINEPREFIX="${prefix_ao}" WINEARCH=win32 winetricks win7
WINEDEBUG=fixme-all WINEPREFIX="${prefix_ao}" wine msiexec /i "${prefixshare}/mono/wine-mono-${monov}-x86.msi"
WINEDEBUG=fixme-all WINEPREFIX="${prefix_ao}" wine msiexec /i "${prefixshare}/wine/gecko/wine-gecko-${geckov}-x86.msi"
