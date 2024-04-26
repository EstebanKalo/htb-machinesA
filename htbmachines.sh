#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Funcion Ctrl_c

function ctrl_c(){
 echo -e "\n\n ${redColour}[!] Saliendo... ${endColour}\n"
 tput cnorm && exit 1
}

# Ctrl_C
trap ctrl_c INT

# Variables globales

main_url="https://htbmachines.github.io/bundle.js"


# Funciones

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour} Uso:${endColour}"
  echo -e "\t${purpleColour}u)${endColour}${grayColour} Descargar o actualizar archivos necesarios${endColour}\n"
  echo -e "\t${purpleColour}m)${endColour}${grayColour} Buscar por un nombre de maquina${endColour}\n"
  echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrar este panel de ayuda${endColour}\n"
}

function updateFiles(){
  
  if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos necesarios...${endColour}\n"
    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descarga de archivos completada${endColour}\n"
    tput cnorm
  else
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comprobando si hay actualizaciones...${endColour}"
     curl -s $main_url > bundle_temp.js 
     js-beautify bundle_temp.js | sponge bundle_temp.js
     md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
     md5_original_value=$(md5sum bundle.js | awk '{print $1}')

    if [ "$md5_temp_value" == "$md5_original_value" ]; then
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} No se han detectado actualizaciones, todo al dia :)${endColour}"
      sleep 1

      rm bundle_temp.js
    else 
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se han encontrado actualizaciones disponibles${endColour}" 
      sleep 1

      rm bundle.js && mv bundle_temp.js bundle.js
      echo -e "\n${yellowColour}[+]${endColour}${greenColour} Se han aplicado las actualizaciones${endColour}"
    fi 
     tput cnorm
  fi
}

function searchMachine(){
  machineName="$1"
  
  echo -e "\n${yellowColour}[+]${endColour} Listando las propiedades de la maquina${endColour}${blueColour} ${machineName}${endColour}${grayColour}:${endColour}"
  
  cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//'
}

# Indicadores
declare -i parameter_counter=0 


while getopts "m:uh" arg; do 
 case $arg in 
     m) machineName=$OPTARG; let parameter_counter+=1;;
     u) let parameter_counter+=2;;
     h) ;; 
 esac  
done

if [ $parameter_counter -eq 1 ] ; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
 updateFiles

else
  helpPanel
fi 
