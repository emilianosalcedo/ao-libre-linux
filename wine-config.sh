#!/bin/sh

#######################################
## CONSTANTES
#######################################

readonly prefix="${HOME}/.wine/wineprefix"
readonly wprefix="Argentum"
readonly prefix_ao="${prefix}/${wprefix}"
readonly prefixshare="${prefix}/share/wine"
readonly prefixcache="${HOME}/.cache/wine"
readonly monov="5.1.0"
readonly geckov="2.47.1"
readonly urlmono="http://dl.winehq.org/wine/wine-mono/${monov}/wine-mono-${monov}-x86.msi"
readonly urlgecko="http://dl.winehq.org/wine/wine-gecko/${geckov}/wine-gecko-${geckov}-x86.msi"
readonly args="WINEDEBUG=fixme-all WINEPREFIX=${prefix_ao}"

#######################################
## MAIN
#######################################

[ ! -d "${prefix_ao}" ] && mkdir -p "${prefix_ao}"
{ [ ! -d "${prefixshare}/mono" -a ! -d "${prefixshare}/gecko" ]; } && mkdir -p "${prefixshare}/"{mono,gecko}

## GECKO (IE) Y MONO (.NET) PARA WINE

if [ ! -e "${HOME}/.cache/wine/wine-mono-${monov}-x86.msi" ]; then
    wget -q --show-progress -P "${prefixcache}" "${urlmono}"
fi

if [ ! -e "${HOME}/.cache/wine/wine-gecko-${geckov}-x86.msi" ]; then
    wget -q --show-progress -P "${prefixcache}" "${urlgecko}"
fi

cp "${prefixcache}/wine-mono-${monov}-x86.msi" "${prefixshare}/mono"
cp "${prefixcache}/wine-gecko-${geckov}-x86.msi" "${prefixshare}/gecko"

${args} WINEARCH=win32 winetricks win7
${args} wine msiexec /i "${prefixshare}/mono/wine-mono-${monov}-x86.msi"
${args} wine msiexec /i "${prefixshare}/wine/gecko/wine-gecko-${geckov}-x86.msi"
