#!/bin/sh

export prefix="${HOME}/.wine/wineprefix"
prefix_waol="${prefix}/Argentum/drive_c/Program Files/Argentum Online Libre/Launcher/Cliente"
prefix_ao="${prefix}/Argentum"
patchv="$(wget -q -O - 'https://github.com/ao-libre/ao-cliente/releases/latest' | cut -d \" -f 2 | grep -o "tag/.*" | sed 's/tag\///g' | tail -n 1 | sed 's/\&quot.*//g')"
patchurl="https://github.com/ao-libre/ao-cliente/releases/download"
aogitv="$(printf "%s\n"  "${patchv}" | tr -d 'v.')"
aolocalv="$(grep 'VERSIONTAGRELEASE' "${prefix_waol}/INIT/Config.ini" | tr -d 'VERSIONTAGLA=v.''\n''\r''\t'' ')"

## FUNCIONES PARA INICIAR/INSTALAR CLIENTE
iniciar_cliente () {
  printf "%s\n"  "INICIANDO EL CLIENTE..."
  WINEDEBUG=fixme-all WINEPREFIX="${prefix_ao}" WINEDEBUG=heap+all wine "${prefix_waol}/Argentum.exe"
}

instalar_cliente () {
  [ ! -e "${patchv}.zip" ] && wget "${patchurl}/${patchv}/${patchv}.zip"
  unzip -q -o "${patchv}.zip" -d "${prefix_waol}"
  chmod 755 -R "${prefix_waol}"
  printf "%s\n"  "INSTALACIÓN FINALIZADA."
}

## COMPRUEBO LA VERSIÓN. SOLO ARRANCA SI ES LA CORRECTA, EN TODOS LOS DEMAS CASOS (POR AHORA) REINSTALA.
if [ "${aogitv}" -lt "${aolocalv}" ]; then
  printf "%s\n"  "TU VERSIÓN ES SUPERIOR A LA DEL SERVIDOR."
  printf "%s\n"  "REINSTALANDO VERSIÓN CORRECTA..."
  instalar_cliente
  iniciar_cliente
elif [ "${aogitv}" -gt "${aolocalv}" ]; then
  printf "%s\n"  "HAY UNA NUEVA VERSIÓN DEL CLIENTE DISPONIBLE."
  printf "%s\n"  "ACTUALIZANDO CLIENTE..."
  instalar_cliente
  iniciar_cliente
elif [ "${aogitv}" -eq "${aolocalv}" ]; then
  printf "%s\n"  "VERSION OK"
  iniciar_cliente
else
  printf "%s\n%s\n"  "NO SE PUEDE INICIAR" "NO SE RECONOCE LA VERSIÓN DEL CLIENTE."
  printf "%s\n"  "REINSTALANDO..."
  instalar_cliente
  iniciar_cliente
fi
