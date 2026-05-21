#!/bin/bash

# Debe ejecutarse como root
[[ $EUID -ne 0 ]] && echo "Ejecuta como root" && exit 1

# Colores
R='\033[1;31m'
G='\033[1;32m'
C='\033[1;36m'
W='\033[1;37m'
N='\033[0m'

set_password() {
while true; do
echo
read -p "Nueva contraseña: " pass1
echo
read -p "Confirmar contraseña: " pass2
echo

if [[ -z "$pass1" || -z "$pass2" ]]; then
    echo -e "${R}✗ La contraseña no puede estar vacía${N}"
    continue
fi

if [[ "$pass1" != "$pass2" ]]; then
    echo -e "${R}✗ Las contraseñas no coinciden${N}"
    continue
fi

echo "root:$pass1" | chpasswd >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo
    echo -e "${G}✓ Contraseña actualizada correctamente${N}"
    return 0
else
    echo
    echo -e "${R}✗ Error al actualizar contraseña${N}"
    return 1
fi
done
}

while true; do
clear

echo -e "${C}"
echo "╔══════════════════════════════════════╗"
echo "║          VPS DARNIX PANEL           ║"
echo "║         Configuración rápida        ║"
echo "╠══════════════════════════════════════╣"
echo -e "${W}║ ${G}[1]${W} Cambiar contraseña root      ║"
echo -e "║ ${G}[2]${W} Activar acceso con contraseña║"
echo -e "║ ${R}[0]${W} Salir                         ║"
echo -e "${C}╚══════════════════════════════════════╝${N}"
echo

read -p "Selecciona una opción: " op

case $op in

1)
clear
echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
echo -e "${W}       Cambiar contraseña Root"
echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"

set_password

echo
read -p "Presiona Enter para continuar..."
;;

2)
clear
echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
echo -e "${W}      Activar acceso por contraseña"
echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"

echo
echo "Primero crea una contraseña:"
set_password || continue

echo
echo "Configurando acceso..."
sleep 1

sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config >/dev/null 2>&1
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config >/dev/null 2>&1

systemctl restart ssh >/dev/null 2>&1 || systemctl restart sshd >/dev/null 2>&1

echo
echo -e "${G}✓ Acceso configurado correctamente${N}"
echo -e "${G}✓ Ya puedes ingresar usando contraseña${N}"

echo
read -p "Presiona Enter para continuar..."
;;

0)
clear
echo -e "${G}Hasta luego${N}"
sleep 1
exit
;;

*)
echo
echo -e "${R}✗ Opción inválida${N}"
sleep 1
;;
esac

done
