#!/bin/sh

export prefix="${HOME}/.wine/wineprefix"
wprefix="Argentum"
prefix_ao="${prefix}/${wprefix}"
prefix_waol="${prefix_ao}/drive_c/Program Files/Argentum Online Libre/Launcher/Cliente"
patchurl="https://github.com/ao-libre/ao-cliente/releases/download"
launchurl="https://github.com/ao-libre/ao-autoupdate/releases/download"
patchv="$(wget -q -O - 'https://github.com/ao-libre/ao-cliente/releases/latest' | cut -d \" -f 2 | grep -o "tag/.*" | sed 's/tag\///g' | tail -n 1 | sed 's/\&quot.*//g')"
launchv="$(wget -q -O - 'https://github.com/ao-libre/ao-autoupdate/releases/latest' | cut -d \" -f 2 | grep -o "tag/.*" | sed 's/tag\///g' | tail -n 1 | sed 's/\&quot.*//g')"
vmcheck="$(cat /sys/class/dmi/id/product_name)"
installer="aolibre-installer-${launchv}.exe"

## SIMPLIFICO LAS LLAMADAS A WINE Y WINETRICKS
wine_ao () {
  WINEDEBUG=fixme-all WINEPREFIX="${prefix_ao}" wine "${*}"
}

winets_ao () {
  WINEDEBUG=fixme-all WINEPREFIX="${prefix_ao}" winetricks -q "${*}"
}

## INSTALACION
[ ! -e "${installer}" ] && wget "${launchurl}/${launchv}/${installer}"
[ ! -e "${patchv}.zip" ] && wget "${patchurl}/${patchv}/${patchv}.zip"
[ ! -d "${prefix_waol}" ] && mkdir -p "${prefix_waol}"

wine_ao "${installer}"
winets_ao mfc42 vcrun2013 vb6run riched20 riched30 directmusic native_oleaut32 ## DLL

mv "${prefix_waol}/Init" INIT
unzip -q -o "${patchv}.zip" -d "${prefix_waol}"
chmod 755 -R "${prefix_waol}"

## REGISTROS
cat <<EOF > "${prefix_waol}/ao_winxp.reg"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Wine\AppDefaults\Argentum.exe]

"Version"="winxp"
EOF

## OPENGL / DIRECT3D
cat <<EOF > "${prefix_waol}/d3dopengl.reg"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Wine\AppDefaults\Argentum.exe\Direct3D]

"DirectDrawRenderer"="opengl"
EOF

## LIBRERIAS
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

WINEDEBUG=fixme-all WINEPREFIX="${prefix_ao}" wine regedit "${prefix_waol}/ao_winxp.reg"
WINEDEBUG=fixme-all WINEPREFIX="${prefix_ao}" wine regedit "${prefix_waol}/d3dopengl.reg"
WINEDEBUG=fixme-all WINEPREFIX="${prefix_ao}" wine regedit "${prefix_waol}/dlloverrides.reg"
[ "${vmcheck}" = "VirtualBox" ] && winets_ao videomemorysize=512 ## MEMORIA DE VIDEO DE LA VM
