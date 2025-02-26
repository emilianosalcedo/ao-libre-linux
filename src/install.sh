#!/bin/sh

dirtemp="${dirtemp:-$HOME/.ao-libre-linux}"
repo="${repo:-RenxoAr/ao-libre-linux}"
remote="${remote:-https://github.com/${repo}.git}"
branch="${branch:-master}"
separador=$(printf "%*s\n" $(tput cols) " " | tr ' ' '=')
texto_string() { printf "%0*s\n" $(( $(tput cols) / 2 )) "${@}"; }

git clone --branch "${branch}" "${remote}" "${dirtemp}"

printf "%s\n" "${separador}"
texto_string "INSTALANDO"
printf "%s\n" "${separador}"

sh "${dirtemp}"/src/dependencies.sh
sh "${dirtemp}"/src/wine-config.sh
sh "${dirtemp}"/src/cliente-installer.sh

printf "%s\n" "${separador}"
texto_string "FINALIZADO"
printf "%s\n" "${separador}"

sh "${dirtemp}"/src/run.sh
