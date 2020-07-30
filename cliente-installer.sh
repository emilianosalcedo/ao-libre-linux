#!/bin/sh

#######################################
## CONSTANTES
#######################################

readonly prefix="${HOME}/.wine/wineprefix"
readonly wprefix="Argentum"
readonly prefix_ao="${prefix}/${wprefix}"
readonly prefix_waol="${prefix_ao}/drive_c/Program Files/Argentum Online Libre/Launcher/Cliente"
readonly prefixS32="${prefix_ao}/drive_c/windows/system32"
readonly prefixC="${prefix_ao}/drive_c"
readonly patchurl="https://github.com/ao-libre/ao-cliente/releases/download"
readonly launchurl="https://github.com/ao-libre/ao-autoupdate/releases/download"
readonly patchv="$(wget -q -O - 'https://github.com/ao-libre/ao-cliente/releases/latest' | cut -d \" -f 2 | grep -o "tag/.*" | sed 's/tag\///g' | tail -n 1)"
readonly launchv="$(wget -q -O - 'https://github.com/ao-libre/ao-autoupdate/releases/latest' | cut -d \" -f 2 | grep -o "tag/.*" | sed 's/tag\///g' | tail -n 1)"
readonly vmcheck="$(cat /sys/class/dmi/id/product_name)"
readonly workdir="${HOME}/.ao-libre-linux/temp"
readonly args="WINEDEBUG=fixme-all,warn+dll WINEPREFIX=${prefix_ao}"

#######################################
## FUNCIONES
#######################################

wine_ao() {
    ${args} wine "${@}";
}

winets_ao() {
    ${args} winetricks -q "${@}";
}

#######################################
## INSTALACION
#######################################

[ ! -d "${workdir}" ] && mkdir -p "${workdir}"
[ ! -d "${prefix_waol}" ] && mkdir -p "${prefix_waol}"
[ ! -e "${workdir}/aolibre-installer-${launchv}.exe" ] && wget -q --show-progress -P "${workdir}" "${launchurl}/${launchv}/aolibre-installer-${launchv}.exe"
[ ! -e "${workdir}/${patchv}.zip" ] && wget -q --show-progress -P "${workdir}" "${patchurl}/${patchv}/${patchv}.zip"

wine_ao "${workdir}/aolibre-installer-${launchv}.exe"
winets_ao mfc42 vcrun2013 vb6run riched20 riched30 directmusic native_oleaut32 ## DLLS

mv "${prefix_waol}/Init" "${prefix_waol}/INIT"
unzip -q -o "${workdir}/${patchv}.zip" -d "${prefix_waol}"
chmod 755 -R "${prefix_waol}"

#######################################
## REGISTROS
#######################################

cat <<EOF > "${prefix_waol}/ao_winxp.reg"
Windows Registry Editor Version 5.00



[HKEY_CURRENT_USER\Software\Wine\AppDefaults\Argentum.exe]

"Version"="winxp"



EOF

cat <<EOF > "${prefix_waol}/d3dopengl.reg"
Windows Registry Editor Version 5.00



[HKEY_CURRENT_USER\Software\Wine\AppDefaults\Argentum.exe\Direct3D]

"DirectDrawRenderer"="gdi"



EOF

cat <<EOF > "${prefix_waol}/dlloverrides.reg"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Wine\DllOverrides]
"*atl120"="native,builtin"
"*devenum"="native"
"*dmband"="native"
"*dmcompos"="native"
"*dmime"="native"
"*dmloader"="native"
"*dmscript"="native"
"*dmstyle"="native"
"*dmsynth"="native"
"*dmusic"="native"
"*dmusic32"="native"
"*dswave"="native"
"*mfc42"="native"
"*mfc42u"="native"
"*msvcp120"="native,builtin"
"*msvcr120"="native,builtin"
"*oleaut32"="native,builtin"
"*quartz"="native"
"*riched20"="native,builtin"
"*riched32"="native,builtin"
"*streamci"="native"
"*vcomp120"="native,builtin"
EOF

wine_ao regedit "${prefix_waol}/ao_winxp.reg"
wine_ao regedit "${prefix_waol}/d3dopengl.reg"
wine_ao regedit "${prefix_waol}/dlloverrides.reg"
{ [ "${vmcheck}" = "VirtualBox" ] || [ "${vmcheck}" = "VMWare Virtual Platform" ]; } && winets_ao videomemorysize=512
