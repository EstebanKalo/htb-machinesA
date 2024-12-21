# Script de Gestión de Máquinas de HTB

Este script en Bash permite realizar búsquedas y gestionar información de máquinas de HTB. Utiliza el archivo `bundle.js` para consultar detalles como nombres, direcciones IP, niveles de dificultad y sistemas operativos.

## Requisitos Previos

Asegúrate de tener las siguientes herramientas instaladas antes de usar el script:

- **curl**
- **js-beautify**
- **sponge** 
- **iconv** 
- **tput**
- **md5sum**

## Uso

Ejecuta el script con las siguientes opciones según lo que desees realizar:

### Opciones Disponibles

- **`-u`**  
  Descarga o actualiza el archivo `bundle.js` necesario para realizar las consultas.

- **`-m <nombre>`**  
  Busca una máquina por su nombre.

- **`-i <IP>`**  
  Busca una máquina por su dirección IP.

- **`-d <dificultad>`**  
  Busca máquinas según el nivel de dificultad especificado.

- **`-s <sistema_operativo>`**  
  Busca máquinas según el sistema operativo especificado.

- **`-h`**  
  Muestra el panel de ayuda con información sobre el uso del script.
  

## Notas

- El archivo `bundle.js` es necesario para que el script funcione correctamente. Si no existe, se descargará automáticamente con la opción `-u`.
- Asegúrate de otorgar permisos de ejecución al script:
  ```bash
  chmod +x script.sh
  
