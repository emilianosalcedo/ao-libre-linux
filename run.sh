#!/bin/sh

#######################################
## CONSTANTES
#######################################

readonly prefix="${HOME}/.wine/wineprefix"
readonly prefix_waol="${prefix}/Argentum/drive_c/Program Files/Argentum Online Libre/Launcher/Cliente"
readonly prefix_ao="${prefix}/Argentum"
readonly patchv="$(wget -q -O - 'https://github.com/ao-libre/ao-cliente/releases/latest' | cut -d \" -f 2 | grep -o "tag/.*" | sed 's/tag\///g' | tail -n 1)"
readonly patchurl="https://github.com/ao-libre/ao-cliente/releases/download"
readonly aogitv="$(echo ${patchv} | tr -d 'v.')"
readonly aolocalv="$(grep 'VERSIONTAGRELEASE' "${prefix_waol}/INIT/Config.ini" | tr -d 'VERSIONTAGLA=v.''\n''\r''\t'' ')"

#######################################
## FUNCIONES
#######################################

iniciar_cliente() {
    WINEDEBUG=fixme-all,heap+all WINEPREFIX="${prefix_ao}" wine "${prefix_waol}/Argentum.exe"
}

#######################################
## MAIN
#######################################

if [ "$aogitv" != "$aolocalv" ]; then
        sh "$HOME/.ao-libre-linux/cliente-installer.sh"
        iniciar_cliente
    else
        iniciar_cliente
fi
