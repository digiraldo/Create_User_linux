#!/bin/bash
# 
# Instrucciones: https://github.com/LomotHo/minecraft-bedrock
# Instrucciones en Español: https://gorobeta.blogspot.com
# Repositorio de GitHub: https://github.com/digiraldo/Minecraft-BE-Server-Panel-Admin-Web

# Colores del terminal
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

# Imprime una línea con color usando códigos de terminal
Print_Style() {
  printf "%s\n" "${2}$1${NORMAL}"
}

# Función para leer la entrada del usuario con un mensaje
function read_with_prompt {
  variable_name="$1"
  prompt="$2"
  default="${3-}"
  unset $variable_name
  while [[ ! -n ${!variable_name} ]]; do
    read -p "$prompt: " $variable_name < /dev/tty
    if [ ! -n "`which xargs`" ]; then
      declare -g $variable_name=$(echo "${!variable_name}" | xargs)
    fi
    declare -g $variable_name=$(echo "${!variable_name}" | head -n1 | awk '{print $1;}')
    if [[ -z ${!variable_name} ]] && [[ -n "$default" ]] ; then
      declare -g $variable_name=$default
    fi
    echo -n "$prompt : ${!variable_name} -- aceptar? (y/n)"
    read answer < /dev/tty
    if [ "$answer" == "${answer#[Yy]}" ]; then
      unset $variable_name
    else
      echo "$prompt: ${!variable_name}"
    fi
  done
}

cd ~

if [ ! -n "`which sudo`" ]; then
  apt-get update && apt-get install sudo -y
fi
sudo apt-get update
sudo apt-get install sed -y

echo "========================================================================="
echo "Crea el Nombre de usuario (predeterminado user): "
Print_Style "Valores permitidos: "Maysculas", "Minusculas": Sin Espacios " "$CYAN"
read_with_prompt UserName "Nombre de Usuario" user
echo "========================================================================="


echo "========================================================================="
Print_Style "Creando Usuario $UserName" "$GREEN"
sudo useradd -u 0 -o -g 0 $UserName
sleep 2s
echo "========================================================================="



echo "========================================================================="
Print_Style "Configurando contraseña del usuario $UserName" "$GREEN"
sudo passwd $UserName
sleep 2s
echo "========================================================================="


echo "========================================================================="
Print_Style "Creando directorio /home/$UserName" "$GREEN"
sudo mkdir /home/$UserName
sleep 2s
echo "========================================================================="


echo "========================================================================="
Print_Style "Creando Grupo para el usuario $UserName" "$GREEN"
sudo chown $UserName:root -R /home/$UserName
sleep 2s
echo "========================================================================="


echo "========================================================================="
Print_Style "Generando Permisos" "$GREEN"
sudo chmod 775 -R /home/$UserName
sleep 2s
echo "========================================================================="


echo "========================================================================="
Print_Style "Asignando Directorio Principal: /home/$UserName   al Usuario: $UserName" "$GREEN"
sudo usermod -d /home/$UserName $UserName
sleep 2s
echo "========================================================================="


echo "========================================================================="
Print_Style "Asignando Grupo: $UserName y root  a Usuario: $UserName" "$GREEN"
sudo adduser $UserName $UserName
sudo adduser $UserName root
sleep 2s
sudo addgroup $UserName
sudo addgroup root
sleep 2s
echo "========================================================================="


echo "========================================================================="
Print_Style "Asignando shell: bash" "$GREEN"
sudo usermod -s /bin/bash
sudo usermod --shell /bin/bash --home /home/$UserName $UserName
cp /etc/skel/.* /home/$UserName/
sleep 2s
echo "========================================================================="


# Print_Style "Asignando permisos root a $UserName" "$MAGENTA"
# sudo sed -i "/Username ALL\=\(ALL\) NOPASSWD\: ALL/d" /etc/sudoers
# sudo sed -i "$a Username ALL\=\(ALL\) NOPASSWD\: ALL" /etc/sudoers
# sudo sed -n "/Username ALL\=\(ALL\) NOPASSWD\: ALL/p" /etc/sudoers

# sudo sed -i "s:Username:$UserName:g" /etc/sudoers



Print_Style "Asignando permisos root a $UserName" "$MAGENTA"
# Elimina lineas que contenga /Username ALL=(ALL) NOPASSWD: ALL
sudo sed -i "/Username ALL\=\(ALL\) NOPASSWD\: ALL/d" /etc/sudoers

# Crea linea /Username ALL=(ALL) NOPASSWD: ALL al final del archivo 
sudo sed -i "$a Username ALL\=\(ALL\) NOPASSWD\: ALL" /etc/sudoers

# Muestra linea /Username ALL=(ALL) NOPASSWD: ALL del archivo
sudo sed -n "/Username ALL\=\(ALL\) NOPASSWD\: ALL/p" /etc/sudoers

# Cambia /Username por el nombre de usuario
sudo sed -i "s:Username:$UserName:g" /etc/sudoers

sudo chmod 755 -R /home/$UserName

sudo rm -rf usr.sh
