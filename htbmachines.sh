# Colours
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
  echo -e "\t${purpleColour}i)${endColour} ${grayColour}Buscar por direccion IP${endColour}\n"
  echo -e "\t${purpleColour}d)${endColour}${grayColour} Buscar por el nivel de dificultad de la maquina${endColour}\n"
  echo -e "\t${purpleColour}s)${endColour}${grayColour} Buscar por el sistema operativo de la maquina${endColour}\n"
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

function normalizeText(){
  echo "$1" | iconv -f utf8 -t ascii//TRANSLIT | tr '[:upper:]' '[:lower:]'
}

function searchMachine(){
  machineName=$(normalizeText "$1")

  machineName_checker=$(cat bundle.js | iconv -f utf8 -t ascii//TRANSLIT | grep -i "name: \"$machineName\"" -A 5 | awk '/name:/{print}' | tr -d '"' | tr -d ',' | sed 's/^ *//')

  if [ "$machineName_checker" ] ; then
    echo -e "\n${yellowColour}[+]${endColour} Listando las propiedades de la maquina${endColour}${blueColour} ${1}${endColour}${grayColour}:${endColour}"
    cat bundle.js | iconv -f utf8 -t ascii//TRANSLIT | grep -i "name: \"$machineName\"" -A 5 | awk '{print}' | tr -d '"' | tr -d ',' | sed 's/^ *//'
  else
    echo -e "\n${yellowColour}[!]${endColour}${redColour} La maquina proporcionada no existe${endColour}"
  fi 
}

function searchIP(){
  ipAddress="$1"

  machineName=$(cat bundle.js | iconv -f utf8 -t ascii//TRANSLIT | grep "ip: \"$ipAddress\"" -B 3 | grep -i "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',') 
  
  if [ "$machineName" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} La maquina correspondiente para la IP${endColour}${blueColour} $ipAddress${endColour}${grayColour} es${endColour}${purpleColour} $machineName${endColour}\n"
  else
    echo -e "\n${yellowColour}[!]${endColour}${redColour} La IP proporcionada no existe${endColour}"
  fi
}

function getMachinesDifficulty(){
  difficulty=$(normalizeText "$1")

  resultsCheckDifficulty=$(cat bundle.js | iconv -f utf8 -t ascii//TRANSLIT | grep -i "dificultad: \"$difficulty\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)

  if [ "$resultsCheckDifficulty" ]; then
    echo -e "\n${yellowColour}[+]${grayColour} Representando las maquinas que poseen el nivel de dificultad${endColour}${purpleColour} $1${endColour}${grayColour}:${endColour}\n"
    echo "$resultsCheckDifficulty"
  else 
    echo -e "\n${yellowColour}[!]${endColour}${redColour} La dificultad indicada no existe${endColour}"
  fi
}

function getOperativeSystem(){
  operativeSystem=$(normalizeText "$1")

  resultsCheckSO=$(cat bundle.js | iconv -f utf8 -t ascii//TRANSLIT | grep -i "so: \"$operativeSystem\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)

  if [ "$resultsCheckSO" ] ; then
  echo -e "\n${yellowColour}[+]${grayColour} Representando las maquinas con sistema operativo${endColour}${purpleColour} $1${endColour}${grayColour}:${endColour}\n"
  echo "$resultsCheckSO"
  else
    echo -e "\n${yellowColour}[!]${endColour}${redColour} El sistema operativo buscado no existe${endColour}"
  fi
}

# Indicadores
declare -i parameter_counter=0 

# Delatores
declare -i delator_difficulty=0
declare -i delator_os=0

while getopts "m:ui:d:hs:" arg; do 
 case $arg in 
     m) machineName="$OPTARG"; let parameter_counter+=1;;
     u) let parameter_counter+=2;;
     i) ipAddress="$OPTARG"; let parameter_counter+=3;;
     d) difficulty="$OPTARG"; delator_difficulty=1; let parameter_counter+=4;;
     s) operativeSystem="$OPTARG"; delator_os=1; let parameter_counter+=5;;
     h) ;; 
 esac  
done

# Validadores

if [ $parameter_counter -eq 1 ] ; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIP $ipAddress
elif [ $parameter_counter -eq 4 ]; then
  getMachinesDifficulty $difficulty
elif [ $parameter_counter -eq 5 ]; then
getOperativeSystem $operativeSystem
else
  helpPanel
fi
