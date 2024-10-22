```markdown
# HTB Machine Finder

Este script en Bash te permite buscar información sobre máquinas de Hack The Box (HTB) en un archivo `bundle.js`. Ofrece varias opciones para buscar máquinas por nombre, IP, dificultad o sistema operativo, y también permite descargar o actualizar el archivo `bundle.js` con la información más reciente.

## Requisitos

- Bash
- `curl`: Para descargar archivos de Internet.
- `js-beautify`: Para darle formato al archivo `bundle.js`.
- `sponge`: Para sobrescribir archivos de manera segura.

## Uso

El script ofrece diferentes opciones para interactuar con la base de datos de HTB:

```bash
./htb_finder.sh [opción] [argumento]
```

### Opciones disponibles:

- `-u`: Descargar o actualizar el archivo `bundle.js`.
- `-m [nombre]`: Buscar una máquina por nombre.
- `-i [IP]`: Buscar una máquina por dirección IP.
- `-d [dificultad]`: Buscar máquinas por nivel de dificultad.
- `-s [sistema operativo]`: Buscar máquinas por sistema operativo.
- `-h`: Mostrar el panel de ayuda.

### Ejemplos de uso

1. **Descargar o actualizar archivos necesarios:**

   ```bash
   ./htb_finder.sh -u
   ```

2. **Buscar una máquina por nombre:**

   ```bash
   ./htb_finder.sh -m "NombreDeMaquina"
   ```

3. **Buscar una máquina por IP:**

   ```bash
   ./htb_finder.sh -i "10.10.10.1"
   ```

4. **Buscar máquinas por dificultad:**

   ```bash
   ./htb_finder.sh -d "Facil"
   ```

5. **Buscar máquinas por sistema operativo:**

   ```bash
   ./htb_finder.sh -s "Linux"
   ```

## Contribuciones

Si encuentras algún problema o deseas agregar nuevas funcionalidades, siéntete libre de hacer un fork y abrir un pull request.
