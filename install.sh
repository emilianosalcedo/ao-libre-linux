#!/bin/sh

#######################################
## CONSTANTES
#######################################

readonly dirtemp="${dirtemp:-$HOME/.ao-libre-linux}"
readonly repo="${repo:-RenxoAr/ao-libre-linux}"
readonly remote="${remote:-https://github.com/${repo}.git}"
readonly branch="${branch:-master}"
readonly separador=$(printf "%*s\n" $(tput cols) " " | tr ' ' '=')

#######################################
## FUNCIONES
#######################################

texto_string() {
    printf "%0*s\n" $(( $(tput cols) / 2 )) "${@}";
}

#######################################
## MAIN
#######################################

git clone --branch "${branch}" "${remote}" "${dirtemp}"

echo "${separador}"
texto_string "INSTALANDO"
echo "${separador}"

sh "${dirtemp}"/dependencies.sh
sh "${dirtemp}"/wine-config.sh
sh "${dirtemp}"/cliente-installer.sh

echo "${separador}"
texto_string "FINALIZADO"
echo "${separador}"

sh "${dirtemp}"/run.sh
